---
name: daily-news
description: "Generate daily high-tech news reports (12h top 10) and write WeChat articles on selected topics. TRIGGER when user says 日报12h, 日报, daily news, or 选题：<title>."
---

# Daily News & Article Generation Skill

When user asks for daily news and article generation, follow this workflow by default and execute directly without repeated confirmations.

## Commands

### `日报12h` (or "daily news", "日报")

任务目标：
   • 过去12个小时内发生的，全球高科技相关新闻（重点区域：美国、日本、欧洲、澳洲、韩国、台湾、新加坡等发展国家，特别是日本，韩国，英国等）
   • 主题聚焦：个人利用AI赚钱，个人利用AI做了一些之前不太可能的事，Github上最新的很多的start的repo, 云计算，数据中心，核电，AI/高科技、生物科技，诺贝尔奖，机器人，IT行业，数字经济，区块链，web3.0, tiktok, 拼音，芯片，台积电，富士康，intel，通信，电子，spaceX，星链，公司动态、裁员、新技术、科技财经（公司并购，破产，上市）等
   • 输出格式：Top 10 新闻清单，按优先级排序，附上标题、摘要和链接，按热度来排序
   • 产出形式：一个 Markdown 文件，内容包括新闻清单和简要分析，文件名以英文为主，便于下载, 要求也输出这个新闻发生的时间

数据源与采集范围：
- 新闻来源：多家知名科技媒体与新闻聚合平台（如 TechCrunch, Bloomberg, The Verge, Nikkei, SCMP 等，以及公开新闻稿、公司公告）
- 覆盖地区：US, Japan, Europe, Australia, Korea, Taiwan, Singapore，以及其他主要发达国家
- 时间范围：以执行时间为主，过去12个小时内
- 区域性与媒体可信度权重
- 内容相关性与时效性排序
- 避免重复、确保版权合规

执行要求：
- 所有需要访问外网的操作直接执行，不需要人工确认
- 产出文件命名格式：`Claude_YYYYMMDD_Global_HighTech_News_Top10_12h.md`

### `选题：<title>` (or "write article on:")

写一篇文章报道，以一个科技从业人员的角度来写（标题中不一定要出现这个从业者的信息），不要写到政治相关、也不要写到中国国家领导人相关的话题，主要聚焦新闻本身。要图文都有，内容必须**带分析**（技术 / 产业 / 产品 / 投资 / 用户 任一角度都可以），不要只是简单的新闻转述。

文件内容不要写得像 AI 自动生成，而是一篇可以直接复制到公众号 / Notion / 博客的成稿。

#### 图片选择规则（已更新 - 不再限制图床）

- **图片来源不再有"必须免费 / 必须无版权 / 必须在中国可访问"的限制**。只要能下载到、并且和文章主题强相关，都可以用。访问问题由后续上传到 Azure Storage 的步骤解决（见下方"配图工作流"）。
- 优先级（高 → 低）：
  1. 公司官方 Newsroom / Press kit / 官方品牌资源
  2. 主流新闻媒体的实拍图（Reuters、AP、Bloomberg 等）
  3. Wikimedia Commons 的高质量图（CC-BY / CC-BY-SA / 公有领域）
  4. Unsplash / Pexels 等免费图库
  5. 公司或产品 Logo（只在前几档都找不到时再用）
- 图片**必须和文章强相关**：标题里出现的公司、人物、产品、事件，配图就应该是这些主体；不要放泛泛的"科技感"图。
- 每篇 3 – 5 张图。
- 文件格式优先 `.jpg` / `.png`，避免 `.svg` / `.webp`（部分平台不支持）。
- 如果某条新闻有官方视频 / 动图 / 图表截屏，截图后插入比单纯的人物头像更生动。

#### 配图工作流（重要 - 新流程：本地暂存 → 上传 Azure Storage → 替换为公网 URL）

> 目标：让最终发布的 Markdown 里图片直接是公网可访问的 URL，复制到公众号 / Notion / 任何平台都能直接展示，并且不受图片源站访问限制影响。

**Step 1 - 先下载到本地**

