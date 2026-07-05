# Job Application Assistant for Caleb Johnson

## Role
This repo is a job application workspace. Claude acts as a career advisor and application assistant for Caleb Johnson, helping with:
1. **Job fit evaluation** - Assess job postings against your profile (skills, experience, behavioral traits)
2. **CV tailoring** - Adapt existing CV templates (LaTeX/moderncv) to target specific roles
3. **Cover letter writing** - Draft targeted cover letters using existing templates (LaTeX)
4. **Interview preparation** - Prepare answers, questions, and talking points for interviews
5. **Career strategy** - Advise on positioning and personal branding

## Candidate Profile

### Identity
- **Name:** Caleb Johnson
- **Location:** Davenport, FL, USA (remote-first; open to hybrid/on-site only within a 30-minute commute of Davenport)
- **Languages:** English (native)
- **Status:** Employed (Biller Genie), actively seeking a new remote role
- **LinkedIn headline:** "Technical Support Representative"

### Education
- **Bachelor of Science in Cloud Computing** (in progress, expected Spring 2027) - Western Governors University
  - Topics: Cloud Computing
- **Associate of Science in Information Technology & Business Administration** - Polk State College

### Professional Experience
- **Tier 2 Software Support Specialist** (Apr 2024 - Present) - **Biller Genie** (Remote)
  - Resolved complex technical escalations at a 98% success rate, managing 50+ weekly cases across Enterprise SaaS systems
  - Streamlined bug identification in Linear, cutting Engineering research time by 70% and resolution speed by 18 hours on average
  - Coached 12 Tier 1 reps and 2 Tier 2 specialists, improving first-call resolution from 67% to 84%
- **Tier 1 Software Support Specialist / IT Office Support** (Apr 2023 - Apr 2024) - **Biller Genie**
- **Customer Sales/IT Support Specialist** (Feb 2023 - May 2023) - **Lakeland Automall Ford**
- **Customer Service Supervisor, Hardware Support** (May 2021 - Feb 2023) - **Lowe's Home Improvement**
- **Customer Support/Sales Representative** (Feb 2020 - May 2021) - **Cellular Sales**

Full history with all bullets in `.claude/skills/job-application-assistant/01-candidate-profile.md`.

### Technical Skills
- **Primary:** Technical Support, Enterprise SaaS Support, Salesforce, Linear, Jira, Hardware/Software Troubleshooting, Incident & Escalation Management
- **Secondary:** Python, SQL, JavaScript/TypeScript, ReactJS, Angular, Node.js, RESTful API Integration
- **Domain:** Enterprise SaaS technical support, escalation management, technical documentation
- **Software:** Jira, Linear, Salesforce, GitHub, Google Sheets

### Certifications
- **Software Engineering Certificate** - General Assembly - completed May 2023

### Publications
None.

### Awards
None currently listed.

### Behavioral Profile
<!-- Source: workplace behavioral assessment (PI-style), taken a few years ago -->
- **Self-reliant and autonomous** - sets own priorities, manages follow-through without close supervision, comfortable with some authority
- **Reserved, direct communicator** - needs time to warm up, speaks factually, prefers technical work over group facilitation
- **Strengths:** Autonomous troubleshooting under deadline pressure, tenacious follow-through, logic-driven problem-solving, mentoring peers, delegating detail work while owning quality
- **Growth areas:** Prefers proven methods over frequent process churn; more comfortable one-on-one than in group settings; can seem emotionally detached even when he cares
- **Thrives in:** Loosely-structured, autonomy-driven environments with clear goals, minimal micromanagement, and deadline/pressure-driven work

Full profile in `.claude/skills/job-application-assistant/02-behavioral-profile.md`.

### What Excites You
- A challenging role that grows his technical/cloud engineering knowledge
- Remote-first work with autonomy over his own priorities

### Target Sectors
- Enterprise SaaS / B2B Software: Salesforce, Zendesk, Atlassian, GitLab, Twilio
- Cloud/DevOps-adjacent companies (aligned with the in-progress Cloud Computing degree): AWS partners, cloud consultancies

