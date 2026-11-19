-- ParSU-LostAndFound | MySQL 8.0.16+ (InnoDB)
CREATE DATABASE IF NOT EXISTS parsu_lostfound CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE parsu_lostfound;

CREATE TABLE categories (
  category_id INT PRIMARY KEY,
  category_name VARCHAR(80) NOT NULL,
  CONSTRAINT uq_category_name UNIQUE (category_name),
  CONSTRAINT ck_category_name CHECK (CHAR_LENGTH(TRIM(category_name)) > 0)
) ENGINE=InnoDB;

CREATE TABLE storage_locations (
  location_id INT PRIMARY KEY,
  location_name VARCHAR(100) NOT NULL,
  CONSTRAINT uq_location_name UNIQUE (location_name),
  CONSTRAINT ck_location_name CHECK (CHAR_LENGTH(TRIM(location_name)) > 0)
) ENGINE=InnoDB;

CREATE TABLE staff (
  staff_id INT PRIMARY KEY,
  full_name VARCHAR(120) NOT NULL,
  role ENUM('Security','Prefect','Administrator') NOT NULL,
  CONSTRAINT ck_staff_name CHECK (CHAR_LENGTH(TRIM(full_name)) > 0)
) ENGINE=InnoDB;

CREATE TABLE finders (
  finder_id INT PRIMARY KEY,
  full_name VARCHAR(120) NOT NULL,
  contact VARCHAR(100) NULL,
  CONSTRAINT ck_finder_name CHECK (CHAR_LENGTH(TRIM(full_name)) > 0)
) ENGINE=InnoDB;

CREATE TABLE claimants (
  claimant_id INT AUTO_INCREMENT PRIMARY KEY,
  full_name VARCHAR(120) NOT NULL,
  contact VARCHAR(100) NULL,
  CONSTRAINT ck_claimant_name CHECK (CHAR_LENGTH(TRIM(full_name)) > 0)
) ENGINE=InnoDB;

CREATE TABLE items (
  item_id INT AUTO_INCREMENT PRIMARY KEY,
  category_id INT NOT NULL,
  location_id INT NOT NULL,
  finder_id INT NOT NULL,
  received_by INT NOT NULL,
  item_name VARCHAR(120) NOT NULL,
  description VARCHAR(255) NOT NULL,
  found_at DATETIME NOT NULL,
  found_place VARCHAR(150) NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_item_category FOREIGN KEY (category_id) REFERENCES categories(category_id) ON DELETE RESTRICT,
  CONSTRAINT fk_item_location FOREIGN KEY (location_id) REFERENCES storage_locations(location_id) ON DELETE RESTRICT,
  CONSTRAINT fk_item_finder FOREIGN KEY (finder_id) REFERENCES finders(finder_id) ON DELETE RESTRICT,
  CONSTRAINT fk_item_receiver FOREIGN KEY (received_by) REFERENCES staff(staff_id) ON DELETE RESTRICT,
  CONSTRAINT ck_item_name CHECK (CHAR_LENGTH(TRIM(item_name)) > 0),
  CONSTRAINT ck_item_description CHECK (CHAR_LENGTH(TRIM(description)) > 0),
  CONSTRAINT ck_found_place CHECK (CHAR_LENGTH(TRIM(found_place)) > 0)
) ENGINE=InnoDB;

