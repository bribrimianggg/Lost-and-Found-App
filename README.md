# ParSU-LostAndFound — WS1 Week 14

**Full project title:** ParSU-LostAndFound: Campus Property Logging and Ownership Verification System  
**Organization:** Partido State University, Goa Campus — Security and Prefect of Discipline Office  
**Subject:** WS1 · Web Systems and Technologies · Week 14  
**Group members:** **Mia R. Casino && Eric P. Tanay**

## What this is
A design package and **two static HTML/CSS mock-ups** based on our existing MySQL `parsu_lostfound` database. It helps campus visitors find logged property, while authorized office staff record found items and process ownership claims. No backend, saving, login, search, or deletion works yet. Those are for later weeks.

## Source of the database
`database/schema.sql` and `database/seed.sql` come from our existing MySQL 8 schema. The earlier script had the CREATE TABLE statements **and** INSERT statements in one file, so we separated them without changing the schema. The original sample had **3** items; we added **2** new classroom sample items (IDs 104 and 105) to `seed.sql` so the static list can display **5** rows. All names and contacts are classroom demo data. No tables or columns were added, removed, or renamed.

## Contents

| Path | Purpose |
|---|---|
| `database/schema.sql` | 8 tables, keys, constraints, triggers, indexes, view |
| `database/seed.sql` | Original demo data plus 2 new item rows |
| `docs/01-brief.md` | Task 1 — project brief |
| `docs/02-crud-map.md` | Task 2 — CRUD map and two form field lists |
| `docs/03-sitemap.png` / `docs/03-user-flow.png` | Task 3 — diagrams |
| `docs/04-wireframes/` | Task 4 — 4 desktop screens and list phone view |
| `docs/05-style-guide.md` | Task 5 — colors, components, accessibility |
| `prototype/list.html` / `prototype/form.html` | Task 6 — static pages |
| `prototype/style.css` | Shared responsive styles |
| `screenshots/` | 3 screenshots for Google Classroom |


## View the static pages
1. Open this folder in VS Code and install **Live Server** if needed.
2. Right-click `prototype/list.html` → **Open with Live Server**. You can also open the files directly in a browser.
3. Use the **+ Log an Item** button to open `prototype/form.html`; use **Back to items** to return.
4. In Chrome/Edge DevTools, toggle device emulation and set the width to **390 px** to inspect the responsive list layout.

**Design-only behavior:** the search box does not filter, Edit is a nonfunctional preview button, and disabled Delete buttons do not delete anything. The Add form uses `method="post"` as a Week 15 scaffold, but will not save until PHP is built.

## Database import (not required to view HTML)
With MySQL 8.0.16+ and a **fresh/empty** schema, run `database/schema.sql` first and `database/seed.sql` second. Both scripts target `parsu_lostfound`; don't import the seed twice because its IDs are fixed. The scripts are saved for Week 15; **there is no MySQL connection in Week 14**.

## Week 15 planned
Implement role-based access and authentication **after adding a safe authentication design** (the current schema has staff/finder/claimant data but no password/auth table). Implement server-side insert, read, update, and authorized claim review and releases with PHP + MySQL, then add JavaScript validation.

## Similar website studied
[iLost](https://ilost.co/search) — search for found belongings, then submit an ownership claim. We will borrow the clear search-first flow, not its code.
