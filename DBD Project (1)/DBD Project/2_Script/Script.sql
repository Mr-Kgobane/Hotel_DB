

---	Queries----

/*

--Employees and their titles--
Select EmployeeID, FirstName, LastName, Title
 from Employee E
 Join EmployeeTitle ET
 ON E.TitleID=ET.TitleID

 --Transaction that have a price above avg price--
 Select Name, Price
  from Transactions T
  join TransactionHistory TH
  ON T.TransactionID=TH.TransactionID
  Where Price>(select avg(price)
				from TransactionHistory)

--Transaction that have a price below avg price--
Select Name, Price
  from Transactions T
  join TransactionHistory TH
  ON T.TransactionID=TH.TransactionID
  Where Price<(select avg(price)
				from TransactionHistory)

--County of customers that have fewest transactions--
Select Country, FirstName, LastName
from Customer C
JOIN CustomerAddress CA
ON C.CustomerID=CA.CustomerID
WHERE Country=(Select TOP 1 Country
				from CustomerAddress CA
				 inner join Transactions T
				 ON CA.CustomerID=T.CustomerID
				 GROUP BY Country
				 ORDER BY COUNT(TransactionID))


--Summary of transactions
WITH Transumm(TransID, NumberOfTransactions, AveragePrice, TransDate)
AS
(Select TransactionID, COUNT(TransactionID), AVG(Price), TransactionDate
  from TransactionHistory
  group by TransactionID,TransactionDate)

select Name, NumberOfTransactions, AveragePrice, CONVERT(DATE,TransDate) as 'TransDate'
from Transactions T
join Transumm TS
on T.TransactionID=TS.TransID


*/


USE master

GO

CREATE LOGIN creator1
WITH PASSWORD = 'Password1';

CREATE DATABASE HotelTranselveinia

GO

USE HotelTranselveinia

GO



CREATE TABLE Customer
(CustomerID INT IDENTITY(2451570,1) PRIMARY KEY CLUSTERED,
 FirstName NVARCHAR(30),
 LastName NVARCHAR(30), 
 Phone NVARCHAR(30))

GO
 CREATE  INDEX "LastName" ON "dbo"."Customer"("LastName")
GO
 CREATE  INDEX "Phone" ON "dbo"."Customer"("Phone")
GO



CREATE TABLE CustomerAddress
(AddressID INT IDENTITY(28890,1) PRIMARY KEY CLUSTERED,
 CustomerID INT FOREIGN KEY REFERENCES Customer(CustomerID),
 StreetAddress NVARCHAR(30),
 City NVARCHAR(30),
 Region NVARCHAR(30),
 PostalCode INT,
 Country NVARCHAR(30))

GO
 CREATE  INDEX "City" ON "dbo"."CustomerAddress"("City")
GO
 CREATE  INDEX "PostalCode" ON "dbo"."CustomerAddress"("PostalCode")
GO
 CREATE  INDEX "Region" ON "dbo"."CustomerAddress"("Region")
GO


CREATE TABLE Hotel
(HotelID INT IDENTITY(1,1) PRIMARY KEY CLUSTERED,
 HotelName NVARCHAR(30),
 StarRating INT,
 Phone NVARCHAR(30))
GO
 CREATE  INDEX "HotelName" ON "dbo"."Hotel"("HotelName")
GO
 CREATE  INDEX "HotelID" ON "dbo"."Hotel"("HotelID")
GO
 CREATE  INDEX "Phone" ON "dbo"."Hotel"("Phone")
GO
 CREATE INDEX "StarRating" ON "dbo"."Hotel"("StarRating")
GO




CREATE TABLE HotelAddress
(AddressID INT IDENTITY(48890,1) PRIMARY KEY CLUSTERED,
 HotelID INT FOREIGN KEY REFERENCES Hotel(HotelID),
 StreetAddress NVARCHAR(30),
 City NVARCHAR(30),
 Region NVARCHAR(30),
 PostalCode INT,
 Country NVARCHAR(30))
