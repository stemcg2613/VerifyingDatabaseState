-- Check which users have access to the database by displaying USER_ID, USERNAME, CREATED, PASSWORD_CHANGE_DATE
SELECT USER_ID, USERNAME, CREATED, PASSWORD_CHANGE_DATE
FROM USER_USERS;

-- Check what tables are present in the database by displaying everything in USER_TABLES
SELECT *
FROM USER_TABLES;

-- Describe the ORDERS table
SELECT column_id, column_name, data_type, data_length, nullable
FROM USER_TAB_COLUMNS
WHERE table_name = 'ORDERS'
ORDER BY column_id;

-- Describe the PRODUCTLIST table
SELECT column_id, column_name, data_type, data_length, nullable
FROM USER_TAB_COLUMNS
WHERE table_name = 'PRODUCTLIST'
ORDER BY column_id;

-- Describe the REVIEWS table
SELECT column_id, column_name, data_type, data_length, nullable
FROM USER_TAB_COLUMNS
WHERE table_name = 'REVIEWS'
ORDER BY column_id;

-- Describe the STOREFRONT table
SELECT column_id, column_name, data_type, data_length, nullable
FROM USER_TAB_COLUMNS
WHERE table_name = 'STOREFRONT'
ORDER BY column_id;

-- Describe the USERBASE table
SELECT column_id, column_name, data_type, data_length, nullable
FROM USER_TAB_COLUMNS
WHERE table_name = 'USERBASE'
ORDER BY column_id;

-- Describe the USERLIBRARY table
SELECT column_id, column_name, data_type, data_length, nullable
FROM USER_TAB_COLUMNS
WHERE table_name = 'USERLIBRARY'
ORDER BY column_id;

-- Display everything in the ORDERS table
SELECT *
FROM ORDERS;

-- Display everything in the PRODUCTLIST table
SELECT *
FROM PRODUCTLIST;

-- Display everything in the REVIEWS table
SELECT *
FROM REVIEWS;

-- Display everything in the STOREFRONT table
SELECT *
FROM STOREFRONT;

-- Display everything in the USERBASE table
SELECT *
FROM USERBASE;

-- Display everything in the USERLIBRARY table
SELECT *
FROM USERLIBRARY;

-- Display TABLE_NAME, CONSTRAINT_NAME, CONSTRAINT_TYPE, STATUS from USER_CONSTRAINTS
SELECT TABLE_NAME, CONSTRAINT_NAME, CONSTRAINT_TYPE, STATUS
FROM USER_CONSTRAINTS
ORDER BY TABLE_NAME, CONSTRAINT_NAME;

-- Display VIEW_NAME and TEXT columns in USER_VIEWS
SELECT VIEW_NAME, TEXT
FROM USER_VIEWS
ORDER BY VIEW_NAME;

-- Display every USERNAME in alphabetical order
SELECT USERNAME
FROM USERBASE
ORDER BY USERNAME ASC;

-- Display FIRSTNAME, LASTNAME, USERNAME, PASSWORD, EMAIL of any user who has a Yahoo email address
SELECT FIRSTNAME, LASTNAME, USERNAME, PASSWORD, EMAIL
FROM USERBASE
WHERE LOWER(EMAIL) LIKE '%@yahoo.com';

-- Display USERNAME, BIRTHDAY, WALLETFUNDS of any user who has less than $25 in funds
SELECT USERNAME, BIRTHDAY, WALLETFUNDS
FROM USERBASE
WHERE WALLETFUNDS < 25;

-- Display USERID and PRODUCTCODE of any user who has more than 100 HOURSPLAYED
SELECT USERID, PRODUCTCODE
FROM USERLIBRARY
WHERE HOURSPLAYED > 100;

-- Display PRODUCTCODE of any game that has less than 10 HOURSPLAYED
SELECT PRODUCTCODE
FROM USERLIBRARY
WHERE HOURSPLAYED < 10;

-- Display every unique PUBLISHER
SELECT DISTINCT PUBLISHER
FROM PRODUCTLIST
ORDER BY PUBLISHER;

-- Display PRODUCTNAME, RELEASEDATE, PUBLISHER, GENRE of all products, sorted by GENRE
SELECT PRODUCTNAME, RELEASEDATE, PUBLISHER, GENRE
FROM PRODUCTLIST
ORDER BY GENRE, PRODUCTNAME;

-- Display PRODUCTCODE and PUBLISHER of any product in the ‘Strategy’ GENRE
SELECT PRODUCTCODE, PUBLISHER
FROM PRODUCTLIST
WHERE GENRE = 'Strategy'
ORDER BY PRODUCTCODE;

-- Display PRODUCTCODE, DESCRIPTION, PRICE for any product that costs more than $25, sorted by descending PRICE
SELECT PRODUCTCODE, DESCRIPTION, PRICE
FROM STOREFRONT
WHERE PRICE > 25
ORDER BY PRICE DESC;

-- Display INVENTORYID and PRICE of all products in the STOREFRONT table, sorted by ascending PRICE
SELECT INVENTORYID, PRICE
FROM STOREFRONT
ORDER BY PRICE ASC;

-- Display PRODUCTCODE and REVIEW of any product with a RATING of 1
SELECT PRODUCTCODE, REVIEW
FROM REVIEWS
WHERE RATING = 1;

-- Display PRODUCTCODE and REVIEW of any product with a RATING of 4 or higher
SELECT PRODUCTCODE, REVIEW
FROM REVIEWS
WHERE RATING >= 4;

-- Display every unique USERID from users who have placed an order
SELECT DISTINCT USERID
FROM ORDERS
ORDER BY USERID;

-- Display all order data, sorted by the earliest PURCHASEDATE
SELECT *
FROM ORDERS
ORDER BY PURCHASEDATE ASC;
