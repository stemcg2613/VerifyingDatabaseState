-- Question 1a: Add PRICE and DESCRIPTION columns to PRODUCTLIST
ALTER TABLE productlist
ADD (
    price NUMBER(8,2),
    description VARCHAR2(250)
);

-- Question 1b: Move price and description from STOREFRONT to PRODUCTLIST
UPDATE productlist p
SET (price, description) =
    (
        SELECT s.price, s.description
        FROM storefront s
        WHERE s.productcode = p.productcode
    )
WHERE EXISTS (
    SELECT 1
    FROM storefront s
    WHERE s.productcode = p.productcode
);

-- Question 1c: Drop STOREFRONT table
DROP TABLE storefront;

-- Question 2: Create CHATLOG table
CREATE TABLE chatlog (
    chatid     NUMBER(3),
    receiverid NUMBER(3),
    senderid   NUMBER(3),
    datesent   DATE,
    content    VARCHAR2(250),
    CONSTRAINT chatlog_pk PRIMARY KEY (chatid),
    CONSTRAINT chatlog_receiver_fk FOREIGN KEY (receiverid)
        REFERENCES userbase(userid),
    CONSTRAINT chatlog_sender_fk FOREIGN KEY (senderid)
        REFERENCES userbase(userid)
);

-- Question 2: Insert sample data into CHATLOG
BEGIN
  INSERT INTO chatlog VALUES (1, 101, 102, SYSDATE, 'Hey, are you online?');
  INSERT INTO chatlog VALUES (2, 102, 101, SYSDATE, 'Yes, what''s up?');
  INSERT INTO chatlog VALUES (3, 103, 101, SYSDATE, 'Want to play later?');
END;
/

-- Question 3: Create FRIENDSLIST table
CREATE TABLE friendslist (
    userid   NUMBER(3),
    friendid NUMBER(3),
    CONSTRAINT friendslist_pk PRIMARY KEY (userid, friendid),
    CONSTRAINT friendslist_user_fk FOREIGN KEY (userid)
        REFERENCES userbase(userid),
    CONSTRAINT friendslist_friend_fk FOREIGN KEY (friendid)
        REFERENCES userbase(userid)
);

-- Question 3: Insert sample data into FRIENDSLIST
BEGIN
INSERT INTO friendslist VALUES (101, 102);
INSERT INTO friendslist VALUES (101, 103);
INSERT INTO friendslist VALUES (102, 103);
INSERT INTO friendslist VALUES (103, 104);
END;
/

-- Question 4: Create WISHLIST table
CREATE TABLE wishlist (
    userid       NUMBER(3),
    productcode  VARCHAR2(5),
    position     NUMBER(3),
    CONSTRAINT wishlist_pk PRIMARY KEY (userid, productcode),
    CONSTRAINT wishlist_user_fk FOREIGN KEY (userid)
        REFERENCES userbase(userid),
    CONSTRAINT wishlist_product_fk FOREIGN KEY (productcode)
        REFERENCES productlist(productcode)
);

-- Question 4: Insert sample data into WISHLIST
BEGIN
  INSERT INTO productlist (productcode) VALUES ('P1001');
  INSERT INTO productlist (productcode) VALUES ('P1002');
  INSERT INTO productlist (productcode) VALUES ('P1003');
END;
/


-- Question 5: Create USERPROFILE table
CREATE TABLE userprofile (
    userid      NUMBER(3),
    imagefile   VARCHAR2(250),
    description VARCHAR2(250),
    CONSTRAINT userprofile_pk PRIMARY KEY (userid),
    CONSTRAINT userprofile_user_fk FOREIGN KEY (userid)
        REFERENCES userbase(userid)
);

-- Question 5: Insert sample data into USERPROFILE
BEGIN
INSERT INTO userprofile VALUES (101, '/images/101.png', 'Competitive gamer');
INSERT INTO userprofile VALUES (102, '/images/102.png', 'Casual player');
INSERT INTO userprofile VALUES (103, '/images/103.png', 'RPG enthusiast');
END;
/

-- Question 6: Create SECURITYQUESTION table
CREATE TABLE securityquestion (
    questionid NUMBER,
    userid     NUMBER(3),
    question   VARCHAR2(250),
    answer     VARCHAR2(250),
    CONSTRAINT securityquestion_pk PRIMARY KEY (questionid),
    CONSTRAINT securityquestion_user_fk FOREIGN KEY (userid)
        REFERENCES userbase(userid)
);

-- Question 6: Insert 10 rows using existing USERBASE userids
INSERT INTO securityquestion (questionid, userid, question, answer)
SELECT
    1000 + ROWNUM AS questionid,
    u.userid,
    CASE MOD(ROWNUM,5)
        WHEN 0 THEN 'What was the name of your first pet?'
        WHEN 1 THEN 'What city were you born in?'
        WHEN 2 THEN 'What is your favorite color?'
        WHEN 3 THEN 'What is your mother''s maiden name?'
        ELSE        'What was your first car?'
    END AS question,
    CASE MOD(ROWNUM,5)
        WHEN 0 THEN 'Buddy'
        WHEN 1 THEN 'Richmond'
        WHEN 2 THEN 'Blue'
        WHEN 3 THEN 'Smith'
        ELSE        'Civic'
    END AS answer
FROM (SELECT userid FROM userbase WHERE ROWNUM <= 10) u;