GO
 CREATE  INDEX "City" ON "dbo"."HotelAddress"("City")
GO
 CREATE  INDEX "PostalCode" ON "dbo"."HotelAddress"("PostalCode")
GO
 CREATE  INDEX "Region" ON "dbo"."HotelAddress"("Region")
GO



CREATE TABLE Booking
(BookingID INT IDENTITY(23457,1) PRIMARY KEY CLUSTERED,
 HotelID INT FOREIGN KEY REFERENCES Hotel(HotelID),
 CheckinDate DATETIME,
 CheckoutDate DATETIME,
 TotalDue MONEY)
GO
 CREATE INDEX "CheckinDate" ON "dbo"."Booking"("CheckinDate")
GO


CREATE TABLE EmployeeTitle
(TitleID INT IDENTITY(1,1) PRIMARY KEY CLUSTERED,
 Title NVARCHAR(30))
GO
 CREATE INDEX "TitleID" ON "dbo"."EmployeeTitle"("TitleID")
GO
 CREATE INDEX "Title" ON "dbo"."EmployeeTitle"("Title")
GO



CREATE TABLE Employee
(EmployeeID INT IDENTITY(10473890,1) PRIMARY KEY CLUSTERED,
 TitleID INT FOREIGN KEY REFERENCES EmployeeTitle(TitleID),
 FirstName NVARCHAR(30),
 LastName NVARCHAR(30),
 BirthDate DATETIME,
 DateHired DATETIME)

GO
 CREATE INDEX "FirstName" ON "dbo"."Employee"("FirstName")
GO
 CREATE INDEX "LastName" ON "dbo"."Employee"("LastName")
GO



CREATE TABLE EmployeeAddress 
(AddressID INT IDENTITY(88890,1) PRIMARY KEY CLUSTERED,
 EmployeeID INT FOREIGN KEY REFERENCES Employee(EmployeeID), 
 StreetAddress NVARCHAR(30),
 City NVARCHAR(30),
 Region NVARCHAR(30),
 PostalCode INT,
 Country NVARCHAR(30))
GO
 CREATE  INDEX "City" ON "dbo"."EmployeeAddress"("City")
GO
 CREATE  INDEX "PostalCode" ON "dbo"."EmployeeAddress"("PostalCode")
GO
 CREATE  INDEX "Region" ON "dbo"."EmployeeAddress"("Region")
GO




CREATE TABLE Transactions
(TransactionID INT IDENTITY(1111,1) PRIMARY KEY CLUSTERED,
 Name NVARCHAR(30),
 CustomerID INT FOREIGN KEY REFERENCES Customer(CustomerID),
 BookingID INT FOREIGN KEY REFERENCES Booking(BookingID),
 EmployeeID INT FOREIGN KEY REFERENCES Employee(EmployeeID))
GO
 CREATE  INDEX "TransactionID" ON "dbo"."Transactions"("TransactionID")
GO



CREATE TABLE TransactionHistory
(TransactionHistoryID INT IDENTITY(3000,1) PRIMARY KEY CLUSTERED,
 TransactionID INT FOREIGN KEY REFERENCES Transactions(TransactionID),
 TransactionDate DATETIME,
 Price MONEY)
GO
 CREATE INDEX "TransactionHistoryID" ON "dbo"."TransactionHistory"("TransactionHistoryID")
GO
 CREATE INDEX "Price" ON "dbo"."TransactionHistory"("Price")
GO
 

CREATE TABLE Room
(RoomID INT IDENTITY(300,1) PRIMARY KEY CLUSTERED,
 Description NVARCHAR(50),
 Price MONEY)
GO
 CREATE INDEX "RoomID" ON "dbo"."Room"("RoomID")
GO
 CREATE INDEX "Price" ON "dbo"."Room"("Price")
GO
 


