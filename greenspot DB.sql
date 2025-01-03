-- Create the database --NB
CREATE SCHEMA IF NOT EXISTS `StoreDB` DEFAULT CHARACTER SET utf8;
USE `StoreDB`;
-- Table `Vendors`
CREATE TABLE IF NOT EXISTS `Vendors` (
  `Vendor ID` INT NOT NULL AUTO_INCREMENT, 
  `Vendor` VARCHAR(45) NOT NULL, 
  `Vendor Address` VARCHAR(225) NOT NULL, 
  PRIMARY KEY (`Vendor ID`)
) ENGINE = InnoDB;
-- Table `Inventory`
CREATE TABLE IF NOT EXISTS `Inventory` (
  `Inventory ID` INT NOT NULL AUTO_INCREMENT, 
  `Vendor ID` INT NOT NULL, 
  `Item ID` INT NOT NULL, 
  `Quantity on-hand` INT NOT NULL, 
  `Cost` FLOAT NULL, 
  `Purchase Date` DATE NULL, 
  `Unit` VARCHAR(45) NOT NULL, 
  `Location` VARCHAR(45) NOT NULL, 
  `Description` TEXT(225) NULL, 
  `Item Type` VARCHAR(45) NOT NULL, 
  PRIMARY KEY (`Inventory ID`), 
  UNIQUE INDEX `Item_ID_UNIQUE` (`Item ID`), 
  -- Added this unique index
  INDEX `fk_Inventory_Vendors_idx` (`Vendor ID`), 
  CONSTRAINT `fk_Inventory_Vendors` FOREIGN KEY (`Vendor ID`) REFERENCES `Vendors` (`Vendor ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB;
-- Table `Sales`
CREATE TABLE IF NOT EXISTS `Sales` (
  `Sales ID` INT NOT NULL AUTO_INCREMENT, 
  `Price` FLOAT NOT NULL, 
  `Date sold` DATE NOT NULL, 
  `Quantity Sold` INT NOT NULL, 
  `Item ID` INT NOT NULL, 
  PRIMARY KEY (`Sales ID`), 
  INDEX `fk_Sales_Inventory_idx` (`Item ID`), 
  CONSTRAINT `fk_Sales_Inventory` FOREIGN KEY (`Item ID`) REFERENCES `Inventory` (`Item ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB;
-- NB
-- imported greenspot_csv using mysql import wizard which contains the original csv files which have been cleaned in excel 
USE `Storedb`;
INSERT INTO Vendors (`Vendor`, `Vendor Address`) 
SELECT 
  DISTINCT `Vendor`, 
  `Vendor Address` 
FROM 
  greenspot 
WHERE 
  `Vendor` IS NOT NULL 
  AND `Vendor Address` IS NOT NULL;
/*
-- deleted repeated columns to leave only unique columns 
SELECT * FROM Vendors
WHERE `Vendor ID` NOT IN('1', '3', '6'); -- here's a check to see rows to be deleted
*/
DELETE FROM 
  `Vendors` 
WHERE 
  `Vendor ID` NOT IN('1', '3', '6');

-- NB
-- inventory table insert
-- changed the constraint on item  ID column as the values do not need to be unique
SELECT 
  CONSTRAINT_NAME 
FROM 
  INFORMATION_SCHEMA.KEY_COLUMN_USAGE 
WHERE 
  TABLE_NAME = 'Inventory' 
  AND COLUMN_NAME = 'Item ID';
SELECT 
  CONSTRAINT_NAME, 
  TABLE_NAME 
FROM 
  INFORMATION_SCHEMA.KEY_COLUMN_USAGE 
WHERE 
  REFERENCED_TABLE_NAME = 'Inventory' 
  AND REFERENCED_COLUMN_NAME = 'Item ID';
ALTER TABLE 
  `sales` 
DROP 
  FOREIGN KEY `fk_Sales_Inventory`;
ALTER TABLE 
  `Inventory` 
DROP 
  INDEX `Item_ID_UNIQUE`;
  
  /*SELECT `purchase date`, STR_TO_DATE(`purchase date`, '%m/%d/%Y %H:%i') AS ConvertedDate
FROM greenspot
LIMIT 5; -- testing date conversion 

SELECT `cost`, CAST(`cost` AS DECIMAL(10,2)) AS ConvertedCost
FROM greenspot
LIMIT 5; -- testing cost column values conversion

 SELECT 
    `cost`, 
    NULLIF(TRIM(`cost`), '') AS Cost2,
    CAST(NULLIF(TRIM(`cost`), '') AS DECIMAL(10,2)) AS ConvertedCost
FROM greenspot
LIMIT 5; */

-- NB
 INSERT INTO Inventory (`Description`, `Quantity on-hand`, `Item ID`, `Cost`, `Purchase Date`, `Unit`, `Item Type`, `Location`, `Vendor ID`)
SELECT DISTINCT 
    `description`, 
    `quantity on-hand`, 
    `item num`, 
    CAST(NULLIF(TRIM(`cost`), '') AS DECIMAL(10,2)) AS `Cost`, -- Handle empty values as NULL, then cast to DECIMAL
    STR_TO_DATE(`purchase date`, '%m/%d/%Y %H:%i') AS `Purchase Date`,  -- Correct date conversion
    `unit`, 
    `item type`, 
    `location`, 
    (SELECT `Vendor ID` FROM Vendors WHERE Vendors.`Vendor` = greenspot.`vendor`) AS `Vendor ID` 
FROM greenspot;

/*
SELECT * FROM greenspot;

Select * from sales;


Select * from vendors;
select * from inventory;
*/


--  inserted customer ID column as this was oimmited earlier

ALTER TABLE Sales
ADD COLUMN `Customer` VARCHAR(255) AFTER `Item ID`;

/*
INSERT INTO Sales (`price`, `Date sold`, `Quantity sold`, `Item ID`, `Customer`)
SELECT 
    CAST(NULLIF(TRIM(`price`), '') AS DECIMAL(10,2)) AS `price`, 
    STR_TO_DATE(`date sold`, '%m/%d/%Y %H:%i') AS `date sold`, -- date conversion
    `Quantity` AS `quantity sold`,
    `item num` AS `Item ID`, 
    `cust` AS `Customer`
FROM greenspot
WHERE `date sold` IS NOT NULL;


SELECT `date sold`, STR_TO_DATE(`date sold`, '%m/%d/%Y %H:%i') AS ConvertedDate -- date conversion check
FROM greenspot;
*/



INSERT INTO Sales (`price`, `Date sold`, `Quantity sold`, `Item ID`)
SELECT 
    CAST(NULLIF(TRIM(`price`), '') AS DECIMAL(10,2)) AS `price`,
    IF(TRIM(`date sold`) = '' OR STR_TO_DATE(`date sold`, '%m/%d/%Y %H:%i') IS NULL, NULL, STR_TO_DATE(`date sold`, '%m/%d/%Y %H:%i')) AS `date sold`,
    `Quantity` AS `quantity sold`,
    `item num` AS `Item ID`
FROM greenspot;



UPDATE Sales
JOIN greenspot ON Sales.`Item ID` = greenspot.`item num`
SET Sales.`customer` = greenspot.`cust`
WHERE greenspot.`item num` IS NOT NULL;

-- NB