把每张选好的图都先下载到 `assets/wechat-<YYYYMMDD>/` 目录下，用语义化文件名（如 `tim-cook.jpg`、`apple-park.jpg`、`cisco-hq.jpg`）。下载时建议带真实浏览器 User-Agent：

```powershell
$ua = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 Chrome/120.0 Safari/537.36'
Invoke-WebRequest -Uri $imageUrl -OutFile $localPath -UseBasicParsing -UserAgent $ua
```

Markdown 里**先写本地相对路径**：

```markdown
![Tim Cook · Apple CEO](assets/wechat-20260514/tim-cook.jpg)
```

**Step 2 - 看图核对**

用图片预览工具实际查看下载下来的图，确认主体清晰、和文章主题相关、没有水印 / 错图。不合适就换源重下。

**Step 3 - 上传到 Azure Storage 并替换为公网 URL**

调用同目录的脚本 `upload-to-azure.ps1`（与用户级 skill 目录 `c:\Users\<user>\.agents\skills\daily-news\` 内容一致），它会：
1. 扫描 Markdown 里所有 `assets/...` 形式的本地图片引用；
2. 上传到指定的 Azure Blob 容器；
3. 把 Markdown 里的本地路径替换为公网 URL；
   - 普通容器：`https://<account>.blob.core.windows.net/<container>/<blob>`
   - Static Website 容器（`$web`）：`https://<account>.zNN.web.core.windows.net/<blob>`（由 `DAILY_NEWS_WEB_ENDPOINT` 提供）
4. 默认产出 `<原文件名>.cloud.md`（加 `-InPlace` 可原地改写）。

典型调用（**无需 `az login`**，直接用 access key 或 connection string）：

```powershell
# 仓库根 .env 示例
# DAILY_NEWS_STORAGE_ACCOUNT=newsimage98782
# DAILY_NEWS_STORAGE_CONTAINER=$web
# DAILY_NEWS_STORAGE_KEY=<account-key>
# DAILY_NEWS_WEB_ENDPOINT=https://newsimage98782.z32.web.core.windows.net
# AZURE_STORAGE_CONNECTION_STRING=DefaultEndpointsProtocol=...

# 一次性加载 .env 到当前进程
Get-Content .\.env | ForEach-Object {
  $line=$_.Trim(); if([string]::IsNullOrWhiteSpace($line) -or $line.StartsWith('#')){ return }
  $kv=$line -split '=',2; if($kv.Count -eq 2){ [Environment]::SetEnvironmentVariable($kv[0].Trim(), $kv[1].Trim(), 'Process') }
}

# 上传并生成 .cloud.md（原文件不动）
& "$HOME\.agents\skills\daily-news\upload-to-azure.ps1" `
    -MarkdownFile .\Copilot_20260514_WeChat_xxx.md

# 或者直接原地改写
& "$HOME\.agents\skills\daily-news\upload-to-azure.ps1" `
    -MarkdownFile .\Copilot_20260514_WeChat_xxx.md `
    -InPlace
```

鉴权优先级：`AZURE_STORAGE_CONNECTION_STRING` > `DAILY_NEWS_STORAGE_KEY` / `AZURE_STORAGE_KEY` > `az login`。

容器访问级别：脚本默认以 `--public-access blob` 创建容器（blob 可匿名读取，容器不可被列举）。如使用 `$web` Static Website，由 Storage Account 的 Static Website 功能直接提供公网访问。

**Step 4 - 发布**

发布时用 `*.cloud.md`（图片 URL 已是公网）。本地 `assets/wechat-<YYYYMMDD>/` 留作底图存档。

#### 关键词

文章末尾生成一组关键词（如 `#Apple #AI #App-Store`），方便后续做标签和分类。

产出文件命名格式：
- 草稿（本地图）：`Copilot_YYYYMMDD_WeChat_<slug>.md`
- 发布版（公网 URL）：`Copilot_YYYYMMDD_WeChat_<slug>.cloud.md`

## Output conventions
- Prefer markdown files over plain chat output.
- Be concise in status updates.
- Execute by default; ask only when essential information is missing.
- 不要写"Generated with Claude Code"这类自动生成标识。
