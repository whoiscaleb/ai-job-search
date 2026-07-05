# Search Queries for Job Scraper

## Search Sites

Primary (remote job boards):
- **remotive.com** - remote tech/support jobs
- **justremote.co** - remote jobs across categories
- **jobspresso.co** - curated remote jobs
- **remote.co** - remote job listings
- **wearerosie.com** - remote marketing/support gigs
- **jobrack.eu** - remote jobs for EU/global talent
- **flexjobs.com** - flexible/remote job board (subscription-gated; rely on Google-indexed snippets)
- **ycombinator.com/jobs** - Y Combinator startup jobs, many remote (only exposes category/aggregate pages to search, not direct job links - treat leads found here as "verify manually", not fetchable)
- **cutshort.io** - tech jobs, largely India-focused but includes remote
- **hirect.in** - tech hiring, largely India-focused
- **instahyre.com** - tech hiring, largely India-focused
- **linkedin.com/jobs** - filter by "Remote"
- **techjobsforgood.com** - social-impact/mission-driven org tech job board; fetches cleanly, has a "Remote (US)" filter. Note: postings frequently close fast (several sampled were already closed within weeks of posting) - always confirm still-open status before presenting.
- **4dayweek.io/remote-jobs** - remote job board with a customer/technical support category; many roles offer reduced-hour schedules. Some postings are non-US (e.g. Remote Egypt) - check work-eligibility requirements before presenting.
- **remote.co/remote-jobs/customer-service** - category-specific page on the already-listed remote.co, more targeted than the general site search.
- **app.welcometothejungle.com** - European-origin remote job board (formerly Otta) with US listings; `site:` search returns direct, individually fetchable job postings.
- **builtin.com/jobs** - large US tech job board with metro + remote category pages; fetches cleanly with direct per-posting URLs.

**Tested and rejected (do not add to query rotation):**
- ~~techfetch.com~~ - blocks automated fetch (403 Forbidden); also skews toward IT staffing/C2C contract roles rather than direct-hire remote positions
- ~~ziprecruiter.com~~ - blocks automated fetch (403 Forbidden); `site:` search only surfaces aggregate location pages, not individual postings
- ~~levels.fyi~~ - job pages return empty/blank content on fetch (JS-rendered, not scrapable)
- ~~kforce.com~~ - search results page is JS-rendered and returns no listings on fetch; also a staffing agency (same concern as techfetch)

Secondary (company career pages via Google):
- Direct Google searches with `site:` filters for known target companies

Direct-fetch sources (not `site:`-searchable - see "Weekly Roundup Sources" below):
- **supportdriven.com/weekly-job-roundup** - Support Driven community's weekly customer/technical support job roundup, remote + on-site roles

**Removed from rotation (block automated fetch with HTTP 403 Forbidden on every posting tested):**
- ~~remoteok.com~~
- ~~weworkremotely.com~~
- ~~wellfound.com~~ (formerly AngelList Talent)

These still show up in WebSearch results, but WebFetch cannot retrieve posting details from them, so they're dropped from the query list below. If postings from these boards look worth pursuing from search snippets alone, check them manually.

## Query Categories

Queries are grouped by priority. Every query should include "remote" and, where relevant, exclude on-site-only postings. Caleb is remote-first; on-site/hybrid is only acceptable within a 30-minute commute of Davenport, FL.

### Priority 1: Technical Support / Support Engineering (Remote)

These match Caleb's strongest and most desired career direction.

```
site:remotive.com "technical support engineer"
site:jobspresso.co "technical support" OR "support specialist"
site:linkedin.com/jobs "Technical Support Engineer" Remote
site:linkedin.com/jobs "Tier 2 Support" OR "Tier 3 Support" Remote
site:techjobsforgood.com "technical support" OR "support engineer" OR "support specialist"
site:4dayweek.io "technical support" OR "support specialist"
site:app.welcometothejungle.com "technical support" OR "customer support" remote USA
site:builtin.com/jobs/remote "technical support" OR "support engineer"
```

