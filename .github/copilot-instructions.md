# Copilot Workflow Instructions for this repository

When user asks for daily news and article generation, follow this workflow by default and execute directly without repeated confirmations.

## Default workflow
1. If user says `日报8h` (or equivalent):
   - Collect latest global high-tech news in recent 8 hours.
   - Rank Top 100 by: heat × source credibility × relevance × recency.
   - Save markdown file with English-friendly filename:
     - `YYYYMMDD_Global_HighTech_News_Top100_8h.md`

2. If user says `选题：<title>` (or equivalent):
   - Generate a long-form Chinese markdown article using that exact title.
   - Include free image URLs (Unsplash/Pexels direct links).
   - Include practical commentary from a technology practitioner's perspective.
   - Avoid political framing/content; focus on technology, business, product, engineering impacts.
   - Save markdown file:
     - `YYYYMMDD_WeChat_<slug>.md`

## Output conventions
- Prefer markdown files over plain chat output.
- Be concise in status updates.
- Execute by default; ask only when essential information is missing.