-- Question 7: Create COMMUNITYRULES table
CREATE TABLE communityrules (
    rulenum       NUMBER(3),
    title         VARCHAR2(250),
    description   VARCHAR2(250),
    severitypoint NUMBER(4),
    CONSTRAINT communityrules_pk PRIMARY KEY (rulenum)
);

-- Question 7: Insert 10 rows
BEGIN
INSERT INTO communityrules VALUES (1,  'No Harassment',        'Do not harass or threaten others.',            1000);
INSERT INTO communityrules VALUES (2,  'No Hate Speech',       'No hateful language or slurs.',              1000);
INSERT INTO communityrules VALUES (3,  'No Cheating',          'No cheating, exploits, or unfair advantages.', 500);
INSERT INTO communityrules VALUES (4,  'No Spamming',          'No repeated or disruptive messages.',         200);
INSERT INTO communityrules VALUES (5,  'No Impersonation',     'Do not impersonate other users.',             300);
INSERT INTO communityrules VALUES (6,  'Appropriate Content',  'Keep content appropriate for all audiences.', 250);
INSERT INTO communityrules VALUES (7,  'No Scams',             'No scams, phishing, or fraud.',              800);
INSERT INTO communityrules VALUES (8,  'Respect Privacy',      'Do not share private info of others.',        900);
INSERT INTO communityrules VALUES (9,  'No NSFW Content',      'No sexually explicit content.',               700);
INSERT INTO communityrules VALUES (10, 'Follow Moderators',    'Follow moderator instructions.',              150);
END;
/


-- Question 8: Create INFRACTIONS table
CREATE TABLE infractions (
    infractionid NUMBER,
    userid       NUMBER(3),
    rulenum      NUMBER(3),
    dateassigned DATE,
    penalty      VARCHAR2(250),
    CONSTRAINT infractions_pk PRIMARY KEY (infractionid),
    CONSTRAINT infractions_user_fk FOREIGN KEY (userid)
        REFERENCES userbase(userid),
    CONSTRAINT infractions_rule_fk FOREIGN KEY (rulenum)
        REFERENCES communityrules(rulenum)
);

-- Question 8: Insert 10 rows using existing USERBASE userids and existing COMMUNITYRULES rulenum
INSERT INTO infractions (infractionid, userid, rulenum, dateassigned, penalty)
SELECT
    2000 + ROWNUM AS infractionid,
    u.userid,
    1 + MOD(ROWNUM,10) AS rulenum,
    SYSDATE - MOD(ROWNUM, 14) AS dateassigned,
    CASE
        WHEN MOD(ROWNUM,3) = 0 THEN 'Warning issued'
        WHEN MOD(ROWNUM,3) = 1 THEN '24 hour suspension'
        ELSE                    '7 day suspension'
    END AS penalty
FROM (SELECT userid FROM userbase WHERE ROWNUM <= 10) u;



-- Question 9: Create USERSUPPORT table
CREATE TABLE usersupport (
    ticketid      NUMBER,
    email         VARCHAR2(250),
    issue         VARCHAR2(250),
    datesubmitted DATE,
    dateupdated   DATE,
    status        VARCHAR2(250),
    CONSTRAINT usersupport_pk PRIMARY KEY (ticketid)
);

-- Question 9: Insert 10 rows
BEGIN
INSERT INTO usersupport VALUES (3001, 'user1@email.com',  'Cannot login',             SYSDATE-10, SYSDATE-9,  'NEW');
INSERT INTO usersupport VALUES (3002, 'user2@email.com',  'Password reset not working',SYSDATE-9,  SYSDATE-7,  'IN PROGRESS');
INSERT INTO usersupport VALUES (3003, 'user3@email.com',  'Payment issue',            SYSDATE-8,  SYSDATE-1,  'IN PROGRESS');
INSERT INTO usersupport VALUES (3004, 'user4@email.com',  'Refund request',           SYSDATE-7,  SYSDATE-6,  'CLOSED');
INSERT INTO usersupport VALUES (3005, 'user5@email.com',  'Game crashes on launch',   SYSDATE-6,  SYSDATE-5,  'NEW');
INSERT INTO usersupport VALUES (3006, 'user6@email.com',  'Account hacked',           SYSDATE-5,  SYSDATE-2,  'IN PROGRESS');
INSERT INTO usersupport VALUES (3007, 'user7@email.com',  'Friend request bug',       SYSDATE-4,  SYSDATE-3,  'CLOSED');
INSERT INTO usersupport VALUES (3008, 'user8@email.com',  'Chat not sending',         SYSDATE-3,  SYSDATE-2,  'NEW');
INSERT INTO usersupport VALUES (3009, 'user9@email.com',  'Wrong charge',             SYSDATE-2,  SYSDATE-1,  'CLOSED');
INSERT INTO usersupport VALUES (3010, 'user10@email.com', 'Cannot download update',   SYSDATE-1,  SYSDATE,    'NEW');
END;
/

-- Question 10a: View of every unique QUESTION from SECURITYQUESTION
CREATE OR REPLACE VIEW vw_unique_security_questions AS
SELECT DISTINCT question
FROM securityquestion;

-- Question 10b: View of open tickets (NEW or IN PROGRESS)
CREATE OR REPLACE VIEW vw_open_tickets AS
SELECT ticketid, email, issue, datesubmitted, dateupdated, status
FROM usersupport
WHERE status IN ('NEW', 'IN PROGRESS');

SELECT *
FROM vw_open_tickets
ORDER BY dateupdated;
