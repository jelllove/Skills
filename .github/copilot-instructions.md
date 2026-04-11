# Copilot Workflow Instructions for this repository

When user asks for daily news and article generation, follow this workflow by default and execute directly without repeated confirmations.

## Default workflow
1. If user says `日报12h` (or equivalent):
   - 任务目标
   • 过去12个小时内发生的，全球高科技相关新闻（重点区域：美国、日本、欧洲、澳洲、韩国、台湾、新加坡等发展国家）
   • 主题聚焦：个人利用AI赚钱，个人利用AI做了一些之前不太可能的事，Github上最新的很多的start的repo, 云计算，数据中心，核电，AI/高科技、生物科技，诺贝尔奖，机器人，IT行业，数字经济，区块链，web3.0, tiktok, 拼音，小红书AI赚钱，公司动态、裁员、新技术、科技财经（公司并购，破产，上市）等
   • 输出格式：Top 10 新闻清单，按优先级排序，附上标题、摘要和链接，按热度来排序
   • 产出形式：一个 Markdown 文件，内容包括新闻清单和简要分析，文件名以英文为主，便于下载

    二、数据源与采集范围

    • 新闻来源：多家知名科技媒体与新闻聚合平台（如 TechCrunch, Bloomberg, The Verge, Nikkei, SCMP 等，以及公开新闻稿、公司公告）
    • 覆盖地区：US, Japan, Europe, Australia, Korea, Taiwan, Singapore，以及其他主要发达国家
    • 时间范围：以这个执行时间为主，过去12个小时内发生的
    • 区域性与媒体可信度权重
    • 内容相关性与时效性排序
    • 避免重复、确保版权合规

    其他：
      在收集信息的过程中，所有的需要去访问外网的一些东西，不需要人工去确认，直接访问就好了，不需要再问我了。
      产出文件的命名格式为：`YYYYMMDD_Global_HighTech_News_Top10_12h.md`，其中 `YYYYMMDD` 是执行日期，`Global_HighTech_News` 是主题标签，`Top10` 表示新闻数量，`12h` 表示覆盖的时间范围。

2. If user says `选题：<title>` (or equivalent):
   - 帮我写一个文章报道，以一个科技从业人员的角度来写(标题中不一定要出现这个从业角的信息），不要写到和政治相关的，也不要写到和中国国家领导人相关的话题，主要聚焦这个新闻本身，然后我想要图文都有，然后图片的话尽量拿免费的，没有版权的，比如说Unsplash或者Pexels的直链图片，文章的内容要有分析，不要只是简单的新闻报道，要有一些分析，分析的话可以从技术的角度来分析，也可以从产业的角度来分析，或者是从产品的角度来分析，或者是从投资的角度来分析，或者是从用户的角度来分析，总之要有一些分析，不要只是简单的新闻报道。最后直接保存成一个Markdown文件，文件名以英文为主，便于下载。
     - `YYYYMMDD_WeChat_<slug>.md`
   - Save markdown file:
     - `YYYYMMDD_WeChat_<slug>.md`

## Output conventions
- Prefer markdown files over plain chat output.
- Be concise in status updates.
- Execute by default; ask only when essential information is missing.
