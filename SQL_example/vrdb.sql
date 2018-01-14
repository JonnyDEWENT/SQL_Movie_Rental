SPOOL project.out
SET ECHO ON
-- (in case they already exist)
--
DROP TABLE StoreLocation CASCADE CONSTRAINTS;
DROP TABLE Movie CASCADE CONSTRAINTS;
DROP TABLE Employees CASCADE CONSTRAINTS;
DROP TABLE Rentals CASCADE CONSTRAINTS;
DROP TABLE Customer CASCADE CONSTRAINTS;
DROP TABLE PhoneNumbers CASCADE CONSTRAINTS;
DROP TABLE InStock CASCADE CONSTRAINTS;
--
CREATE TABLE StoreLocation (
  locID       number(3) PRIMARY KEY,
  address     varchar2(50)
);
--
--
CREATE TABLE Movie (
  mID          number(5) PRIMARY KEY,
  title        varchar2(25),
  format       varchar2(9),
  dailyCost    number(3),
  CONSTRAINT illegal_format CHECK (format in ('DVD', 'Blu-Ray', 'Game')),
  CONSTRAINT dvd_min_cost CHECK (NOT(dailyCost < 1.00 AND  format in ('DVD'))),
  CONSTRAINT blu_ray_min_cost CHECK (NOT(dailyCost < 2.00 AND format in ('Blu-Ray'))),
  CONSTRAINT game_min_cost CHECK (NOT(dailyCost < 1.50 AND format in ('Game')))
);
--
--
CREATE TABLE Employees (
  eID         number(4) PRIMARY KEY,
  fname       char(15),
  lname       char(15),
  locationID     number(3),
  managerID   number(4),
  CONSTRAINT fo_key FOREIGN KEY(locationID) REFERENCES StoreLocation(locID)
     Deferrable initially deferred,
  CONSTRAINT invalid_mgr CHECK (eID != managerID)
);
--
--
CREATE TABLE Customer (
  phoneNumber number(10) PRIMARY KEY,
  FNAME       char(15),
  LNAME       char(15)
);
--
--
CREATE TABLE Rentals (
  rentalDate  date,
  storeID     number(3),
  mvID     number(5),
  phoneNum    number(10),
  primary key (rentalDate, storeID, mvID, phoneNum),
  dueDate     date,
  CONSTRAINT store_id_check FOREIGN KEY(storeID) REFERENCES StoreLocation(locID)
      Deferrable initially deferred,
  CONSTRAINT movie_id_check FOREIGN KEY(mvID) REFERENCES Movie(mID)
     Deferrable initially deferred,
  CONSTRAINT cust_check FOREIGN KEY(phoneNum) REFERENCES Customer(phoneNumber)
     Deferrable initially deferred,
  CONSTRAINT invalid_due_date CHECK (rentalDate < dueDate)
);
--
--
CREATE TABLE PhoneNumbers (
  LocPhoneNum number(10),
  location    number(3),
  primary key (LocPhoneNum, location)
);
--
-- INSERT INTEGRITY CONSTRAINTS
CREATE TABLE InStock (
  lID         number(3),
  movieID     number(5),
  primary key (lID, movieID),
  numCopies   number(2),
  numAvail    number(2),
  CONSTRAINT loc_id_check FOREIGN KEY(lID) REFERENCES StoreLocation(locID),
  CONSTRAINT mov_id_check FOREIGN KEY(movieID) REFERENCES Movie(mID),
  CONSTRAINT in_stock_check CHECK (numCopies > 0),
  CONSTRAINT over_stock CHECK (numAvail <= numCopies)
);
-- Add the foreign keys:
-- ******** NEEDS TO BE CHANGED TO MATCH OUR DATABASE ***********
--
--
/*
ALTER TABLE Employees
ADD FOREIGN KEY (managerID) references Employees(eID)
Deferrable initially deferred;
ALTER TABLE Employees
ADD FOREIGN KEY (locationID) references StoreLocation(locID)
Deferrable initially deferred;
ALTER TABLE Rentals
ADD FOREIGN KEY (storeID) references StoreLocation(locID)
Deferrable initially deferred;
ALTER TABLE Rentals
ADD FOREIGN KEY (phoneNum) references Customer(phoneNumber)
Deferrable initially deferred;
ALTER TABLE PhoneNumbers
ADD FOREIGN KEY (location) references StoreLocation(locID)
Deferrable initially deferred;
ALTER TABLE InStock
ADD FOREIGN KEY (lID) references StoreLocation(locID)
Deferrable initially deferred;
ALTER TABLE InStock
ADD FOREIGN KEY (movieID) references Movie(mID)
Deferrable initially deferred;
*/
--
-- ----------------------------------------------------------
-- Populate the database
-- ----------------------------------------------------------
-- DATE FORMAT
alter session set  NLS_DATE_FORMAT = 'YYYY-MM-DD';
--
--
SET FEEDBACK OFF
insert into StoreLocation values (489, '1234 Baker rd. Grand Haven MI 49417');
insert into StoreLocation values (123, '567 Left rd. Lansing MI 49876');
insert into StoreLocation values (834, '8987 Hall st. Grand Rapids MI 49503');
--
--
insert into Movie values (12345, 'The Avengers', 'Blu-Ray', 4.00);
insert into Movie values (98765, 'Hacksaw Ridge', 'DVD', 2.50);
insert into Movie values (34592, 'Shaw-shank Redemption', 'DVD', 1.50);
insert into Movie values (38576, '42', 'Blu-Ray', 4.00);
insert into Movie values (91234, 'The Cube', 'DVD', 1.50);
insert into Movie values (74852, 'Lethal Weapon 27', 'Blu-Ray', 4.00);
--
--
insert into Employees values (1234, 'Jake', 'fromStateFarm', 489, 3567);
insert into Employees values (3566, 'John', 'Wick', 489, NULL);
insert into Employees values (4567, 'Jane', 'Doe', 123, 8888);
insert into Employees values (7453, 'Sterling', 'Archer', 834, NULL);
insert into Employees values (2341, 'Doctor', 'Krieger', 834, 7453);
insert into Employees values (8888, 'Hank', 'Berry', 123, 8881);
insert into Employees values (8881, 'Zack', 'Bryant', 123, NULL);
--
--
insert into Rentals values ('2015-09-24', 489, 12345, 9876543210, '2015-09-26');
insert into Rentals values ('2016-08-04', 123, 12345, 7584567906, '2016-08-05');
insert into Rentals values ('2017-02-19', 489, 12345, 3478964321, '2017-02-23');
insert into Rentals values ('2017-01-15', 489, 98765, 9876543210, '2017-01-17');
insert into Rentals values ('2017-06-08', 834, 98765, 9876543210, '2017-06-10');
insert into Rentals values ('2017-04-23', 834, 34592, 9876543210, '2017-04-28');
insert into Rentals values ('2013-08-21', 834, 34592, 2314798567, '2013-08-29');
insert into Rentals values ('2017-05-12', 834, 38576, 6168447890, '2017-05-13');
insert into Rentals values ('2017-07-13', 123, 91234, 2314798567, '2017-07-18');
insert into Rentals values ('2017-05-14', 123, 74852, 6168447890, '2017-05-17');
--
--
insert into Customer values (6168447890, 'Quin', 'Jackson');
insert into Customer values (2314798567, 'Gilbert', 'Trek');
insert into Customer values (3478964321, 'Roxy', 'Roxon');
insert into Customer values (9876543210, 'Chet', 'Manley');
insert into Customer values (5674890654, 'Adam', 'Moore');
insert into Customer values (7584567906, 'Jane', 'Doe');
--
--
insert into PhoneNumbers values (5559991255, 489);
insert into PhoneNumbers values (6165555555, 489);
insert into PhoneNumbers values (6168854376, 123);
insert into PhoneNumbers values (6168899976, 123);
insert into PhoneNumbers values (2318889876, 123);
insert into PhoneNumbers values (6165669876, 123);
insert into PhoneNumbers values (8005437895, 834);
insert into PhoneNumbers values (3214567890, 834);
--
--
insert into InStock values (489, 12345, 8, 6);
insert into InStock values (123, 12345, 2, 1);
insert into InStock values (834, 12345, 3, 3);
insert into InStock values (123, 34592, 5, 5);
insert into InStock values (834,34592, 7, 7);
insert into InStock values (489, 91234, 6, 5);
insert into InStock values (123, 91234, 7, 5);
insert into InStock values (834, 91234, 1, 1);
insert into InStock values (489, 74852, 3, 3);
insert into InStock values (123, 74852, 8, 2);
insert into InStock values (834, 98765, 2, 0);
--
--
--
--******************************************
/*-Testing Integrity CONSTRAINTS */
--******************************************
--
-- testing unique constraint for StoreLocation
insert into StoreLocation values (489, '1234 Jabovy rd. Ludington MI 49417');
-- testing store_id_check constraint for Rentals
insert into Rentals values ('2015-09-24', 999, 12345, 9876543210, '2015-09-26');
-- testing illegal_format constraint for movies
insert into Movie values (74852, 'Lethal Weapon 27', 'TVseries', 4.00);
-- testing over_stock constraint for InStock
insert into InStock values (834, 98765, 2, 3);
--
SET FEEDBACK ON
--*******************************************
/*-Printing Tables For REFERENCE */
--*******************************************
select *
from employees
--
select *
from storelocation
--
select *
from instock
--
select *
from phonenumbers
--
select *
from rentals
--
select *
from customer
--
select *
from movie
--
--
--*********************************************************
/*-Q1-JOINING 4 TABLES--------------------------------
Finds stores with available copies of "The Avengers" and phone numbers of people who have rented it to ask them how it was :)
*/
SELECT DISTINCT M.title, I.numAvail, S.address, R.phoneNum
FROM Movie M, InStock I, StoreLocation S, Rentals R
WHERE S.locID = R.storeID AND S.locID = I.lID AND I.movieID = M.mID AND M.mID = 12345 AND I.numAvail > 0
ORDER BY S.address;
--
--
/*-Q3-UNION QUERY-------------------------------------
Returns all rental options that are either "Blu-Ray" or cost at least $3/day to rent
*/
SELECT M.title, M.mID
FROM Movie M
WHERE M.format = 'Blu-Ray'
UNION
SELECT M.title, M.mID
FROM Movie M
WHERE M.dailyCost >= 3;
--
--
/*-Q5-GROUP BY, HAVING, ORDER BY QUERY----------------
Lists every available rental offered by each store location
*/
SELECT S.address, M.title
FROM   StoreLocation S, Movie M, InStock I
WHERE  S.locID = I.lID AND I.movieID = M.mID AND I.numAvail > 0
GROUP BY S.address, M.title
HAVING COUNT(M.dailyCost) = 1
ORDER BY S.address;
--
--
/*-Q7-NON-CORRELATED SUBQUERY-------------------------
Lists all customers who are not currently renting
*/
SELECT C.FNAME, C.LNAME
FROM   Customer C
WHERE  C.phoneNumber NOT IN
       (SELECT R.phoneNum
        FROM   Rentals R)
ORDER BY C.FNAME;
--
--
/*-Q9-OUTER JOIN QUERY-------------------------------
Returns the name of the renter and each date they rented an item on
*/
SELECT DISTINCT C.LNAME, R.rentalDate
FROM   Customer C
FULL OUTER JOIN Rentals R
ON C.phoneNumber = R.phoneNum
WHERE R.rentalDate IS NOT NULL;
--
--
/*-Q11-TOP-N QUERY-------------------------------
Lists the top-5 stores with the most copies of a specific title
*/
SELECT DISTINCT address, title, numCopies
FROM   (SELECT *
	FROM StoreLocation S, Movie M, InStock I
	WHERE S.locID = I.lID AND I.movieID = M.mID
	ORDER BY I.numCopies DESC)
WHERE ROWNUM < 6;
--
--
COMMIT;
SPOOL OFF

~
