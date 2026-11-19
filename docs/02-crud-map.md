# Task 2: CRUD Map — ParSU-LostAndFound

**Database:** `parsu_lostfound` (8 tables)  
**Legend:** C = Create, R = Read, U = Update, D = Delete, ✓ = planned, — = not allowed in the app.  
**User roles:** Student/Guest, Security Staff, and Admin/Prefect Staff.  
The pages below are **planned for the final web app**. For Week 14, only `prototype/list.html` and `prototype/form.html` are coded as static HTML/CSS.

## 1. CRUD map

| Table | C | R | U | D | Pages | Who can use it / reason for restrictions |
|---|:---:|:---:|:---:|:---:|---|---|
| `categories` | ✓ | ✓ | ✓ | ✓* | Categories, Item Form | **Admin:** C, R, U, D. **Security:** R to select a category. **Guest:** R through item listings. *Delete only if no item uses the category (`ON DELETE RESTRICT`).* |
| `storage_locations` | ✓ | ✓ | ✓ | ✓* | Storage Locations, Item Form | **Admin:** C, R, U, D. **Security:** R to choose a storage shelf. *Delete only if it is not used by any item (`ON DELETE RESTRICT`).* |
| `staff` | ✓ | ✓ | ✓ | — | Staff Directory, Item Form, Claim Review, Release Form | **Admin:** C, R, U. **Security:** R of allowed staff choices. **No D:** staff records are needed to identify who received, reviewed, or released an item; foreign keys restrict deleting linked staff. |
| `finders` | ✓ | ✓ | ✓ | — | Finders, Item Form | **Security/Admin:** C, R, U. **No D:** finder details must remain connected to recorded items. The `items` foreign key restricts deletion when referenced. |
| `claimants` | ✓ | ✓ | ✓ | — | Claimants, Claim Form | **Student/Guest:** provide their own claimant details in a staff-assisted claim. **Security/Admin:** C, R, U. **No D:** keep names connected to previous claims; foreign keys restrict deletion when referenced. |
| `items` | ✓ | ✓ | ✓ | — | Items List, Item Detail, Item Form | **Student/Guest:** R of public item details. **Security/Admin:** C, R, U. **No D:** keep the item log and claim/release history. Claims use `ON DELETE RESTRICT`; Delete is shown as disabled in the Week 14 mock-up. |
| `claims` | ✓ | ✓ | ✓ | — | Claim Form, Claims List, Claim Review, Item Detail | **Student/Guest:** submit information for a claim (staff-assisted). **Security:** C, R. **Admin/Prefect:** R, U to approve/reject. **No D:** keep all claim attempts as history, including rejected claims. |
| `releases` | ✓ | ✓ | ✓* | — | Releases List, Release Form, Item Detail | **Admin/Prefect:** C, R, and limited U for correcting a record. **Security:** R when authorized. *Update must still reference an approved claim.* **No D:** keep the record proving an item was handed over. |

**Privacy note:** Guests should not see claimant contact details, proof descriptions, or internal staff records. Access checks are a future feature; the current MySQL schema does not include a login or user-accounts table.

## 2. Form fields for two important tables

### Table A: `items` — Add / Edit Item Form

| Column name | Form control | Required? | Notes |
|---|---|---|---|
| `item_id` | None on Add; hidden input on Edit | No entry on Add | `INT AUTO_INCREMENT` — MySQL makes the ID. |
| `category_id` | `<select name="category_id">` | Yes | Show `categories.category_name`; submit category ID. |
| `location_id` | `<select name="location_id">` | Yes | Show `storage_locations.location_name`; submit location ID. |
| `finder_id` | `<select name="finder_id">` | Yes | Show `finders.full_name`; required by the current schema. |
| `received_by` | `<select name="received_by">` | Yes | Show `staff.full_name`; submit staff ID. |
| `item_name` | `<input type="text" name="item_name" maxlength="120" required>` | Yes | Name of the found item. |
| `description` | `<textarea name="description" maxlength="255" required>` | Yes | Item description; stored as `VARCHAR(255)`. |
| `found_at` | `<input type="datetime-local" name="found_at" required>` | Yes | Date and time the item was found. |
| `found_place` | `<input type="text" name="found_place" maxlength="150" required>` | Yes | Place where the item was found. |
| `created_at` | None | No entry | MySQL automatically uses `CURRENT_TIMESTAMP`. |

### Table B: `claims` — Claim Form / Claim Review

| Column name | Form control | Required? | Notes |
|---|---|---|---|
| `item_id` | `<select name="item_id" required>` | Yes | Choose the item being claimed; part of the composite primary key. |
| `claim_no` | `<input type="number" name="claim_no" min="1" required>` (staff/internal) | Yes in database | Part of the primary key `(item_id, claim_no)`. In the final app, PHP should safely assign the next claim number rather than letting guests choose it. |
| `claimant_id` | `<select name="claimant_id" required>` | Yes | Choose a claimant by name; store the claimant's ID. Claimant details come from `claimants`. |
| `reviewed_by` | `<select name="reviewed_by">` (review form only) | Only when Approved/Rejected | Must remain empty (`NULL`) for Pending claims. |
| `proof_description` | `<textarea name="proof_description" maxlength="255" required>` | Yes | The claimant's proof or description of the item. |
| `decision` | `<select name="decision">` (review form only) | Uses default on Add | `Pending`, `Approved`, or `Rejected`; defaults to `Pending`. |
| `claim_date` | None on Add | No entry | MySQL automatically sets `CURRENT_TIMESTAMP`. |
| `decision_at` | `<input type="datetime-local" name="decision_at">` (review form only) | Only when Approved/Rejected | Must be `NULL` while claim is Pending. |
| `approved_item_id` | None | No entry | Generated automatically by MySQL. Never put it on a form. |

**Claim rules:** Pending claims must have `reviewed_by = NULL` and `decision_at = NULL`. Approved or Rejected claims must have both fields filled in. Only one Approved claim can exist per item. A release must reference an Approved claim, and an item can be released only once.

## 3. Schema changes

**None.** We did not add, remove, or rename any tables or columns. We kept the existing eight-table structure and all its keys and relationships.

**Sample-data update (not a schema change):** Two additional item records (IDs 104 and 105) were added to `database/seed.sql` for the Week 14 prototype, so the HTML list can show five sample rows as required. The original three sample items remain. No changes to `database/schema.sql` are needed.

**Possible future improvement:** The database currently requires `finder_id` for every item. In real situations, the finder may be unknown; this can be discussed with Sir before making any schema change in later weeks.