CREATE TABLE HotelService
(HotelServiceID INT IDENTITY(1232,1) PRIMARY KEY CLUSTERED,
 ServiceDescription NVARCHAR(50),
 Price MONEY)

GO
 CREATE INDEX "HotelServiceID" ON "dbo"."HotelService"("HotelServiceID")
GO
 CREATE INDEX "ServiceDescription" ON "dbo"."HotelService"("ServiceDescription")
GO
 CREATE INDEX "Price" ON "dbo"."HotelService"("Price")
GO


CREATE TABLE RoomReservation
(BookingID INT FOREIGN KEY REFERENCES Booking(BookingID),
 RoomID INT FOREIGN KEY REFERENCES Room(RoomID),
 HotelServiceID INT FOREIGN KEY REFERENCES HotelService(HotelServiceID))

 

------INSERTIONS--------

--Customer insertion

INSERT INTO Customer(FirstName,LastName,Phone)
VALUES 
	('Samir','Handanovic','073 873 4340'),
	('Milan','Skriniar','073 381 9374'),
	('Allesandro','Bastoni','060 987 6453'),
	('Stefan','de Vrij','082 654 4567'),
	('Federico','Dimarco ','083 899 6547'),
	('Aleksandar','Kolarov','071 346 7653'),
	('Matteo','Darmian','062 876 3927'),
	('Danilo','D Ambrosio','010 836 5222'),
	('Joaquín','Correa','071 324 7890'),
	('Marcelo','Brozovic','072 094 0998'),
	('Felipe','Caicedo','063 098 6665'),
	('Nicolò','Barella','071 973 1009'),
	('Alexis','Sánchez','076 778 9036'),
	('Hakan','Calhanoglu','073 444 5678'),
	('Edin','Dzeko','061 974 6729'),
	('Ivan','Perisic','010 888 0281'),
	('Lautaro','Martínez','081 884 7523') 





--CustomerAddress Insertion

INSERT INTO CustomerAddress(StreetAddress, City, Region, PostalCode, Country)
VALUES
		('Via Castelfidardo 66','Bonifati','Consenza',8702,'Italy'),
		('Ctra. de Siles 75','Sarria','Lugo',2760,'Spain'),
		('Messedamm 48','Halle','Sachsen-Anhalt',0605,'Germany'),
		('Uruguay 217','Moron','Buenos Aires',NULL,'Argentina'),
		('Via Loreto 97','Monte San Pietrangeli','Ascoli Piceno',6301,'Italy'),
		('Rau Doze 1692','Sumare','Sao Paulo',1317,'Brazil'),
		('Schmarjesrasse 11','Baruth','Brandenburg',1583,'Germany'),
		('Kandlerova 10','Pula','Pula',5210,'Croatia'),
		('M. Gupca 8','Valpovo','Valpovo',0316,'Croatia'),
		('Strandone Antonio 89','Fabro Scalo','Termi',0501,'Italy'),
		('Rioja 236','Resistencia','Chaco', NULL,'Argentina'),
		('Via Nicolai 136','Termine','Belluno',3201,'Italy'),
		('Alcon Molina 88','Berrioplano','Navarre',3119,'Spain'),
		('Mduliceva 14','Zagreb','Zagreb',1000,'Croatia'),
		('Ziegelstr. 50','Neureichenau','Freistaat Bayern',9408,'Germany'),
		('Via Loreto 25','Monte Vidon','Ascoli Piceno',6302,'Italy'),
		('Vesergade 8','Kobenhavn V','Sjaelland',1788,'Denmark')
		

DECLARE @cusIDmin INT;
DECLARE @cusIDmax INT;
DECLARE @cusAID INT;

SELECT @cusIDmin= MIN(CustomerID), @cusIDmax= MAX(CustomerID)
FROM Customer
SELECT @cusAID = MIN(AddressID) FROM CustomerAddress

