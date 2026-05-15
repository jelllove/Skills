<#
.SYNOPSIS
  Upload local image assets referenced by a WeChat-article Markdown file to
  Azure Blob Storage, and rewrite the Markdown to point at the resulting
  public blob URLs.

.DESCRIPTION
  Workflow:
    1. Scan the given Markdown file for image references whose path starts
       with `assets/` (local relative paths produced by the daily-news skill).
    2. For each referenced file that exists on disk, upload it to a blob
       container.
    3. Rewrite the Markdown so each local path is replaced by the blob's
       public URL (https://<account>.blob.core.windows.net/<container>/<blob>
       or, when container is $web, the Static Website endpoint URL).
    4. Write the rewritten Markdown to a sibling file with `.cloud.md` suffix
       (or overwrite the original when `-InPlace` is set).

  Authentication uses Azure CLI (`az`) with one of the following modes
  (priority order):
    1. Connection string: $env:AZURE_STORAGE_CONNECTION_STRING
    2. Access key:        -StorageKey / $env:DAILY_NEWS_STORAGE_KEY / $env:AZURE_STORAGE_KEY
    3. Azure AD login:    `az login` + RBAC (Storage Blob Data Contributor)

.PARAMETER MarkdownFile
  Path to the Markdown article whose image references should be rewritten.

.PARAMETER StorageAccount
  Storage account name. Defaults to $env:DAILY_NEWS_STORAGE_ACCOUNT.

.PARAMETER Container
  Blob container name (must allow anonymous blob read, or you must front it
  with a SAS / CDN). Defaults to $env:DAILY_NEWS_STORAGE_CONTAINER or "wechat-assets".

.PARAMETER StorageKey
  Storage account key. Defaults to:
  1) -StorageKey
  2) $env:DAILY_NEWS_STORAGE_KEY
  3) $env:AZURE_STORAGE_KEY

.PARAMETER WebEndpoint
  Static website endpoint base URL (used when Container is `$web`).
  Defaults to $env:DAILY_NEWS_WEB_ENDPOINT, else "https://<account>.web.core.windows.net".

.PARAMETER Prefix
  Optional virtual-folder prefix inside the container. Defaults to the
  Markdown file's parent assets folder name (e.g. `wechat-20260514`).

.PARAMETER InPlace
  Rewrite the Markdown file in place instead of producing a `.cloud.md` copy.

.EXAMPLE
  ./upload-to-azure.ps1 -MarkdownFile .\Copilot_20260514_WeChat_Apple-AI-Agents-App-Store.md `
                       -StorageAccount mystorageacct -Container wechat-assets -InPlace
#>

[CmdletBinding()]
param(
  [Parameter(Mandatory = $true)][string]$MarkdownFile,
  [string]$StorageAccount = $env:DAILY_NEWS_STORAGE_ACCOUNT,
  [string]$Container      = $(if ($env:DAILY_NEWS_STORAGE_CONTAINER) { $env:DAILY_NEWS_STORAGE_CONTAINER } else { 'wechat-assets' }),
  [string]$StorageKey = $(if ($env:DAILY_NEWS_STORAGE_KEY) { $env:DAILY_NEWS_STORAGE_KEY } else { $env:AZURE_STORAGE_KEY }),
  [string]$WebEndpoint = $env:DAILY_NEWS_WEB_ENDPOINT,
  [string]$Prefix,
  [switch]$InPlace
)

$ErrorActionPreference = 'Stop'

# --- Validation ---------------------------------------------------------------
if (-not (Test-Path $MarkdownFile)) {
  throw "Markdown file not found: $MarkdownFile"
}
if (-not $StorageAccount) {
  throw "StorageAccount not provided. Pass -StorageAccount or set `$env:DAILY_NEWS_STORAGE_ACCOUNT."
}
if (-not (Get-Command az -ErrorAction SilentlyContinue)) {
  throw "Azure CLI (az) not found in PATH. Install from https://aka.ms/azcli"
}

$mdPath  = (Resolve-Path $MarkdownFile).Path
$mdDir   = Split-Path -Parent $mdPath
$content = Get-Content -Raw -LiteralPath $mdPath

