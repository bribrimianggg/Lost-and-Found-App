# Project Brief: ParSU-LostAndFound

## 1. The problem
At Partido State University–Goa Campus, lost items are often recorded in logbooks, making them hard for students to find. Security staff also need a clearer way to track where items are stored and check ownership before returning them.

## 2. Users and what they need to do
| User role | What they need to do in the app |
|---|---|
| Student / Guest | Search found items, view item details, and submit a claim. |
| Security Staff | Record found items, assign storage locations, and check item records. |
| Admin / Prefect Staff | Review claims, approve or reject them, record releases, and manage categories and storage locations. |

## 3. The database behind it
**Database name:** `parsu_lostfound`  
**Number of tables:** 8

- **`categories`** — Stores the types of found items, such as ID cards and umbrellas.
- **`storage_locations`** — Stores the shelves or cabinets where items are kept.
- **`staff`** — Stores the names and roles of security and prefect personnel.
- **`finders`** — Records people who turned in found items.
- **`claimants`** — Stores information about people claiming items.
- **`items`** — Records each found item's details, found date, location, and receiving staff member.
- **`claims`** — Records claim attempts, proof of ownership, and approval decisions.
- **`releases`** — Records when an approved item is returned and who released it.

## 4. Must-have features (for the final project)
1. **Search** found items by name, category, or place found (`items`, `categories`).
2. **Add** new found-item records with their finder, category, and storage location (`items`, `finders`, `staff`, `categories`, `storage_locations`).
3. **Submit** ownership claims with claimant details and proof (`claims`, `claimants`, `items`).
4. **Review** and approve or reject claim requests (`claims`, `staff`).
5. **Record** the release of an item after its claim is approved (`releases`, `claims`, `staff`).
6. **Manage** item categories and storage locations (`categories`, `storage_locations`).

## 5. Nice-to-have features (only if there's time)
- Generate monthly summaries of found, released, and unclaimed items.
- Send claim-status notifications to claimants.

## 6. Similar apps I looked at
- **[iLost](https://ilost.co/)** — Borrow its simple found-item search and item-claim process.
- **[Chargerback](https://www.chargerback.com/)** — Borrow its organized lost-item report and tracking process.