WHILE(@cusIDmin<=@cusIDmax)
	BEGIN
		
		UPDATE CustomerAddress
		SET CustomerID=((SELECT CustomerID FROM Customer WHERE CustomerID = @cusIDmin))
		WHERE AddressID = @cusAID;
	
		SET @cusIDmin = @cusIDmin +1;
		SET @cusAID = @cusAID +1;
	END



--Hotel table insertion

INSERT INTO Hotel(HotelName, StarRating, Phone)
VALUES ('Dradcula',6,'010 329 2880'),
	   ('Mavis',4,'010 346 7839'),
	   ('Van Helsing',5,'010 567 8390'),
	   ('Frankenstein',6,'010 589 6270')




--HotelAddress table insertion

INSERT INTO HotelAddress(StreetAddress, City, Region, PostalCode, Country)
VALUES('101 Bodenstein St', 'Alberton','Gauteng',1481,'South Africa'),
	  ('96 Brand St', 'Rouxville', 'Free State', 9958, 'South Africa'),
	  ('767 Robertson Ave', 'Mokopane', 'Limpopo', 0602, 'South Africa'),
	  ('1142 Gleemoor Rd', 'Petrusville', 'Northern Cape',8770, 'South Africa')

DECLARE @HotIDmin INT;
DECLARE @HotIDmax INT;
DECLARE @HotAID INT;

SELECT @HotIDmin= MIN(HotelID), @HotIDmax= MAX(HotelID)
FROM Hotel
SELECT @HotAID = MIN(AddressID) FROM HotelAddress

WHILE(@HotIDmin<=@HotIDmax)
	BEGIN
		
		UPDATE HotelAddress
		SET HotelID=((SELECT HotelID FROM Hotel WHERE HotelID = @HotIDmin))
		WHERE AddressID = @HotAID;
	
		SET @HotIDmin = @HotIDmin +1;
		SET @HotAID = @HotAID +1;
	END





--Booking table insertion

INSERT INTO Booking(HotelID,CheckinDate, CheckoutDate,TotalDue)
VALUES
	(3,'2021-01-06','2022-02-23',60380.72),
	(1,'2021-01-10','2021-01-15',10289.80),
	(3,'2021-04-04','2021-05-07',62980.00),
	(1,'2021-05-18','2021-06-01',48908.23),
	(2,'2021-07-16','2021-07-17',3100.50),
	(3,'2021-11-06','2022-12-05',70850.46),
	(2,'2021-11-06','2021-11-17',23830.33),
	(2,'2021-11-06','2021-11-24',25559.99),
	(2,'2021-11-06','2021-11-17',29478.10),
	(1,'2021-12-14','2021-12-21',12900),
	(3,'2021-12-14','2022-01-14',69200.66),
	(2,'2021-12-30','2021-12-31',3000),
	(1,'2021-12-30','2022-01-07',56209.28),
	(4,'2022-01-01','2022-01-13',29780.33),
	(2,'2022-01-26','2022-02-03',18900.99),
	(1,'2022-02-22','2021-03-01',18987.66),
	(1,'2022-02-22','2021-02-27',11981.11),
	(4,'2022-02-23','2022-02-25',6900.80),
	(3,'2022-03-10', NULL, NULL),
	(2,'2022-03-10', NULL, NULL),
	(3,'2022-03-11', NULL, NULL),
	(1,'2022-03-14', NULL, NULL)






--EmployeeTitle Table insertion

INSERT INTO EmployeeTitle(Title)
VALUES
	('Hotel Manager'),
	('Accounant'),
	('Database Manager'),
	('Marketing Manager'),
	('Head of Security'),
	('Clerk'),
	('Receptionist'),
	('Waiter'),
	('Security Gaurd'),
	('Stocker'),
	('Janitor')







--Employee Table insertion

