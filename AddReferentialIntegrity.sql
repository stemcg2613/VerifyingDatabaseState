/* =========================================================
   AddReferentialIntegrity.sql
   Steven McGraw
   ========================================================= */

/* ---------------------------------------------------------
   Enforce referential integrity
   --------------------------------------------------------- */

-- Add foreign key to ORDERS
ALTER TABLE orders
ADD CONSTRAINT fk_orders_user
FOREIGN KEY (userid)
REFERENCES userbase(userid);

-- Enforce referential integrity on REVIEWS
ALTER TABLE reviews
ADD CONSTRAINT fk_reviews_product
FOREIGN KEY (productcode)
REFERENCES productlist(productcode);

-- Enforce referential integrity on USERLIBRARY
ALTER TABLE userlibrary
ADD CONSTRAINT fk_userlibrary_user
FOREIGN KEY (userid)
REFERENCES userbase(userid);



/* ---------------------------------------------------------
   Users eligible to be moderators (18+)
   --------------------------------------------------------- */
-- Display full name and username of users at least 18 years old
SELECT firstname || ' ' || lastname AS full_name,
       username
FROM userbase
WHERE MONTHS_BETWEEN(SYSDATE, birthday) / 12 >= 18;


/* ---------------------------------------------------------
   Username length analysis
   --------------------------------------------------------- */
-- Maximum and average username length
SELECT MAX(LENGTH(username)) AS max_username_length,
       ROUND(AVG(LENGTH(username)), 2) AS avg_username_length
FROM userbase;


/* ---------------------------------------------------------
   Security questions that start with 'What is' or 'What was'
   --------------------------------------------------------- */
SELECT question
FROM securityquestion
WHERE question LIKE 'What is%'
   OR question LIKE 'What was%';



/* ---------------------------------------------------------
   Game popularity: lowest rating and review count
   --------------------------------------------------------- */
SELECT productcode,
       MIN(rating) AS lowest_rating,
       COUNT(*) AS review_count
FROM reviews
GROUP BY productcode
ORDER BY review_count DESC;


/* ---------------------------------------------------------
   Wishlist popularity (ranked at position 1)
   --------------------------------------------------------- */
SELECT productcode,
       COUNT(*) AS user_count
FROM wishlist
WHERE position = 1
GROUP BY productcode;


-- Total amount each user has spent
SELECT userid,
       SUM(price) AS total_spent
FROM orders
GROUP BY userid
ORDER BY total_spent DESC;


-- Most profitable days by purchase date
SELECT purchasedate,
       SUM(price) AS gross_profit
FROM orders
GROUP BY purchasedate
ORDER BY gross_profit DESC;


/* ---------------------------------------------------------
   Top 5 games by total play time
   --------------------------------------------------------- */
SELECT productcode,
       SUM(hoursplayed) AS total_hours
FROM userlibrary
GROUP BY productcode
ORDER BY total_hours DESC
FETCH FIRST 5 ROWS ONLY;


/* ---------------------------------------------------------
   View: Users with most infractions
   --------------------------------------------------------- */
CREATE OR REPLACE VIEW vw_user_infractions AS
SELECT userid,
       COUNT(*) AS infraction_count
FROM infractions
GROUP BY userid
ORDER BY infraction_count DESC;


/* ---------------------------------------------------------
   View: Infractions per rule per user
   --------------------------------------------------------- */
CREATE OR REPLACE VIEW vw_user_rule_violations AS
SELECT userid,
       rulenumber,
       COUNT(*) AS violation_count
FROM infractions
GROUP BY userid, rulenum
ORDER BY userid;


/* ---------------------------------------------------------
   Penalty assignments per rule
   --------------------------------------------------------- */
SELECT rulenum,
       penalty,
       COUNT(*) AS times_assigned
FROM infractions
GROUP BY rulenum, penalty;


/* ---------------------------------------------------------
   Ticket turnaround statistics (CLOSED tickets)
   --------------------------------------------------------- */
SELECT AVG(dateupdated - datesubmitted) AS avg_days,
       MAX(dateupdated - datesubmitted) AS max_days,
       MIN(dateupdated - datesubmitted) AS min_days
FROM usersupport
WHERE status = 'CLOSED';


/* ---------------------------------------------------------
   Repeated NEW ticket issues
   --------------------------------------------------------- */
SELECT email,
       issue,
       COUNT(*) AS issue_count
FROM usersupport
WHERE status = 'NEW'
GROUP BY email, issue
ORDER BY issue_count DESC;


/* ---------------------------------------------------------
   Users with insecure passwords
   --------------------------------------------------------- */
SELECT userid,
       firstname,
       lastname
FROM userbase
WHERE password LIKE '%' || firstname || '%'
   OR password LIKE '%' || lastname || '%';


/* ---------------------------------------------------------
   Average product price by publisher
   --------------------------------------------------------- */
SELECT publisher,
       ROUND(AVG(price), 2) AS avg_price
FROM productlist
GROUP BY publisher
ORDER BY publisher;


/* ---------------------------------------------------------
   View: Discounted products older than 5 years (25% off)
   --------------------------------------------------------- */
CREATE OR REPLACE VIEW vw_discounted_products AS
SELECT productname,
       price * 0.75 AS discounted_price
FROM productlist
WHERE releasedate < ADD_MONTHS(SYSDATE, -60);


/* ---------------------------------------------------------
   Max and min price by genre
   --------------------------------------------------------- */
SELECT genre,
       MAX(price) AS max_price,
       MIN(price) AS min_price
FROM productlist
GROUP BY genre
ORDER BY genre;


/* ---------------------------------------------------------
   View: Chat messages from the last week
   --------------------------------------------------------- */
CREATE OR REPLACE VIEW vw_recent_chatlog AS
SELECT *
FROM chatlog
WHERE datesent BETWEEN SYSDATE - 7 AND SYSDATE;


/* ---------------------------------------------------------
   View: Recent infractions with penalties (last month)
   --------------------------------------------------------- */
CREATE OR REPLACE VIEW vw_recent_penalties AS
SELECT userid,
       dateassigned,
       penalty
FROM infractions
WHERE penalty IS NOT NULL
  AND dateassigned >= ADD_MONTHS(SYSDATE, -1);
