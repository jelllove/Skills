# Copilot Workflow Instructions for this repository

When user asks for daily news and article generation, follow this workflow by default and execute directly without repeated confirmations.

## Default workflow
1. If user says `日报` (or equivalent):
   - 任务目标
   • 过去12个小时内发生的，全球高科技相关新闻（重点区域：美国、日本、欧洲、澳洲、韩国、英国，北欧，台湾、爱尔兰，以色列，新加坡等发达国家）
   • 主题聚焦：全球知名公司的裁员或扩招信息，AI相关的新的技术突破，个人利用AI做了一些之前不太可能的事，Github上最新的很多的start的repo, 云计算，数据中心，核电，AI/高科技、生物科技，诺贝尔奖，机器人，IT行业，数字经济，区块链，web3.0, tiktok, 拼音，芯片，台积电，富士康，intel，通信，电子，spaceX，星链等公司的最新动态、科技财经（公司并购，破产，上市）等。 
   • 重点：如果这个新闻在国外（非中国）发生了，然后在中国的主流媒体还没有报道的话，那这个新闻的优先级会更高一些。因为这个新闻在中国还没有被报道过，所以它的时效性和独家性会更高一些。
   • 输出格式：Top 20 新闻清单，按优先级排序，附上标题、摘要和链接，按热度来排序，如果这个信息是没有被报道的话，那么它的热度会更高一些。每条新闻的摘要要简洁明了，突出重点，方便快速浏览。
             输出的清单分成三个：
              1. 根据热度来排序前20条新闻，热度的权重是：时效性（越新越热）+ 独家性（中国主流媒体未/少报道的越热）+ 相关性（与AI/高科技相关的越热）
              2. 根据时效性来排序前20条新闻，越新的越靠前
              3. 根据独家性来排序前20条新闻，中国主流媒体未/少报道的越靠前
   • 产出形式：一个 Markdown 文件，内容包括新闻清单和简要分析，新闻的出处（要有URL的链接），文件名以英文为主，便于下载, 要求也输出这个新闻发生的时间. 

    二、数据源与采集范围

    • 新闻来源：多家知名科技媒体与新闻聚合平台（如 TechCrunch, Bloomberg, The Verge, Nikkei, SCMP 等，以及公开新闻稿、公司公告）
    • 覆盖地区：US, Japan, Europe, Australia, Korea, Taiwan, Singapore，以及其他主要发达国家
    • 时间范围：以这个执行时间为主，过去12个小时内发生的
    • 区域性与媒体可信度权重
    • 内容相关性与时效性排序
    • 避免重复、确保版权合规

    时间窗口的硬性规则（重要，必须严格遵守）：
      1. 「现在」 = 用户发起请求时的实际本地时间（北京时间，UTC+8）。执行前先在文件开头明确写出 "执行时间(Beijing) = YYYY-MM-DD HH:mm" 与对应 UTC 时间。
      2. 12 小时窗口 = [现在 - 12h, 现在]，需同时给出北京时间与 UTC 两种表示，便于核对海外来源。
      3. 不得依赖网页中显示的 "X hours ago / X 小时前" 等相对时间（这些是网页缓存生成时刻的相对值，常常已经过期）。必须以条目的绝对发布时间(YYYY-MM-DD HH:mm，附时区) 为准。如果原文只有日期没有具体小时，需在抓取时点击进入原文确认；若仍无法确认到小时级，则视为不在 12h 窗口内，剔除。
      4. 抓取后必须做"窗口校验"：把每条新闻的发布时间换算成北京时间，落在窗口外的一律剔除（不要勉强凑数）。如果窗口内的高质量新闻不足 20 条，宁可输出更少条目，也不能用窗口外的新闻填充；并在文件顶部说明"窗口内仅找到 N 条"。
      5. 每条新闻必须显式写出 "发布时间(Beijing): YYYY-MM-DD HH:mm"，禁止使用 "约 X 小时前" 这类相对描述。
      6. 文件名中的 TIME 用执行时刻的北京时间 HHmm（24 小时制），例如 `20260510_2100_Global_HighTech_News_Top20_12h.md`。

    其他：
      产出文件的命名格式为：`YYYYMMDD_TIME_Global_HighTech_News_Top20_12h.md`，其中 `YYYYMMDD` 是执行日期，`TIME` 是执行时间，`Global_HighTech_News` 是主题标签，`Top20` 表示新闻数量，`12h` 表示覆盖的时间范围。