INSERT INTO Employee(TitleID, FirstName, LastName, BirthDate, DateHired)
VALUES
	(3,'Conor', 'Coady', '1983-02-02', '2020-11-23'),
	(8,'Max', 'Killman', '1980-06-23', '2021-03-02'),
	(7,'Courtney', 'Cox', '1993-07-07', '2021-03-02'),
	(1, 'Raul', 'Jimenez', '1975-04-14', '2020-05-17'),
	(2, 'Jose', 'Sa', '1988-01-05', '2020-11-01'),
	(11, 'Willy', 'Boly', '1978-11-17', '2021-02-22'),
	(4, 'Rachel', 'Austin', '1983-07-11', '2020-12-20'),
	(5, 'Daniel', 'Podence', '1979-12-03', '2020-09-22'),
	(6, 'Kate', 'Walkman', '1980-12-15', '2020-11-17'),
	(7, 'Mia', 'Chan', '1984-02-17', '2020-12-02'),
	(2, 'Lerato', 'Mabitsela', '1990-09-09', '2021-05-04'),
	(7, 'Mike', 'Angelo', '1989-02-19', '2020-12-16'),
	(9, 'Joao', 'Moutinho', '1989-07-05', '2020-12-28'),
	(10, 'Mpho', 'Lamola', '1977-09-11', '2020-12-21'),
	(7, 'Phillia', 'Hands', '1989-01-07', '2020-11-27'),
	(9, 'Jake', 'Paul', '1978-07-21', '2020-12-02'),
	(9, 'Bernado', 'Silva', '1988-08-25', '2021-03-02'),
	(6, 'Jamie', 'Maddison', '1980-11-01', '2020-12-20'),
	(9, 'Eren', 'Yager', '1990-12-27', '2020-1-20')






--EmployeeAddress insertion

INSERT INTO EmployeeAddress(StreetAddress, City, Region, PostalCode, Country)
VALUES
	('6 Wit Rd', 'Bryanston', 'Gauteng', 2056, 'South Africa'),
	('434 Wit Rd', 'Johannesburg', 'Gauteng', 2018, 'South Africa'),
	('1404 Plane St', 'Idutywa', 'Eastern Cape', 5004, 'South Africa'),
	('942 Heuvel St', 'Phuthaditjhaba', 'Free State', 9868, 'South Africa'),
	('1370 Gleemor Rd', 'Pomfret', 'North West', 8617, 'South Africa'),
	('533 Market St', 'Johannesburg', 'Gauteng', 2141, 'South Africa'),
	('1172 Plane St', 'Engcobo', 'Eastern Cape', 5050, 'South Africa'),
	('2418 Gemsbo St', 'Juno', 'Limpopo', 0758, 'South Africa'),
	('300 Robertson Ave', 'Groblersdal','Mpumalanga', 0491, 'South Africa'),
	('1320 Langley St', 'Mosselbaai','Western Cape', 6506, 'South Africa'),
	('617 North Street', 'Newcastle', 'KwaZulu-Natal', 2944, 'South Africa'),
	('479 Langley St', 'Knysna', 'Western Cape', 6571,'South Africa'),
	('1572 Barlow Street', 'Mokopane', 'Limpopo', 0634, 'South Africa'),
	('505 Loop St', 'Darling', 'Western Cape', 7345, 'South Africa'),
	('1120 Bodenstein St', 'Boksburg', 'Gauteng', 1482, 'South Africa'),
	('1868 Crown St', 'Potchefstroom', 'North West', 2529, 'South Africa'),
	('2424 Fox St', 'Leeudoringstad', 'North West', 2640, 'South Africa'),
	('721 Main Rd', 'Mandeni', 'KwaZulu-Natal', 4492, 'South Africa'),
	('861 Ireland St', 'Graskop', 'Mpumalanga', 1271, 'South Africa')



DECLARE @empIDmin INT;
DECLARE @empIDmax INT;
DECLARE @empAID INT;

SELECT @empIDmin= MIN(EmployeeID), @empIDmax= MAX(EmployeeID)
FROM Employee
SELECT @empAID = MIN(AddressID) FROM EmployeeAddress