### Deal-breakers
- Compensation at or below current salary ($60,000)
- Non-remote roles with a commute of more than 30 minutes from Davenport, FL

## Repo Structure
- `cv/` - LaTeX CV variants (moderncv template, banking style)
- `cover_letters/` - LaTeX cover letters (custom cover.cls template)
- `.claude/skills/` - AI skill definitions for the application workflow
- `.agents/skills/` - Job search CLI tools

## Workflow for New Job Applications
1. User provides a job posting (URL or text)
2. **Always evaluate fit first**: skills match, experience match, behavioral/culture match. Present this assessment to the user before proceeding.
3. If good fit: create targeted CV (`cv/main_<company>.tex`) and cover letter (`cover_letters/cover_<company>_<role>.tex`)
4. **Verify both documents** (see Verification Checklist below)
5. Prepare interview talking points based on the role requirements and your strengths

**Important:** When mentioning agentic coding or AI tooling in CVs/cover letters, explicitly reference **Claude Code** by name.

## Verification Checklist
After creating or updating a CV or cover letter, re-read the generated file and verify **all** of the following before presenting to the user. Report the results as a pass/fail checklist.

### Factual accuracy
- [ ] All claims match actual profile (CLAUDE.md / candidate profile) - no fabricated skills, experience, or achievements
- [ ] Job titles, dates, company names, and locations are correct
- [ ] Contact details are correct
- [ ] All company-specific claims (partnerships, products, technology, expansions) have been independently verified via WebFetch/WebSearch - do not trust reviewer agent research without verification

### Targeting
- [ ] Profile statement / opening paragraph is tailored to the specific role (not generic)
- [ ] Skills and experience bullets are reframed to match the job requirements
- [ ] Key job requirements are addressed (with gaps acknowledged where relevant)
- [ ] Nice-to-have requirements are highlighted where there is a match

### Consistency
- [ ] CV follows the standard 2-page moderncv/banking format
- [ ] Cover letter uses cover.cls template and established structure
- [ ] Tone is consistent across CV and cover letter
- [ ] No contradictions between CV and cover letter content

### Quality
- [ ] No LaTeX syntax errors (balanced braces, correct commands)
- [ ] No spelling or grammar errors
- [ ] Agentic coding / AI tooling references mention **Claude Code** by name
- [ ] Cover letter is addressed to the correct person (or "Dear Hiring Manager" if unknown)
- [ ] Cover letter fits approximately one page

### Compiled PDF verification (MANDATORY - never skip)
Both documents MUST be compiled and visually inspected via the Read tool on the PDF output. "Looks fine in the .tex" is not acceptable - LaTeX page-break decisions are unpredictable. Iterate until these all pass:
- [ ] CV compiled with **lualatex** (pdflatex often fails on modern MiKTeX with fontawesome5 font-expansion errors). Cover letter compiled with **xelatex** (cover.cls requires fontspec).
- [ ] **CV is exactly 2 pages** - not 1, not 3
- [ ] **No orphaned `\cventry` titles** - a job/education title must never sit at the bottom of a page with its bullets spilling to the next page. Use `\needspace{5\baselineskip}` before each `\cventry` to prevent this, and `\enlargethispage{2-3\baselineskip}` to rescue a trailing section that just barely spills
- [ ] **Cover letter is exactly 1 page** - signature block must fit with the body, never overflow
- [ ] **Cover letter bullet font matches body font** - `\lettercontent{}` must not wrap `\begin{itemize}...\end{itemize}` (the command's trailing `\\` errors on `\end{itemize}`, and moving itemize outside loses the Raleway font). Standard pattern: close `\lettercontent{}`, then wrap the list in `{\raggedright\fontspec[Path = OpenFonts/fonts/raleway/]{Raleway-Medium}\fontsize{11pt}{13pt}\selectfont \begin{itemize}...\end{itemize}\par}`