-- Claim is an associative/transaction entity. A claimant may make more than one
-- attempt on an item, so (item_id, claimant_id) is NOT a unique key.
-- The local claim_no identifies each attempt within the parent item.
CREATE TABLE claims (
  item_id INT NOT NULL,
  claim_no INT NOT NULL,
  claimant_id INT NOT NULL,
  reviewed_by INT NULL,
  proof_description VARCHAR(255) NOT NULL,
  decision ENUM('Pending','Approved','Rejected') NOT NULL DEFAULT 'Pending',
  claim_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  decision_at DATETIME NULL,
  -- MySQL UNIQUE permits multiple NULLs: at most one approved claim per item.
  approved_item_id INT GENERATED ALWAYS AS
     (CASE WHEN decision = 'Approved' THEN item_id ELSE NULL END) STORED,
  CONSTRAINT pk_claims PRIMARY KEY (item_id, claim_no),
  CONSTRAINT uq_one_approved_per_item UNIQUE (approved_item_id),
  CONSTRAINT fk_claim_item FOREIGN KEY (item_id) REFERENCES items(item_id) ON DELETE RESTRICT,
  CONSTRAINT fk_claim_claimant FOREIGN KEY (claimant_id) REFERENCES claimants(claimant_id) ON DELETE RESTRICT,
  CONSTRAINT fk_claim_reviewer FOREIGN KEY (reviewed_by) REFERENCES staff(staff_id) ON DELETE RESTRICT,
  CONSTRAINT ck_claim_no CHECK (claim_no > 0),
  CONSTRAINT ck_claim_proof CHECK (CHAR_LENGTH(TRIM(proof_description)) > 0),
  CONSTRAINT ck_claim_review CHECK (
     (decision='Pending' AND reviewed_by IS NULL AND decision_at IS NULL) OR
     (decision IN ('Approved','Rejected') AND reviewed_by IS NOT NULL AND decision_at IS NOT NULL)
  )
) ENGINE=InnoDB;

-- Weak / identification-dependent: the same parent item can be released ONCE.
-- Composite FK ensures release is tied to an actual claim of the same item.
CREATE TABLE releases (
  item_id INT PRIMARY KEY,
  claim_no INT NOT NULL,
  released_by INT NOT NULL,
  released_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  acknowledgment VARCHAR(120) NOT NULL,
  CONSTRAINT fk_release_claim FOREIGN KEY (item_id, claim_no)
    REFERENCES claims(item_id, claim_no) ON DELETE RESTRICT,
  CONSTRAINT fk_release_staff FOREIGN KEY (released_by)
    REFERENCES staff(staff_id) ON DELETE RESTRICT,
  CONSTRAINT ck_ack CHECK (CHAR_LENGTH(TRIM(acknowledgment)) > 0)
) ENGINE=InnoDB;

-- MySQL trigger ensures a rejected/pending claim cannot be released even via raw SQL.
DELIMITER $$
CREATE TRIGGER trg_release_must_be_approved
BEFORE INSERT ON releases FOR EACH ROW
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM claims
    WHERE item_id=NEW.item_id AND claim_no=NEW.claim_no AND decision='Approved'
  ) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Release requires an approved claim';
  END IF;
END$$

CREATE TRIGGER trg_release_update_must_be_approved
BEFORE UPDATE ON releases FOR EACH ROW
BEGIN
  IF NEW.item_id <> OLD.item_id OR NOT EXISTS (
    SELECT 1 FROM claims
    WHERE item_id=NEW.item_id AND claim_no=NEW.claim_no AND decision='Approved'
  ) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Updated release must reference an approved claim of the same item';
  END IF;
END$$

CREATE TRIGGER trg_no_claim_after_release
BEFORE INSERT ON claims FOR EACH ROW
BEGIN
  IF EXISTS (SELECT 1 FROM releases WHERE item_id=NEW.item_id) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Item already released';
  END IF;
END$$

CREATE TRIGGER trg_keep_released_claim_approved
BEFORE UPDATE ON claims FOR EACH ROW
BEGIN
  IF EXISTS (
    SELECT 1 FROM releases WHERE item_id=OLD.item_id AND claim_no=OLD.claim_no
  ) AND (NEW.decision <> 'Approved' OR NEW.item_id <> OLD.item_id OR NEW.claim_no <> OLD.claim_no) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Cannot invalidate a completed release';
  END IF;
END$$
DELIMITER ;

CREATE INDEX idx_items_found_date ON items(found_at);
CREATE INDEX idx_claims_decision_date ON claims(decision, claim_date);

CREATE VIEW v_item_overview AS
SELECT i.item_id, i.item_name, i.description, i.found_at, i.found_place,
       c.category_name, l.location_name,
       CASE WHEN r.item_id IS NULL THEN 'Stored' ELSE 'Released' END AS item_status
FROM items i
JOIN categories c ON c.category_id=i.category_id
JOIN storage_locations l ON l.location_id=i.location_id
LEFT JOIN releases r ON r.item_id=i.item_id;