WHILE(@empIDmin<=@empIDmax)
	BEGIN
		
		UPDATE EmployeeAddress
		SET EmployeeID=((SELECT EmployeeID FROM Employee WHERE EmployeeID = @empIDmin))
		WHERE AddressID = @empAID;
	
		SET @empIDmin = @empIDmin +1;
		SET @empAID = @empAID +1;
	END







--Transactions Insertion

INSERT INTO Transactions(Name, CustomerID, BookingID, EmployeeID)
VALUES
		('External Transaction',2451570, 23457,10473890),
		('Internal Transaction',2451584, 23470,10473904),
		('External Transaction',2451577,23463,10473897),
		('Cash Transaction', 2451575,23461,10473895),
		('Credit Transaction',2451579,23465,10473899),
		('Internal Transaction',2451576,23462,10473896),
		('Cash Transaction',2451580,23466,10473900),
		('External Transaction',2451582,23468,10473902),
		('Internal Transaction',2451583,23469,10473903),
		('Cash Transaction',2451571,23458,10473891),
		('Cash Transaction',2451574,23460,10473894),
		('Credit Transaction',2451586,23472,10473906)





--TransactionHistory Isertion

INSERT INTO TransactionHistory(TransactionDate,Price)
VALUES
	('2021-03-15', 45300.24),
	('2021-07-14', 322400.00),
	('2021-03-04', 5350.90),
	('2021-12-25', 7500.50),
	('2021-04-23', 4340.00),
	('2021-08-08', 20850.50),
	('2021-09-16', 23242.34),
	('2021-07-02', 78589.90),
	('2021-04-16', 345320.30),
	('2021-10-13', 789609.90),
	('2021-04-22', 49392.84),
	('2021-06-09', 2901.39)

DECLARE @transIDmin INT;
DECLARE @transIDmax INT;
DECLARE @transAID INT;

SELECT @transIDmin= MIN(TransactionID), @transIDmax= MAX(TransactionID)
FROM Transactions
SELECT @transAID = MIN(TransactionHistoryID) FROM TransactionHistory
H
WHILE(@transIDmin<= @transIDmax)
	BEGIN
		
		UPDATE TransactionHistory
		SET TransactionID=((SELECT TransactionID FROM Transactions WHERE TransactionID = @transIDmin))
		WHERE TransactionHistoryID = @transAID;
	
		SET @transIDmin = @transIDmin +1;
		SET @transAID = @transAID +1;
	END




--Room insertion
INSERT INTO Room(Description, Price)
VALUES 
	('Two bedrooms, bathroom, kitchen, next to pool', 2880),
	('One bedroom, bathroom, kitchen, next to pool', 2750),
	('Two bedrooms, bathroom, kitchen', 2800),
	('One bedroom, bathroom, kitchen', 2700)




--HotelService insertion
INSERT INTO HotelService(ServiceDescription, Price)
VALUES
	('Massages', 500),
	('Shoeshine', 60),
	('Ironing', 100),
	('Laudry', 400),
	('Flower arrangement', 60),
	('Wi-Fi', 450),
	('Food delivery', 30)



--Trigger that informs which employee has a birth day today 
use HotelTranselveinia --DEPENDS ON THE DATABASE YOU CREATED
go
CREATE TRIGGER EmpBirth
ON Employee
for INSERT, UPDATE, DELETE
AS
BEGIN
DEclare @name nvarchar(30)
Declare @surname nvarchar(30)
Declare @month datetime
Declare @day datetime
 set @name= (select FirstName from Employee)
 set @surname= (select LastName from Employee)
 set @month= (Select MONTH(BirthDate) from Employee)
 set @day= (Select day(BirthDate) from Employee)

if MONTH(GETDATE())=@month and day(getdate())=@day
Begin
	PRINT 'Happy birth Day '+@name + '' +@surname
END
	ELSE
		PRINT 'Not your birthday'
END

