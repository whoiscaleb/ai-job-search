# Search Queries for Job Scraper

## Search Sites

Primary (remote job boards):
- **remotive.com** - remote tech/support jobs
- **justremote.co** - remote jobs across categories
- **jobspresso.co** - curated remote jobs
- **remote.co** - remote job listings. **Caution:** WebFetch timed out on every remote.co URL tested on 2026-09-02 (all `/remote-jobs/<category>` list pages AND individual `/job-details/<slug>` pages - 60s timeout, no content). `site:remote.co/job-details` search returns a live-ish index but heavily skewed to non-support roles (tax, teaching, sales eng, HR) and no reliable date signal. Treat remote.co as low-yield until WebFetch reliability returns; retry the category pages on a later run before relying on `site:` search alone.
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
- **learn4good.com/jobs** - broad general job board with an IT/tech category and a dedicated `online_remote` section; category listings mix in unrelated roles (e.g. facilities, automotive) alongside IT/support postings - filter by title before fetching. **Caution:** initial spot-check (2 postings) fetched cleanly, but a full `/scrape` run found `site:` search returns mostly stale/dead job IDs (8/9 sampled postings from a `site:learn4good.com/jobs/online_remote` query 404'd). Directly fetching a category list page (e.g. `/jobs/language/english/list/info_technology/usa_united_states/`) still returned live listings in both tests - prefer that approach over trusting `site:` search hits on this domain.

**Tested and rejected (do not add to query rotation):**
- ~~techfetch.com~~ - blocks automated fetch (403 Forbidden); also skews toward IT staffing/C2C contract roles rather than direct-hire remote positions
- ~~ziprecruiter.com~~ - blocks automated fetch (403 Forbidden); `site:` search only surfaces aggregate location pages, not individual postings
- ~~levels.fyi~~ - job pages return empty/blank content on fetch (JS-rendered, not scrapable)
- ~~kforce.com~~ - search results page is JS-rendered and returns no listings on fetch; also a staffing agency (same concern as techfetch)
- ~~monster.com~~ - blocks automated fetch (403 Forbidden) on both search pages and individual job postings
- ~~glassdoor.com~~ - blocks automated fetch (403 Forbidden); `site:` search only surfaces aggregate location-category pages, not individual postings

Secondary (company career pages via Google):
- Direct Google searches with `site:` filters for known target companies

Direct-fetch sources (not `site:`-searchable - see "Weekly Roundup Sources" below):
- **supportdriven.com/weekly-job-roundup** - Support Driven community's weekly customer/technical support job roundup, remote + on-site roles
- **indeed.com** - `site:` search only surfaces aggregate query pages (e.g. `q-remote-technical-support-jobs.html`), not individual postings - same limitation as ycombinator.com/jobs. Two-step process required: (1) directly fetch a query URL like `https://www.indeed.com/q-remote-technical-support-jobs.html` (or swap the query/location slug), (2) extract `viewjob?jk=<id>` links from the fetched content, (3) fetch those individually - confirmed both test postings returned full real content (title, company, salary, requirements). Note many results skew toward government-contractor/clearance-required roles and sub-$50k help-desk pay bands - filter salary carefully.
- **learn4good.com** - `site:` search returns mostly stale/dead job IDs (8/9 sampled 404'd in one run). Directly fetch a category list page instead, e.g. `https://www.learn4good.com/jobs/language/english/list/info_technology/usa_united_states/` or a location-specific `online_remote` category page, and extract the per-posting URLs it contains - both spot-checks of direct fetches returned live listings.

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
3. Filter results the same way as other sources: remote-first, 30-minute Davenport commute cap, compensation of $50,000 or more, posted within the last 7 days

Run this once per `/scrape` session regardless of which priority categories are selected, since it's a single well-targeted source for support-role postings rather than a broad search.

**Latest known roundup post:** [Customer Support Jobs: July 13 Roundup (Remote + On-site Roles)](https://www.supportdriven.com/weekly-job-roundup/customer-support-jobs-july-13-roundup-remote-on-site-roles) - confirmed live 2026-07-13, ~23 listings (16 mid-level, 7 entry-level). Roundups post roughly weekly; if the index page lookup in step 1 fails or is slow, try incrementing the date slug (e.g. `july-20-roundup`) before falling back to a full index fetch - but always verify via step 1 that this is still the most recent post, since a newer one may have been published since this note was added.

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

Deal-breaker: compensation below $50,000. (Lowered from $60,000 on 2026-09-28 to widen the search; Caleb currently earns $60,000, so $50K-$60K roles are acceptable but should be noted as a pay cut. For ranges that straddle the floor, e.g. $45K-$62K, include the posting and note that the offer could land below $50K.) Flag postings with no listed salary for follow-up rather than skipping them.

## Date Filter

Only include jobs posted within the last **7 days** (widened from 24-48 hours on 2026-09-28 to increase volume; list the actual posted age for each job so the freshest can be prioritized), or with an application deadline that has not yet passed. If a posting date cannot be determined, include it but flag as "date unknown". Job board search indexes (remotive.com, jobspresso.co, etc.) are frequently stale - a listing showing up in a `site:` search does not mean it was actually posted recently. Before presenting a job as new, confirm the posting's actual date via the fetched page content itself (not just the search snippet), and treat "still shows as open" as insufficient on its own - cross-check the stated post date against today's date.

## Link Verification

Before presenting ANY job as a new candidate, confirm the posting actually loads and is live - a 404/410/"job no longer available" result must never be presented, even as a caveat-flagged candidate. If a direct fetch fails (e.g. JS-rendered sources like Ashby/YC-hosted pages, or a dead link), either find a working alternate source for the same posting or drop it entirely rather than presenting it with an "unverified" flag - unverifiable is not the same as promising.

## Adapting Queries

If the user specifies a focus area, select queries from the matching category and also generate 2-3 custom queries for that focus. For example:
- "/scrape [focus_area]" -> relevant category queries + custom focus-specific queries