# --- Decide auth mode ---------------------------------------------------------
$useConnString = [bool]$env:AZURE_STORAGE_CONNECTION_STRING
$useAccessKey = -not [string]::IsNullOrWhiteSpace($StorageKey)

$authModeDescription = $null
$authArgs = if ($useConnString) {
  $authModeDescription = 'connection-string'
  @('--connection-string', $env:AZURE_STORAGE_CONNECTION_STRING)
} elseif ($useAccessKey) {
  $authModeDescription = 'account-key'
  @('--account-name', $StorageAccount, '--account-key', $StorageKey)
} else {
  $authModeDescription = 'az-login'
  @('--account-name', $StorageAccount, '--auth-mode', 'login')
}

Write-Host "Auth mode: $authModeDescription"

# --- Ensure container exists --------------------------------------------------
Write-Host "Ensuring container '$Container' exists on '$StorageAccount'..."
$null = az storage container create `
  --name $Container `
  --public-access blob `
  @authArgs `
  --only-show-errors 2>$null

# --- Find image references ----------------------------------------------------
# Match Markdown image syntax: ![alt](relative/path/to/image.ext)
$pattern = '!\[[^\]]*\]\((?<path>assets/[^)\s]+)\)'
$imageMatches = [System.Text.RegularExpressions.Regex]::Matches($content, $pattern)

if ($imageMatches.Count -eq 0) {
  Write-Warning "No local assets/* image references found in $MarkdownFile. Nothing to do."
  return
}

Write-Host "Found $($imageMatches.Count) image reference(s) to process."

# --- Upload each unique file --------------------------------------------------
$uploadedMap = @{}   # local relative path -> public URL
foreach ($m in $imageMatches) {
  $relPath = $m.Groups['path'].Value
  if ($uploadedMap.ContainsKey($relPath)) { continue }

  $localPath = Join-Path $mdDir $relPath
  if (-not (Test-Path $localPath)) {
    Write-Warning "  ! Missing local file, skipping: $relPath"
    continue
  }

  # Compute blob name: <Prefix>/<filename> if Prefix supplied,
  # else preserve the sub-path under assets/.
  $blobName = if ($Prefix) {
    "$Prefix/" + (Split-Path -Leaf $relPath)
  } else {
    $relPath -replace '^assets/', ''
  }

  Write-Host "  + Uploading $relPath -> $Container/$blobName"
  az storage blob upload `
    --container-name $Container `
    --file $localPath `
    --name $blobName `
    --overwrite `
    @authArgs `
    --only-show-errors | Out-Null

  if ($Container -eq '$web') {
    $baseWebEndpoint = if ($WebEndpoint) { $WebEndpoint.TrimEnd('/') } else { "https://$StorageAccount.web.core.windows.net" }
    $url = "$baseWebEndpoint/$([uri]::EscapeUriString($blobName))"
  } else {
    $url = "https://$StorageAccount.blob.core.windows.net/$Container/$([uri]::EscapeUriString($blobName))"
  }
  $uploadedMap[$relPath] = $url
}

if ($uploadedMap.Count -eq 0) {
  Write-Warning "Nothing uploaded. Markdown left unchanged."
  return
}

# --- Rewrite Markdown ---------------------------------------------------------
$newContent = $content
foreach ($kv in $uploadedMap.GetEnumerator()) {
  $escaped     = [regex]::Escape($kv.Key)
  $newContent  = [System.Text.RegularExpressions.Regex]::Replace(
    $newContent,
    "\($escaped\)",
    "($($kv.Value))"
  )
}

$outPath = if ($InPlace) { $mdPath } else {
  [System.IO.Path]::ChangeExtension($mdPath, '.cloud.md')
}
Set-Content -LiteralPath $outPath -Value $newContent -NoNewline -Encoding utf8

Write-Host ""
Write-Host "Done."
Write-Host "  Uploaded files : $($uploadedMap.Count)"
Write-Host "  Output Markdown: $outPath"
Write-Host ""
Write-Host "Uploaded URL map:"
$uploadedMap.GetEnumerator() | Sort-Object Key | ForEach-Object {
  Write-Host ("  {0}`n      -> {1}" -f $_.Key, $_.Value)
}