--Stored procedure that inserts a new empolyee
go
CREATE PROC INS_Employee
@title int,
@FName VARCHAR(30), 
@LName VARCHAR(30), 
@DOB DATETIME,
@SAddress nvarchar(30),
@City nvarchar(30),
@Region nvarchar(30),
@PCode int, 
@Country nvarchar(30)
AS
Begin
INSERT INTO Employee(TitleID,Firstname, Lastname, BirthDate, DateHired) 
VALUES 
(@title,@FName, @LName, @DOB, GETDATE())

INSERT INTO EmployeeAddress(StreetAddress, City, Region, PostalCode,Country) 
VALUES 
(@SAddress,@City,@Region,@PCode,@Country)
End

-- This function computes additional total costs that arise 
-- if demand for rooms increase 
GO 
CREATE FUNCTION f_priceincrease
(@percent INT =10) 
RETURNS DECIMAL(16,2) 
BEGIN 
DECLARE @additional_costs DEC (14,2), 
@sum_booking dec(16,2) 
SELECT @sum_booking = sum(r.price+hs.price) FROM RoomReservation rr
inner join Room r on rr.RoomID=r.RoomID
inner join HotelService hs on rr.HotelServiceID=hs.HotelServiceID

SET @additional_costs = @sum_booking * @percent/100 
RETURN @additional_costs 
END

--Cusror showing the services avaliable at a certain hotel for a specific booking
go
DECLARE @HID int, @Service nvarchar(50), @HName nvarchar(30)
DECLARE MyCur CURSOR FOR 
(SELECT h.HotelID,hs.ServiceDescription, h.HotelName FROM  booking b 
inner join RoomReservation rr on rr.BookingID=b.BookingID
inner join Hotel h on b.HotelID=h.HotelID
inner join HotelService hs on hs.HotelServiceID=rr.BookingID
Where b.BookingID=23461)
OPEN MyCur
FETCH NEXT FROM MyCur INTO @HID , @Service, @HName 
PRINT 'Hotel id: '+ cast(@HID AS nvarchar)
Print 'Hotel Name: '+ @HName
PRINT 'Hotel Service: '
WHILE @@FETCH_STATUS = 0 
BEGIN 
Print @Service

 FETCH NEXT FROM MyCur INTO  @HID, @Service, @HName	
END
CLOSE MyCur
DEALLOCATE MyCur

--Cusror showing the Transactions made by a specific employee
go
DECLARE @CID int, @Tname nvarchar(50), @TDate Datetime, @Total money
DECLARE MyCur2 CURSOR FOR 
(SELECT c.customerID,t.name, th.transactionDate,th.price FROM Transactions t 
inner join customer c on t.CustomerID=c.CustomerID
inner join TransactionHistory th on th.TransactionID=t.TransactionID
Where t.EmployeeID=10473890)
OPEN MyCur2
FETCH NEXT FROM MyCur2 INTO @CID , @Tname, @TDate, @Total
WHILE @@FETCH_STATUS = 0 
BEGIN 
PRINT 'Customer id: '+ cast(@CID AS nvarchar)
Print 'Transation Name: '+ @Tname
PRINT 'Transaction Date: '+ cast(@TDate As nvarchar)
Print 'Amount paid: R' + Cast(@Total As nvarchar)

 FETCH NEXT FROM MyCur2 INTO  @CID , @Tname, @TDate, @Total
END
CLOSE MyCur2
DEALLOCATE MyCur2

--View displaying transactions made and year of transactions
go
CREATE VIEW vwTransactoions (CustomerID,Transaction_Name,Year,Total)
AS
SELECT DISTINCT(T.CustomerID),T.Name,(year(TH.TransactionDate)),Round(sum(TH.Price),2,1)
FROM Transactions T
INNER JOIN TransactionHistory TH On t.TransactionID=TH.TransactionID
GROUP BY (T.CustomerID), Name,YEAR(TH.TransactionDate)