### Priority 2: Enterprise SaaS Support & Escalation Management

These match Caleb's domain expertise.

```
site:remotive.com "SaaS support" OR "customer support engineer"
site:justremote.co "technical support" SaaS
site:jobspresso.co "support specialist" OR "support engineer"
site:linkedin.com/jobs "Enterprise SaaS" "support" Remote
site:techjobsforgood.com "customer support" OR "SaaS support" remote
site:remote.co/remote-jobs/customer-service "technical support" OR "customer support engineer"
```

### Priority 3: Developer-Facing / Support-Engineering Hybrid Roles

Adjacent roles that use Caleb's JavaScript/Python/React/Node skills alongside support experience.

```
site:jobspresso.co "developer support" OR "support engineer" API
site:ycombinator.com/jobs "support engineer" OR "technical support"
site:linkedin.com/jobs "Solutions Engineer" OR "Developer Support" Remote
```

### Priority 4: Broader Remote Technical Roles

Wider net across additional remote-friendly boards.

```
site:remote.co "technical support" OR "support engineer"
site:jobrack.eu "technical support" OR "support engineer"
site:flexjobs.com "technical support specialist" Remote
site:cutshort.io "technical support" OR "support engineer"
site:hirect.in "technical support" OR "support engineer"
site:instahyre.com "technical support" OR "support engineer"
```

## Weekly Roundup Sources

Unlike the boards above, [supportdriven.com/weekly-job-roundup](https://www.supportdriven.com/weekly-job-roundup) is an index page, not a `site:`-searchable board - it lists links to individual weekly roundup posts (e.g. "Customer Support Jobs: [Date] Roundup (Remote + On-site Roles)") rather than job postings directly. To use it:

1. WebFetch the index page and find the most recent roundup post link
2. WebFetch that specific roundup post to extract the individual job listings (title, company, location, link) it contains
3. Filter results the same way as other sources: remote-first, 30-minute Davenport commute cap, compensation above $60,000, posted within the last 14 days

Run this once per `/scrape` session regardless of which priority categories are selected, since it's a single well-targeted source for support-role postings rather than a broad search.

**ATS platform fetchability** (based on testing the June 29, 2026 roundup): individual job links point to whatever applicant-tracking system the employer uses, and fetch reliability varies a lot by platform:
- **greenhouse.io** - fetches cleanly, full posting content available
- **workday (myworkdayjobs.com)** - JS-rendered, WebFetch typically returns empty content
- **ashbyhq.com** - JS-rendered, WebFetch typically returns only the title/company, not full details
- **lever.co** - has returned HTTP 403 Forbidden on every posting tested

Don't burn effort re-fetching Workday/Ashby/Lever links expecting full details; either accept the title/company/location from the roundup listing itself as the available signal, or flag for the user to check manually.

## Location Filter

Caleb is based in Davenport, FL and is remote-first. Define acceptable areas:
- Fully remote (any location): PASS
- On-site/hybrid within a 30-minute commute of Davenport, FL (e.g. Davenport, Haines City, Lakeland, Kissimmee, parts of Orlando): PASS
- On-site/hybrid beyond a 30-minute commute of Davenport, FL: FAIL (deal-breaker)
- Requires relocation: FAIL (deal-breaker)

## Compensation Filter

Deal-breaker: compensation at or below $60,000 (Caleb's current salary). Flag postings with no listed salary for follow-up rather than skipping them.

## Date Filter

Only include jobs posted within the last 14 days, or with an application deadline that has not yet passed. If a posting date cannot be determined, include it but flag as "date unknown".

## Adapting Queries

If the user specifies a focus area, select queries from the matching category and also generate 2-3 custom queries for that focus. For example:
- "/scrape [focus_area]" -> relevant category queries + custom focus-specific queries