2. If user says `选题：<title> + <url>` (or equivalent):
   - 帮我写一个文章报道，以一个科技从业人员的角度来写(标题中不一定要出现这个从业角的信息)
     1. 先快速的概述一下这个新闻内容本身，根据给出的标题以及链接，说明一下这个新闻的内容是什么。
     2. 然后再根据当前的别的市场，别的公司的情况，或者是这个领域的情况，来分析一下这个新闻的内容，分析的话可以从技术的角度来分析，也可以从产业的角度来分析，或者是从产品的角度来分析，或者是从投资的角度来分析，或者是从用户的角度来分析，总之要有一些分析，不要只是简单的新闻报道。最后直接保存成一个Markdown文件，文件名以英文为主，便于下载。

     3. 不要写到和政治相关的，也不要写到和中国国家领导人相关的话题，主要聚焦这个新闻本身。

     4. 图文都有。图片来源**不再限制**（无需"必须免费"或"必须中国可访问"），可以来自公司官网 / Newsroom / Press kit、主流新闻媒体的实拍、Wikimedia Commons、Unsplash / Pexels 等。只要能下载到并且**和文章主题强相关**即可：标题中出现的公司、人物、产品、事件就应当是配图主体，不要放泛泛的"科技感"图。
        - 每篇 3 – 5 张，文件格式优先 `.jpg` / `.png`，避免 `.svg` / `.webp`（公众号兼容性差）。
        - 优先级（高 → 低）：公司官方 Newsroom > 主流新闻媒体实拍 > Wikimedia Commons > Unsplash/Pexels > 公司或产品 Logo（最后兜底）。
        - 如果能找到官方视频截图、动态图表截图，比静态头像更生动。

     4-bis. **图片处理与托管流程（重要 - 新流程）**

        所有图片都先存本地，再统一上传到 Azure Storage，最终发布版 Markdown 用公网 URL，不用本地相对路径。
        
        Step 1 - 下载到本地 `assets/wechat-<YYYYMMDD>/`，文件名语义化（如 `tim-cook.jpg`、`apple-park.jpg`），下载时带真实浏览器 User-Agent。Markdown 草稿里先用本地相对路径：`![alt](assets/wechat-20260514/xxx.jpg)`。
        
        Step 2 - 看图核对，确认主体清晰、和文章主题相关、无水印 / 错图。不合适重新换源下载。
        
        Step 3 - 调用 `upload-to-azure.ps1`（位于用户级 skill 目录 `c:\Users\<user>\.agents\skills\daily-news\` 与本仓库镜像 `.claude/skills/daily-news/`，两份内容一致）：
          - 扫描 Markdown 里所有 `assets/...` 引用
          - 上传到 Azure Blob Storage
          - 把本地路径替换成公网 URL
          - 默认输出 `<原文件名>.cloud.md`；加 `-InPlace` 可原地改写
        
        鉴权环境变量（在仓库根 `.env` 中维护即可）：
          - `DAILY_NEWS_STORAGE_ACCOUNT`（必填）
          - `DAILY_NEWS_STORAGE_CONTAINER`（默认 `wechat-assets`；如果用 Static Website 则填 `$web`）
          - `DAILY_NEWS_STORAGE_KEY` 或 `AZURE_STORAGE_CONNECTION_STRING`（二选一即可，**无需 `az login`**）
          - `DAILY_NEWS_WEB_ENDPOINT`（当容器为 `$web` 时填，格式 `https://<account>.zNN.web.core.windows.net`，脚本会用它生成 Static Website URL）
        
        Step 4 - 发布时使用 `*.cloud.md`，本地 `assets/wechat-<YYYYMMDD>/` 保留作为底图存档。
        
        典型调用：
        ```powershell
        # 一次性加载 .env
        Get-Content .\.env | ForEach-Object {
          $line=$_.Trim(); if([string]::IsNullOrWhiteSpace($line) -or $line.StartsWith('#')){ return }
          $kv=$line -split '=',2; if($kv.Count -eq 2){ [Environment]::SetEnvironmentVariable($kv[0].Trim(), $kv[1].Trim(), 'Process') }
        }
        # 上传并生成 .cloud.md
        & "$HOME\.agents\skills\daily-news\upload-to-azure.ps1" -MarkdownFile .\Copilot_YYYYMMDD_WeChat_<slug>.md
        ```

    6. 文章最后写上文章中所有出现的相关的数据和信息的来源，要求有URL链接的那种，方便我后续去核实和查阅。比如说这个新闻的来源是哪里，这个数据的来源是哪里，这个分析的依据是什么，这些都要写清楚，最好是有URL链接的那种，方便我后续去核实和查阅。
    7. 文件最后写个一个申明，说明这个文章仅供参考，不构成任何投资建议或者其他方面的建议，文章中的观点仅代表作者个人的观点，不代表任何公司的观点，也不代表任何机构的观点，投资有风险，入市需谨慎等等类似的申明，主要是为了规避一些法律风险，保护自己和公司的安全。
    8. 然后文章的最后要写一个相关的关键词，方便我后续做标签和分类用。比如 #XXX, #XXX, #XXX, 这样的标签，标签的话尽量要和文章内容相关的，不要随便写一些标签上去。

    9. 然后文件的内容不要写得像是AI帮我生成的，而是一个直接可用的文章的内容，然后我可以直接复制到别的地方的一个MD文件。
     - `Copilot_YYYYMMDD_WeChat_<slug>.md`

     10. 文章写完之后，我希望它没有数据上的问题，也没有逻辑上的问题，也没有语法上的问题，也没有拼写上的问题，也没有格式上的问题，也没有版权上的问题，也没有法律上的问题，也没有伦理上的问题，也没有政治上的问题，也没有敏感词上的问题，也没有文化上的问题，也没有地域上的问题，也没有性别上的问题，也没有年龄上的问题，也没有职业上的问题，也没有身份上的问题，也没有宗教上的问题，也没有价值观上的问题，也没有审美观上的问题，也没有世界观上的问题。总之，我希望它是一个完全合格的文章，没有任何方面的问题，可以直接发布出去的那种文章。
     所以我需要用另一个Agent对这个文章进行一个review，如果review有问题，就再回到写文章的Agent那里去修改，直到review没有问题为止。

     11. 文章在进行review的时候，让agent看一下，这个文章有没有“AI味”，让它尽量看上去不是AI自动生成的，会比较好。

## Output conventions
- Prefer markdown files over plain chat output.
- Be concise in status updates.
- Execute by default; ask only when essential information is missing.
  Generated with Claude Code，像这样的不要加上
