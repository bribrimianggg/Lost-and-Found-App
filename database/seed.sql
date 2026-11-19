USE parsu_lostfound;

-- SAMPLE RECORDS. All names, contacts and examples are demonstrative.
INSERT INTO categories(category_id,category_name) VALUES
 (1,'ID Card'),(2,'Flash Drive'),(3,'Umbrella'),(4,'Textbook');
INSERT INTO storage_locations(location_id,location_name) VALUES
 (1,'Security Cabinet A'),(2,'Security Shelf B');
INSERT INTO staff(staff_id,full_name,role) VALUES
 (1,'Guard Reyes','Security'),(2,'Officer Cruz','Prefect');
INSERT INTO finders(finder_id,full_name,contact) VALUES
 (1,'Ana Santos','Demo-only contact');
INSERT INTO claimants(claimant_id,full_name,contact) VALUES
 (1,'Eric Dela Cruz','demo.one@example.invalid'),
 (2,'Jose Ramos','demo.two@example.invalid');
INSERT INTO items(item_id,category_id,location_id,finder_id,received_by,item_name,description,found_at,found_place) VALUES
 (101,2,1,1,1,'Black USB Drive','32 GB drive with blue keychain','2026-11-12 09:30:00','Campus Library'),
 (102,3,2,1,1,'Blue Umbrella','Foldable blue umbrella','2026-11-13 14:00:00','Building A'),
 (103,4,1,1,1,'Database Textbook','White name sticker inside cover','2026-11-14 11:00:00','Computer Laboratory');
-- Two NEW example item rows added for WS1 Week 14 to meet the 5-row list requirement.
-- They use existing category, finder, staff, and location IDs; no schema changes.
INSERT INTO items(item_id,category_id,location_id,finder_id,received_by,item_name,description,found_at,found_place) VALUES
 (104,1,2,1,1,'Student ID Card','Blue lanyard with a clear ID holder','2026-11-16 08:15:00','Student Center'),
 (105,2,1,1,2,'Silver USB Drive','16 GB drive with a red cap','2026-11-17 13:20:00','Lecture Hall B');

INSERT INTO claims(item_id,claim_no,claimant_id,reviewed_by,proof_description,decision,claim_date,decision_at) VALUES
 (101,1,1,NULL,'Described the blue keychain','Pending','2026-11-14 10:00:00',NULL),
 (101,2,2,2,'Could not describe the USB label','Rejected','2026-11-14 11:00:00','2026-11-14 12:00:00'),
 (103,1,2,2,'Provided matching textbook description','Approved','2026-11-15 09:00:00','2026-11-15 10:00:00');
INSERT INTO releases(item_id,claim_no,released_by,released_at,acknowledgment)
VALUES(103,1,1,'2026-11-15 11:00:00','Demo receipt R-103');

-- Verify loaded totals: 4 categories, 2 locations, 2 staff, 1 finder,
-- 2 claimants, 5 items, 3 claims, 1 release.
SELECT 'categories' AS entity, COUNT(*) AS total FROM categories
UNION ALL SELECT 'items', COUNT(*) FROM items
UNION ALL SELECT 'claims', COUNT(*) FROM claims
UNION ALL SELECT 'releases', COUNT(*) FROM releases;
