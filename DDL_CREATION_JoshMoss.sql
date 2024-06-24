USE master;
GO

-- DROP DATABASE IF EXISTS FlightStreamDB_JoshMoss;
GO

CREATE DATABASE FlightStreamDB_JoshMoss;
GO

USE FlightStreamDB_JoshMoss;
GO


-- DDL creation script start


CREATE TABLE Country(
  CountryCode VARCHAR(5) PRIMARY KEY,
  CountryName VARCHAR(30) NOT NULL
);
GO

CREATE TABLE City(
  CityCode VARCHAR(5) PRIMARY KEY,
  CountryCode VARCHAR(5) NOT NULL,
  CityName VARCHAR(30) NOT NULL
);
GO

CREATE TABLE Suburb(
  PostCode VARCHAR(10) PRIMARY KEY,
  CityCode VARCHAR(5) NOT NULL,
  SuburbName VARCHAR(30) NOT NULL
);
GO

CREATE TABLE Address (
  PostCode VARCHAR(10) NOT NULL,
  StreetName VARCHAR(30) NOT NULL,
  StreetNumber VARCHAR(30) NOT NULL
);
GO

CREATE TABLE Client (
  ClientNumber VARCHAR(10) PRIMARY KEY,
  PostCode VARCHAR(10) NOT NULL,
  StreetName VARCHAR(30) NOT NULL,
  StreetNumber VARCHAR(30) NOT NULL,
  LastName VARCHAR(30) NOT NULL,
  FirstName VARCHAR(30) NOT NULL,
  Email VARCHAR(100) UNIQUE,
  Phone VARCHAR(15) UNIQUE  
);
GO

CREATE TABLE Account (
  ClientNumber VARCHAR(10) UNIQUE NOT NULL,
  DisplayName VARCHAR(50) UNIQUE NOT NULL
);
GO

CREATE TABLE Employee (
  EmployeeID VARCHAR(10) PRIMARY KEY,
  PostCode VARCHAR(10) NOT NULL,
  StreetName VARCHAR(30) NOT NULL,
  StreetNumber VARCHAR(30) NOT NULL,
  LastName VARCHAR(30) NOT NULL,
  FirstName VARCHAR(30) NOT NULL,
  Email VARCHAR(100) UNIQUE,
  Phone VARCHAR(15) UNIQUE,
);
GO

CREATE TABLE SalesRepresentative (
  EmployeeID VARCHAR(10) PRIMARY KEY
);
GO

CREATE TABLE Administrator (
  EmployeeID VARCHAR(10) PRIMARY KEY
);
GO

CREATE TABLE ScoopMaintenanceContractor (
  EmployeeID VARCHAR(10) PRIMARY KEY
);
GO

CREATE TABLE Subscription (
  SubscriptionID VARCHAR(10) PRIMARY KEY,
  EmployeeID VARCHAR(10) NOT NULL,
  ClientNumber VARCHAR(10) NOT NULL,
  DisplayName VARCHAR(50),
  Discount DECIMAL(4,2)
);
GO

CREATE TABLE Gold (
  SubscriptionID VARCHAR(10) PRIMARY KEY,
  Price DECIMAL(4,2) NOT NULL
);
GO

CREATE TABLE Platinum (
  SubscriptionID VARCHAR(10) PRIMARY KEY,
  Price DECIMAL(4,2) NOT NULL
);
GO

CREATE TABLE SuperPlatinum (
  SubscriptionID VARCHAR(10) PRIMARY KEY,
  Price DECIMAL(4,2) NOT NULL
);
GO

CREATE TABLE "Contract" (
  ContractID VARCHAR(10) PRIMARY KEY,
  EmployeeID VARCHAR(10) NOT NULL,
  SubscriptionID VARCHAR(10),
  OrganizationName VARCHAR(30) NOT NULL
);
GO

CREATE TABLE Supplier (
  SupplierID VARCHAR(10) PRIMARY KEY,
  SupplierName VARCHAR(30) NOT NULL
);
GO

CREATE TABLE DroneComponent (
  ComponentID VARCHAR(10) PRIMARY KEY,
  ComponentName VARCHAR(30) NOT NULL,
  Quantity INT NOT NULL,
  Price DECIMAL(6,2) NOT NULL
);
GO

CREATE TABLE ComponentPurchase (
  SupplierID VARCHAR(10) NOT NULL,
  ComponentID VARCHAR(10) NOT NULL,
  EmployeeID VARCHAR(10) NOT NULL,
  "Date" DATE NOT NULL, 
  "Time" TIME(7) NOT NULL,
  TotalPrice DECIMAL(7,2) NOT NULL,
  SaleDescription VARCHAR(255)
);
GO

CREATE TABLE DataScoop (
  DataScoopID VARCHAR(10) PRIMARY KEY,
  EmployeeID VARCHAR(10) NOT NULL,
  SubscriptionID VARCHAR(10) NOT NULL,
  DroneComponentID VARCHAR(10) NOT NULL
);
GO

CREATE TABLE Maintenance(
  MaintenanceRecordID VARCHAR(10) PRIMARY KEY,
  DataScoopID VARCHAR(10) NOT NULL,
  EmployeeID VARCHAR(10) NOT NULL,
  ComponentID VARCHAR(10) NOT NULL,
  "Date" DATE NOT NULL,
  "Time" TIME(7) NOT NULL,
  "Description" VARCHAR(255)
);
GO

CREATE TABLE LiveStream (
  StreamID VARCHAR(10) PRIMARY KEY,
  DataScoopID VARCHAR(10) NOT NULL,
  SubscriptionID VARCHAR(10) NOT NULL
);
GO

CREATE TABLE "Data" (
  RecordID VARCHAR(10) PRIMARY KEY,
  DataScoopID VARCHAR(10),
  SubscriptionID VARCHAR(10),
  "Time" TIME(7) NOT NULL,
  Temperature DECIMAL(4,2) NOT NULL,
  OrganicData VARCHAR(150) NOT NULL,
  AmbientLightStrength INT NOT NULL,
  Humidity INT NOT NULL
);
GO

CREATE TABLE "Zone" (
  ZoneID VARCHAR(10) PRIMARY KEY,
  SubscriptionID VARCHAR(10),
  DataScoopID VARCHAR(10),
  Climate VARCHAR(30) NOT NULL
);
GO

CREATE TABLE "Location" (
  Longitude DECIMAL(9,6) NOT NULL,
  Latitude DECIMAL(8,6) NOT NULL,
  DataScoopID VARCHAR(10) NOT NULL,
  ZoneID VARCHAR(10)
);
GO

-- ALTER TABLE CONSTRAINTS

ALTER TABLE City
ADD FOREIGN KEY(CountryCode) REFERENCES Country(CountryCode);
GO

ALTER TABLE Suburb
ADD FOREIGN KEY(CityCode) REFERENCES City(CityCode);
GO

ALTER TABLE Address
ADD FOREIGN KEY (PostCode) REFERENCES Suburb(PostCode);
GO
ALTER TABLE Address
ADD CONSTRAINT PK_Address PRIMARY KEY (PostCode, streetName, StreetNumber);
GO

ALTER TABLE Client
ADD CONSTRAINT FK_ClientAddress FOREIGN KEY (PostCode, StreetName, StreetNumber) REFERENCES Address(PostCode, StreetName, StreetNumber);
GO

ALTER TABLE Account
ADD CONSTRAINT FK_ClientAccount FOREIGN KEY (ClientNumber) REFERENCES Client(ClientNumber);
GO
ALTER TABLE Account
ADD CONSTRAINT PK_Account PRIMARY KEY (ClientNumber, DisplayName);
GO

ALTER TABLE Employee
ADD CONSTRAINT FK_EmployeeAddress FOREIGN KEY (PostCode, StreetName, StreetNumber) REFERENCES Address(PostCode, StreetName, StreetNumber);
GO

ALTER TABLE SalesRepresentative
ADD CONSTRAINT FK_SalesRep FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID);
GO

ALTER TABLE Administrator
ADD CONSTRAINT FK_Administrator FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID);
GO

ALTER TABLE ScoopMaintenanceContractor
ADD CONSTRAINT FK_ScoopContractor FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID);
GO

ALTER TABLE Subscription
ADD CONSTRAINT FK_SubscriptionEmployee FOREIGN KEY (EmployeeID) REFERENCES SalesRepresentative(EmployeeID);
GO
ALTER TABLE Subscription
ADD CONSTRAINT FK_SubscriptionAccount FOREIGN KEY (ClientNumber, DisplayName) REFERENCES Account(ClientNumber, DisplayName);
GO

ALTER TABLE Gold
ADD CONSTRAINT FK_GoldSubscription FOREIGN KEY (SubscriptionID) REFERENCES Subscription(SubscriptionID);
GO

ALTER TABLE Platinum
ADD CONSTRAINT FK_PlatinumSubscription FOREIGN KEY (SubscriptionID) REFERENCES Gold(SubscriptionID);
GO

ALTER TABLE SuperPlatinum
ADD CONSTRAINT FK_SuperPlatinumSubscription FOREIGN KEY (SubscriptionID) REFERENCES Platinum(SubscriptionID);
GO

ALTER TABLE Contract
ADD CONSTRAINT FK_Employee FOREIGN KEY (EmployeeID) REFERENCES Administrator(EmployeeID);
GO
ALTER TABLE Contract
ADD CONSTRAINT FK_ContractSub FOREIGN KEY (SubscriptionID) REFERENCES SuperPlatinum(SubscriptionID);
GO

ALTER TABLE ComponentPurchase
ADD CONSTRAINT FK_PurchaseSupplier FOREIGN KEY (SupplierID) REFERENCES Supplier(SupplierID);
GO
ALTER TABLE ComponentPurchase
ADD CONSTRAINT FK_PurchaseComponent FOREIGN KEY (ComponentID) REFERENCES DroneComponent(ComponentID);
GO
ALTER TABLE ComponentPurchase
ADD CONSTRAINT FK_PurchaseEmployee FOREIGN KEY (EmployeeID) REFERENCES ScoopMaintenanceContractor(EmployeeID);
GO
ALTER TABLE ComponentPurchase
ADD CONSTRAINT PK_ComponentPurchase PRIMARY KEY (SupplierID, ComponentID, Date, Time);
GO

ALTER TABLE DataScoop
ADD CONSTRAINT FK_ScoopEmployee FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID);
GO
ALTER TABLE DataScoop
ADD CONSTRAINT FK_ScoopSubscription FOREIGN KEY (SubscriptionID) REFERENCES Subscription(SubscriptionID);
GO
ALTER TABLE DataScoop
ADD CONSTRAINT FK_ScoopComponent FOREIGN KEY (DroneComponentID) REFERENCES DroneComponent(ComponentID);
GO

ALTER TABLE Maintenance
ADD CONSTRAINT FK_DataScoopMaintenance FOREIGN KEY (DataScoopID) REFERENCES DataScoop(DataScoopID);
GO
ALTER TABLE Maintenance
ADD CONSTRAINT FK_MaintenanceContractor FOREIGN KEY (EmployeeID) REFERENCES ScoopMaintenanceContractor(EmployeeID);
GO
ALTER TABLE Maintenance
ADD CONSTRAINT FK_ComponentMaintenance FOREIGN KEY (ComponentID) REFERENCES DroneComponent(ComponentID);
GO

ALTER TABLE LiveStream
ADD CONSTRAINT FK_DataScoopLivestream FOREIGN KEY (DataScoopID) REFERENCES DataScoop(DataScoopID);
GO
ALTER TABLE LiveStream
ADD CONSTRAINT FK_Subscription FOREIGN KEY (SubscriptionID) REFERENCES Subscription(SubscriptionID);
GO

ALTER TABLE Data
ADD CONSTRAINT FK_DataScoopData FOREIGN KEY (DataScoopID) REFERENCES DataScoop(DataScoopID);
GO
ALTER TABLE Data
ADD CONSTRAINT FK_DataSub FOREIGN KEY (SubscriptionID) REFERENCES Platinum(SubscriptionID);
GO

ALTER TABLE Zone
ADD CONSTRAINT FK_ZoneSub FOREIGN KEY (SubscriptionID) REFERENCES SuperPlatinum(SubscriptionID);
GO
ALTER TABLE Zone
ADD CONSTRAINT FK_DataScoop FOREIGN KEY (DataScoopID) REFERENCES DataScoop(DataScoopID);
GO

ALTER TABLE Location
ADD CONSTRAINT FK_DataScoopLocation FOREIGN KEY (DataScoopID) REFERENCES DataScoop(DataScoopID);
GO
ALTER TABLE Location
ADD CONSTRAINT FK_ZoneLocation FOREIGN KEY (ZoneID) REFERENCES Zone(ZoneID);
GO
ALTER TABLE Location
ADD CONSTRAINT PK_Location PRIMARY KEY (Longitude, Latitude);
GO

-- Indexs

CREATE INDEX SubOwner
	ON Subscription (
	EmployeeID ASC,
	ClientNumber ASC
);
GO

CREATE INDEX ScoopComponent
	ON DataScoop (
	DataScoopID ASC,
	DroneComponentID ASC
);
GO

CREATE INDEX clientLocation
	ON Client (
	PostCode ASC,
	LastName ASC
);
GO

-- INSERT STATEMENTS

-- Country

INSERT INTO Country(CountryCode,CountryName) VALUES ('NO','Norway');
INSERT INTO Country(CountryCode,CountryName) VALUES ('CN','China');
INSERT INTO Country(CountryCode,CountryName) VALUES ('FR','France');
INSERT INTO Country(CountryCode,CountryName) VALUES ('RU','Russia');
INSERT INTO Country(CountryCode,CountryName) VALUES ('RS','Serbia');
INSERT INTO Country(CountryCode,CountryName) VALUES ('VN','Vietnam');
INSERT INTO Country(CountryCode,CountryName) VALUES ('CO','Colombia');
INSERT INTO Country(CountryCode,CountryName) VALUES ('AO','Angola');
INSERT INTO Country(CountryCode,CountryName) VALUES ('PH','Philippines');
INSERT INTO Country(CountryCode,CountryName) VALUES ('NG','Nigeria');
GO

-- City

INSERT INTO City(CityCode,CountryCode,CityName) VALUES ('BGM','RS','Temorlorong');
INSERT INTO City(CityCode,CountryCode,CityName) VALUES ('BXP','CN','Horred');
INSERT INTO City(CityCode,CountryCode,CityName) VALUES ('HTY','NO','Wa’eryi');
INSERT INTO City(CityCode,CountryCode,CityName) VALUES ('TOL','NO','Nioro');
INSERT INTO City(CityCode,CountryCode,CityName) VALUES ('BAL','CN','Neópolis');
INSERT INTO City(CityCode,CountryCode,CityName) VALUES ('PFC','AO','Kuantian');
INSERT INTO City(CityCode,CountryCode,CityName) VALUES ('BQB','PH','Chengji');
INSERT INTO City(CityCode,CountryCode,CityName) VALUES ('LNB','NG','Tsovazard');
INSERT INTO City(CityCode,CountryCode,CityName) VALUES ('DQA','CN','Jianggu');
INSERT INTO City(CityCode,CountryCode,CityName) VALUES ('CYT','CN','Beaune');
INSERT INTO City(CityCode,CountryCode,CityName) VALUES ('TOP','PH','Mpophomeni');
INSERT INTO City(CityCode,CountryCode,CityName) VALUES ('ZIX','RS','Aguelmous');
INSERT INTO City(CityCode,CountryCode,CityName) VALUES ('MHO','CN','Budapest');
INSERT INTO City(CityCode,CountryCode,CityName) VALUES ('KSJ','FR','Thành Ph? Ph? Lý');
INSERT INTO City(CityCode,CountryCode,CityName) VALUES ('NRS','PH','København');
INSERT INTO City(CityCode,CountryCode,CityName) VALUES ('CYL','CN','Huayllabamba');
INSERT INTO City(CityCode,CountryCode,CityName) VALUES ('NAN','AO','Montargis');
INSERT INTO City(CityCode,CountryCode,CityName) VALUES ('ORX','RU','Baoshi');
INSERT INTO City(CityCode,CountryCode,CityName) VALUES ('RBU','NO','Lanxi');
INSERT INTO City(CityCode,CountryCode,CityName) VALUES ('UNA','RS','Yur’yev-Pol’skiy');
INSERT INTO City(CityCode,CountryCode,CityName) VALUES ('LYU','PH','Owerri');
INSERT INTO City(CityCode,CountryCode,CityName) VALUES ('ABW','VN','Wageningen');
INSERT INTO City(CityCode,CountryCode,CityName) VALUES ('ENU','CN','Berlin');
INSERT INTO City(CityCode,CountryCode,CityName) VALUES ('AMB','FR','Payao');
INSERT INTO City(CityCode,CountryCode,CityName) VALUES ('SOX','CN','Till');
INSERT INTO City(CityCode,CountryCode,CityName) VALUES ('XCH','RU','Gayam');
INSERT INTO City(CityCode,CountryCode,CityName) VALUES ('MTF','RS','Casal de Cambra');
INSERT INTO City(CityCode,CountryCode,CityName) VALUES ('YGM','CN','Sa Pá');
INSERT INTO City(CityCode,CountryCode,CityName) VALUES ('DSG','NO','Daxing');
INSERT INTO City(CityCode,CountryCode,CityName) VALUES ('JBQ','CO','Bordeaux');
GO

-- Suburb

INSERT INTO Suburb(PostCode,CityCode,SuburbName) VALUES ('5534158425','NRS','Texas');
INSERT INTO Suburb(PostCode,CityCode,SuburbName) VALUES ('6402749664','HTY','Indiana');
INSERT INTO Suburb(PostCode,CityCode,SuburbName) VALUES ('8800073034','LNB','Minnesota');
INSERT INTO Suburb(PostCode,CityCode,SuburbName) VALUES ('2785608704','KSJ','California');
INSERT INTO Suburb(PostCode,CityCode,SuburbName) VALUES ('5301869744','UNA','District of Columbia');
INSERT INTO Suburb(PostCode,CityCode,SuburbName) VALUES ('6783069192','NAN','Indiana');
INSERT INTO Suburb(PostCode,CityCode,SuburbName) VALUES ('2823442219','ENU','Idaho');
INSERT INTO Suburb(PostCode,CityCode,SuburbName) VALUES ('7116429018','BGM','New York');
INSERT INTO Suburb(PostCode,CityCode,SuburbName) VALUES ('0192535501','ABW','Georgia');
INSERT INTO Suburb(PostCode,CityCode,SuburbName) VALUES ('9317528112','ZIX','Delaware');
INSERT INTO Suburb(PostCode,CityCode,SuburbName) VALUES ('2887845764','LYU','Alabama');
INSERT INTO Suburb(PostCode,CityCode,SuburbName) VALUES ('9629104067','MHO','Iowa');
INSERT INTO Suburb(PostCode,CityCode,SuburbName) VALUES ('7601145778','NRS','Connecticut');
INSERT INTO Suburb(PostCode,CityCode,SuburbName) VALUES ('4292659745','AMB','Washington');
INSERT INTO Suburb(PostCode,CityCode,SuburbName) VALUES ('5757311061','LYU','California');
INSERT INTO Suburb(PostCode,CityCode,SuburbName) VALUES ('5325421875','NRS','Texas');
INSERT INTO Suburb(PostCode,CityCode,SuburbName) VALUES ('1509872604','AMB','Louisiana');
INSERT INTO Suburb(PostCode,CityCode,SuburbName) VALUES ('4057943277','PFC','Washington');
INSERT INTO Suburb(PostCode,CityCode,SuburbName) VALUES ('2781850659','MHO','Illinois');
INSERT INTO Suburb(PostCode,CityCode,SuburbName) VALUES ('4781307647','PFC','Georgia');
INSERT INTO Suburb(PostCode,CityCode,SuburbName) VALUES ('2224133375','BGM','North Carolina');
INSERT INTO Suburb(PostCode,CityCode,SuburbName) VALUES ('8413486092','MTF','District of Columbia');
INSERT INTO Suburb(PostCode,CityCode,SuburbName) VALUES ('1441205853','BXP','Washington');
INSERT INTO Suburb(PostCode,CityCode,SuburbName) VALUES ('8597782706','BGM','Pennsylvania');
INSERT INTO Suburb(PostCode,CityCode,SuburbName) VALUES ('5424515061','NAN','Texas');
INSERT INTO Suburb(PostCode,CityCode,SuburbName) VALUES ('7815733522','BGM','Florida');
INSERT INTO Suburb(PostCode,CityCode,SuburbName) VALUES ('5499790515','XCH','Illinois');
INSERT INTO Suburb(PostCode,CityCode,SuburbName) VALUES ('8716446682','AMB','District of Columbia');
INSERT INTO Suburb(PostCode,CityCode,SuburbName) VALUES ('0846899477','LYU','Georgia');
INSERT INTO Suburb(PostCode,CityCode,SuburbName) VALUES ('0714670812','BQB','Florida');
INSERT INTO Suburb(PostCode,CityCode,SuburbName) VALUES ('0688077331','ABW','California');
INSERT INTO Suburb(PostCode,CityCode,SuburbName) VALUES ('0359244491','UNA','Maryland');
INSERT INTO Suburb(PostCode,CityCode,SuburbName) VALUES ('8449112559','DQA','Michigan');
INSERT INTO Suburb(PostCode,CityCode,SuburbName) VALUES ('7432349274','BQB','Washington');
INSERT INTO Suburb(PostCode,CityCode,SuburbName) VALUES ('9853039680','AMB','Virginia');
INSERT INTO Suburb(PostCode,CityCode,SuburbName) VALUES ('5982810088','TOL','Florida');
INSERT INTO Suburb(PostCode,CityCode,SuburbName) VALUES ('3208759401','ABW','District of Columbia');
INSERT INTO Suburb(PostCode,CityCode,SuburbName) VALUES ('7661283182','ZIX','California');
INSERT INTO Suburb(PostCode,CityCode,SuburbName) VALUES ('2261571550','JBQ','Colorado');
INSERT INTO Suburb(PostCode,CityCode,SuburbName) VALUES ('0728611465','PFC','California');
INSERT INTO Suburb(PostCode,CityCode,SuburbName) VALUES ('1266871764','CYT','Indiana');
INSERT INTO Suburb(PostCode,CityCode,SuburbName) VALUES ('8567843685','CYL','Florida');
INSERT INTO Suburb(PostCode,CityCode,SuburbName) VALUES ('0671407570','BGM','Michigan');
INSERT INTO Suburb(PostCode,CityCode,SuburbName) VALUES ('5213104266','YGM','Texas');
INSERT INTO Suburb(PostCode,CityCode,SuburbName) VALUES ('9231089935','LNB','Virginia');
INSERT INTO Suburb(PostCode,CityCode,SuburbName) VALUES ('8700382620','BAL','Georgia');
INSERT INTO Suburb(PostCode,CityCode,SuburbName) VALUES ('4791408128','KSJ','Florida');
INSERT INTO Suburb(PostCode,CityCode,SuburbName) VALUES ('1849521964','SOX','Florida');
INSERT INTO Suburb(PostCode,CityCode,SuburbName) VALUES ('4136002912','ORX','Kentucky');
INSERT INTO Suburb(PostCode,CityCode,SuburbName) VALUES ('8861981305','LYU','Missouri');
GO

-- Address

INSERT INTO Address(PostCode,StreetName,StreetNumber) VALUES ('0714670812','Oneill','7');
INSERT INTO Address(PostCode,StreetName,StreetNumber) VALUES ('2887845764','Marquette','6');
INSERT INTO Address(PostCode,StreetName,StreetNumber) VALUES ('6783069192','Dapin','87619');
INSERT INTO Address(PostCode,StreetName,StreetNumber) VALUES ('4791408128','Jana','515');
INSERT INTO Address(PostCode,StreetName,StreetNumber) VALUES ('8861981305','Buhler','9');
INSERT INTO Address(PostCode,StreetName,StreetNumber) VALUES ('2823442219','Wayridge','3');
INSERT INTO Address(PostCode,StreetName,StreetNumber) VALUES ('6402749664','Norway Maple','04333');
INSERT INTO Address(PostCode,StreetName,StreetNumber) VALUES ('5534158425','Hazelcrest','831');
INSERT INTO Address(PostCode,StreetName,StreetNumber) VALUES ('2785608704','Blackbird','3828');
INSERT INTO Address(PostCode,StreetName,StreetNumber) VALUES ('7661283182','Morningstar','9702');
INSERT INTO Address(PostCode,StreetName,StreetNumber) VALUES ('5534158425','Oriole','45');
INSERT INTO Address(PostCode,StreetName,StreetNumber) VALUES ('3208759401','Pine View','41');
INSERT INTO Address(PostCode,StreetName,StreetNumber) VALUES ('5213104266','Canary','965');
INSERT INTO Address(PostCode,StreetName,StreetNumber) VALUES ('2887845764','Hansons','86');
INSERT INTO Address(PostCode,StreetName,StreetNumber) VALUES ('1509872604','Thompson','6');
INSERT INTO Address(PostCode,StreetName,StreetNumber) VALUES ('8861981305','Eastlawn','74424');
INSERT INTO Address(PostCode,StreetName,StreetNumber) VALUES ('0728611465','Cascade','4');
INSERT INTO Address(PostCode,StreetName,StreetNumber) VALUES ('8861981305','Maple','31');
INSERT INTO Address(PostCode,StreetName,StreetNumber) VALUES ('3208759401','Veith','5502');
INSERT INTO Address(PostCode,StreetName,StreetNumber) VALUES ('4791408128','Merrick','381');
INSERT INTO Address(PostCode,StreetName,StreetNumber) VALUES ('1849521964','Larry','04');
INSERT INTO Address(PostCode,StreetName,StreetNumber) VALUES ('9853039680','Spaight','5748');
INSERT INTO Address(PostCode,StreetName,StreetNumber) VALUES ('8800073034','Kings','33');
INSERT INTO Address(PostCode,StreetName,StreetNumber) VALUES ('8413486092','Dottie','9');
INSERT INTO Address(PostCode,StreetName,StreetNumber) VALUES ('1509872604','Troy','11');
INSERT INTO Address(PostCode,StreetName,StreetNumber) VALUES ('9629104067','Hintze','866');
INSERT INTO Address(PostCode,StreetName,StreetNumber) VALUES ('2785608704','Alpine','1342');
INSERT INTO Address(PostCode,StreetName,StreetNumber) VALUES ('9317528112','Bultman','7540');
INSERT INTO Address(PostCode,StreetName,StreetNumber) VALUES ('0671407570','Gulseth','78834');
INSERT INTO Address(PostCode,StreetName,StreetNumber) VALUES ('1266871764','Pond','1195');
INSERT INTO Address(PostCode,StreetName,StreetNumber) VALUES ('7116429018','Eastlawn','26072');
INSERT INTO Address(PostCode,StreetName,StreetNumber) VALUES ('5499790515','Memorial','4');
INSERT INTO Address(PostCode,StreetName,StreetNumber) VALUES ('0359244491','Ridgeway','8');
INSERT INTO Address(PostCode,StreetName,StreetNumber) VALUES ('0192535501','Park Meadow','0540');
INSERT INTO Address(PostCode,StreetName,StreetNumber) VALUES ('0671407570','4th','80');
INSERT INTO Address(PostCode,StreetName,StreetNumber) VALUES ('9317528112','Claremont','06');
INSERT INTO Address(PostCode,StreetName,StreetNumber) VALUES ('1441205853','Hazelcrest','53');
INSERT INTO Address(PostCode,StreetName,StreetNumber) VALUES ('5982810088','Monterey','55');
INSERT INTO Address(PostCode,StreetName,StreetNumber) VALUES ('2224133375','Anderson','834');
INSERT INTO Address(PostCode,StreetName,StreetNumber) VALUES ('5534158425','Graceland','66');
INSERT INTO Address(PostCode,StreetName,StreetNumber) VALUES ('4781307647','Division','2300');
INSERT INTO Address(PostCode,StreetName,StreetNumber) VALUES ('5325421875','Mitchell','1159');
INSERT INTO Address(PostCode,StreetName,StreetNumber) VALUES ('7661283182','Di Loreto','9641');
INSERT INTO Address(PostCode,StreetName,StreetNumber) VALUES ('0359244491','Basil','60655');
INSERT INTO Address(PostCode,StreetName,StreetNumber) VALUES ('6783069192','Kings','20077');
INSERT INTO Address(PostCode,StreetName,StreetNumber) VALUES ('3208759401','Muir','5418');
INSERT INTO Address(PostCode,StreetName,StreetNumber) VALUES ('0192535501','Darwin','744');
INSERT INTO Address(PostCode,StreetName,StreetNumber) VALUES ('2224133375','Randy','56');
INSERT INTO Address(PostCode,StreetName,StreetNumber) VALUES ('3208759401','Jenifer','7671');
INSERT INTO Address(PostCode,StreetName,StreetNumber) VALUES ('1266871764','Debs','02');
INSERT INTO Address(PostCode,StreetName,StreetNumber) VALUES ('9853039680','6th','748');
INSERT INTO Address(PostCode,StreetName,StreetNumber) VALUES ('4292659745','Buhler','3');
INSERT INTO Address(PostCode,StreetName,StreetNumber) VALUES ('8861981305','Sundown','1270');
INSERT INTO Address(PostCode,StreetName,StreetNumber) VALUES ('2261571550','Ridgeway','3225');
INSERT INTO Address(PostCode,StreetName,StreetNumber) VALUES ('7116429018','Linden','5');
INSERT INTO Address(PostCode,StreetName,StreetNumber) VALUES ('2823442219','Gulseth','0');
INSERT INTO Address(PostCode,StreetName,StreetNumber) VALUES ('2224133375','Merchant','492');
INSERT INTO Address(PostCode,StreetName,StreetNumber) VALUES ('4057943277','Warbler','43303');
INSERT INTO Address(PostCode,StreetName,StreetNumber) VALUES ('4781307647','Shasta','9137');
INSERT INTO Address(PostCode,StreetName,StreetNumber) VALUES ('4292659745','Warbler','198');
INSERT INTO Address(PostCode,StreetName,StreetNumber) VALUES ('8449112559','Alpine','4');
INSERT INTO Address(PostCode,StreetName,StreetNumber) VALUES ('1509872604','Jenna','2848');
INSERT INTO Address(PostCode,StreetName,StreetNumber) VALUES ('1509872604','Paget','068');
INSERT INTO Address(PostCode,StreetName,StreetNumber) VALUES ('0728611465','Warrior','1516');
INSERT INTO Address(PostCode,StreetName,StreetNumber) VALUES ('6402749664','Victoria','57048');
INSERT INTO Address(PostCode,StreetName,StreetNumber) VALUES ('8449112559','Lindbergh','1258');
INSERT INTO Address(PostCode,StreetName,StreetNumber) VALUES ('1849521964','West','1');
INSERT INTO Address(PostCode,StreetName,StreetNumber) VALUES ('9231089935','Chive','7');
INSERT INTO Address(PostCode,StreetName,StreetNumber) VALUES ('4781307647','Fallview','265');
INSERT INTO Address(PostCode,StreetName,StreetNumber) VALUES ('5499790515','Bayside','343');
GO

-- Client

INSERT INTO Client(ClientNumber,PostCode,StreetName,StreetNumber,LastName,FirstName,Email,Phone) VALUES (5368476426,6783069192,'Kings',20077,'Hallet','Alden','ahallet0@huffingtonpost.com','912-817-2802');
INSERT INTO Client(ClientNumber,PostCode,StreetName,StreetNumber,LastName,FirstName,Email,Phone) VALUES (1315293889,8861981305,'Sundown',1270,'Goaley','Reginald','rgoaley1@jalbum.net','915-368-0201');
INSERT INTO Client(ClientNumber,PostCode,StreetName,StreetNumber,LastName,FirstName,Email,Phone) VALUES (8698437869,8861981305,'Maple',31,'Enrigo','Emylee','eenrigo2@va.gov','619-890-0940');
INSERT INTO Client(ClientNumber,PostCode,StreetName,StreetNumber,LastName,FirstName,Email,Phone) VALUES (3365682724,7661283182,'Morningstar',9702,'Gonsalo','Nollie','ngonsalo3@newsvine.com','393-153-3614');
INSERT INTO Client(ClientNumber,PostCode,StreetName,StreetNumber,LastName,FirstName,Email,Phone) VALUES (7967924592,5325421875,'Mitchell',1159,'Pohling','Irina','ipohling4@cloudflare.com','667-273-5106');
INSERT INTO Client(ClientNumber,PostCode,StreetName,StreetNumber,LastName,FirstName,Email,Phone) VALUES (3138623212,4292659745,'Buhler',3,'Van der Linde','Stephanie','svanderlinde5@cargocollective.com','984-565-9570');
INSERT INTO Client(ClientNumber,PostCode,StreetName,StreetNumber,LastName,FirstName,Email,Phone) VALUES (8794633452,5982810088,'Monterey',55,'Messingham','Faulkner','fmessingham6@msu.edu','324-942-9779');
INSERT INTO Client(ClientNumber,PostCode,StreetName,StreetNumber,LastName,FirstName,Email,Phone) VALUES (1818498073,1266871764,'Pond',1195,'MacLennan','Alys','amaclennan9@weather.com','931-481-1135');
INSERT INTO Client(ClientNumber,PostCode,StreetName,StreetNumber,LastName,FirstName,Email,Phone) VALUES (1790663563,3208759401,'Veith',5502,'Dzenisenka','Leupold','ldzenisenkaa@vimeo.com','669-188-7472');
INSERT INTO Client(ClientNumber,PostCode,StreetName,StreetNumber,LastName,FirstName,Email,Phone) VALUES (5908095249,4791408128,'Merrick',381,'Duignan','Aila','aduignanb@google.co.jp','924-964-7652');
INSERT INTO Client(ClientNumber,PostCode,StreetName,StreetNumber,LastName,FirstName,Email,Phone) VALUES (0718825357,7116429018,'Linden',5,'Whewill','Allix','awhewillc@unicef.org','667-664-1438');
INSERT INTO Client(ClientNumber,PostCode,StreetName,StreetNumber,LastName,FirstName,Email,Phone) VALUES (9539931584,5534158425,'Hazelcrest',831,'Yitzovitz','Ray','ryitzovitzd@dedecms.com','491-143-6875');
INSERT INTO Client(ClientNumber,PostCode,StreetName,StreetNumber,LastName,FirstName,Email,Phone) VALUES (2480401235,5499790515,'Bayside',343,'O''Feeny','Shanna','sofeenye@jiathis.com','641-911-9326');
INSERT INTO Client(ClientNumber,PostCode,StreetName,StreetNumber,LastName,FirstName,Email,Phone) VALUES (6293677250,7661283182,'Morningstar',9702,'Bissex','Meara','mbissexf@un.org','370-631-1674');
INSERT INTO Client(ClientNumber,PostCode,StreetName,StreetNumber,LastName,FirstName,Email,Phone) VALUES (9085230039,7116429018,'Eastlawn',26072,'McAulay','Gerald','gmcaulayg@usgs.gov','896-367-3460');
INSERT INTO Client(ClientNumber,PostCode,StreetName,StreetNumber,LastName,FirstName,Email,Phone) VALUES (6826871602,8449112559,'Lindbergh',1258,'Jacqueminet','Byran','bjacquemineth@reference.com','848-500-2935');
INSERT INTO Client(ClientNumber,PostCode,StreetName,StreetNumber,LastName,FirstName,Email,Phone) VALUES (2590427832,2785608704,'Alpine',1342,'Jirasek','Benedick','bjiraseki@desdev.cn','490-176-1772');
INSERT INTO Client(ClientNumber,PostCode,StreetName,StreetNumber,LastName,FirstName,Email,Phone) VALUES (1263371582,7661283182,'Di Loreto',9641,'Axell','Tammie','taxellj@a8.net','679-106-4533');
INSERT INTO Client(ClientNumber,PostCode,StreetName,StreetNumber,LastName,FirstName,Email,Phone) VALUES (9701148797,2224133375,'Anderson',834,'Duker','Liz','ldukerl@abc.net.au','713-557-1502');
INSERT INTO Client(ClientNumber,PostCode,StreetName,StreetNumber,LastName,FirstName,Email,Phone) VALUES (2330654863,7116429018,'Linden',5,'Scrowston','Hansiain','hscrowstonm@howstuffworks.com','876-421-7951');
INSERT INTO Client(ClientNumber,PostCode,StreetName,StreetNumber,LastName,FirstName,Email,Phone) VALUES (6069251970,1266871764,'Pond',1195,'Tuckett','Niccolo','ntucketto@disqus.com','878-358-1308');
INSERT INTO Client(ClientNumber,PostCode,StreetName,StreetNumber,LastName,FirstName,Email,Phone) VALUES (1120293308,3208759401,'Jenifer',7671,'Seakes','Binni','bseakesp@gnu.org','475-101-1351');
INSERT INTO Client(ClientNumber,PostCode,StreetName,StreetNumber,LastName,FirstName,Email,Phone) VALUES (4761042923,4791408128,'Merrick',381,'Heinle','Kain','kheinleq@princeton.edu','940-261-0251');
INSERT INTO Client(ClientNumber,PostCode,StreetName,StreetNumber,LastName,FirstName,Email,Phone) VALUES (2769627481,9853039680,'Spaight',5748,'Postans','Hamnet','hpostansr@flavors.me','504-507-4465');
INSERT INTO Client(ClientNumber,PostCode,StreetName,StreetNumber,LastName,FirstName,Email,Phone) VALUES (3784174744,7116429018,'Linden',5,'Fissenden','Rois','rfissendens@epa.gov','957-997-9437');
INSERT INTO Client(ClientNumber,PostCode,StreetName,StreetNumber,LastName,FirstName,Email,Phone) VALUES (6858444785,9853039680,'6th',748,'Camoletto','Emogene','ecamolettou@mac.com','548-675-8096');
INSERT INTO Client(ClientNumber,PostCode,StreetName,StreetNumber,LastName,FirstName,Email,Phone) VALUES (0395712343,2823442219,'Gulseth',0,'Jeannesson','Uta','ujeannessonv@taobao.com','470-334-9658');
INSERT INTO Client(ClientNumber,PostCode,StreetName,StreetNumber,LastName,FirstName,Email,Phone) VALUES (0049710753,1849521964,'West',1,'Braysher','Henri','hbraysherw@mediafire.com','440-106-9426');
INSERT INTO Client(ClientNumber,PostCode,StreetName,StreetNumber,LastName,FirstName,Email,Phone) VALUES (1510758526,2785608704,'Alpine',1342,'Barents','Georgianna','gbarentsx@loc.gov','962-287-2056');
INSERT INTO Client(ClientNumber,PostCode,StreetName,StreetNumber,LastName,FirstName,Email,Phone) VALUES (0645956171,2785608704,'Blackbird',3828,'Sharkey','Willette','wsharkeyy@amazon.com','394-861-8631');
INSERT INTO Client(ClientNumber,PostCode,StreetName,StreetNumber,LastName,FirstName,Email,Phone) VALUES (2566254869,8449112559,'Lindbergh',1258,'Egar','Rene','regar10@si.edu','899-472-6178');
INSERT INTO Client(ClientNumber,PostCode,StreetName,StreetNumber,LastName,FirstName,Email,Phone) VALUES (7726245433,4292659745,'Buhler',3,'Barbara','Loreen','lbarbara11@oaic.gov.au','295-610-7583');
INSERT INTO Client(ClientNumber,PostCode,StreetName,StreetNumber,LastName,FirstName,Email,Phone) VALUES (5475552797,1266871764,'Pond',1195,'Scrogges','Hussein','hscrogges13@webs.com','100-365-2456');
INSERT INTO Client(ClientNumber,PostCode,StreetName,StreetNumber,LastName,FirstName,Email,Phone) VALUES (2792542675,9853039680,'Spaight',5748,'Butler','Vic','vbutler14@shop-pro.jp','558-889-1894');
INSERT INTO Client(ClientNumber,PostCode,StreetName,StreetNumber,LastName,FirstName,Email,Phone) VALUES (7911402566,8861981305,'Buhler',9,'Yirrell','Evangelina','eyirrell16@upenn.edu','341-464-2181');
INSERT INTO Client(ClientNumber,PostCode,StreetName,StreetNumber,LastName,FirstName,Email,Phone) VALUES (6491690768,2785608704,'Blackbird',3828,'Toulamain','Kalvin','ktoulamain17@rakuten.co.jp','504-207-4652');
INSERT INTO Client(ClientNumber,PostCode,StreetName,StreetNumber,LastName,FirstName,Email,Phone) VALUES (9046389987,1509872604,'Thompson',6,'Caldow','Alanson','acaldow18@wired.com','663-428-5479');
INSERT INTO Client(ClientNumber,PostCode,StreetName,StreetNumber,LastName,FirstName,Email,Phone) VALUES (2905432586,7661283182,'Di Loreto',9641,'Pache','Bennie','bpache19@wikimedia.org','688-254-0710');
INSERT INTO Client(ClientNumber,PostCode,StreetName,StreetNumber,LastName,FirstName,Email,Phone) VALUES (0922727635,5499790515,'Bayside',343,'Buckney','Andrey','abuckney1a@ehow.com','511-372-6859');
INSERT INTO Client(ClientNumber,PostCode,StreetName,StreetNumber,LastName,FirstName,Email,Phone) VALUES (0439539803,5213104266,'Canary',965,'Kless','Jarid','jkless1b@desdev.cn','406-758-2953');
INSERT INTO Client(ClientNumber,PostCode,StreetName,StreetNumber,LastName,FirstName,Email,Phone) VALUES (1510586903,3208759401,'Veith',5502,'Vardy','Dorri','dvardy1c@japanpost.jp','628-476-2525');
INSERT INTO Client(ClientNumber,PostCode,StreetName,StreetNumber,LastName,FirstName,Email,Phone) VALUES (1523272244,5499790515,'Memorial',4,'Fairbourne','Zitella','zfairbourne1d@princeton.edu','454-243-7511');
INSERT INTO Client(ClientNumber,PostCode,StreetName,StreetNumber,LastName,FirstName,Email,Phone) VALUES (6526595480,6783069192,'Kings',20077,'Dybald','Desmond','ddybald1f@plala.or.jp','947-375-9584');
INSERT INTO Client(ClientNumber,PostCode,StreetName,StreetNumber,LastName,FirstName,Email,Phone) VALUES (4078685242,6783069192,'Dapin',87619,'Haker','Hersch','hhaker1g@illinois.edu','305-647-9689');
INSERT INTO Client(ClientNumber,PostCode,StreetName,StreetNumber,LastName,FirstName,Email,Phone) VALUES (2059565952,8800073034,'Kings',33,'Ahrend','Roxane','rahrend1i@php.net','299-662-0941');
INSERT INTO Client(ClientNumber,PostCode,StreetName,StreetNumber,LastName,FirstName,Email,Phone) VALUES (5795290173,6783069192,'Dapin',87619,'Gommowe','Petra','pgommowe1k@posterous.com','578-124-1092');
INSERT INTO Client(ClientNumber,PostCode,StreetName,StreetNumber,LastName,FirstName,Email,Phone) VALUES (8986383187,7661283182,'Di Loreto',9641,'Robiou','Avigdor','arobiou1l@weather.com','319-996-9751');
INSERT INTO Client(ClientNumber,PostCode,StreetName,StreetNumber,LastName,FirstName,Email,Phone) VALUES (6247270747,3208759401,'Veith',5502,'Wikey','Rhianon','rwikey1m@so-net.ne.jp','928-991-8485');
INSERT INTO Client(ClientNumber,PostCode,StreetName,StreetNumber,LastName,FirstName,Email,Phone) VALUES (1686632061,8413486092,'Dottie',9,'Fardell','Stavro','sfardell1n@ted.com','101-466-8145');
INSERT INTO Client(ClientNumber,PostCode,StreetName,StreetNumber,LastName,FirstName,Email,Phone) VALUES (4873768268,7116429018,'Linden',5,'Guillotin','Ab','aguillotin1o@mtv.com','222-222-9196');
INSERT INTO Client(ClientNumber,PostCode,StreetName,StreetNumber,LastName,FirstName,Email,Phone) VALUES (8811540097,3208759401,'Muir',5418,'Dumbarton','Livy','ldumbarton1p@blogtalkradio.com','854-864-3073');
INSERT INTO Client(ClientNumber,PostCode,StreetName,StreetNumber,LastName,FirstName,Email,Phone) VALUES (7575638466,3208759401,'Muir',5418,'Landman','Pablo','plandman1q@diigo.com','355-410-1239');
INSERT INTO Client(ClientNumber,PostCode,StreetName,StreetNumber,LastName,FirstName,Email,Phone) VALUES (6905639591,3208759401,'Jenifer',7671,'Mitcheson','Annmaria','amitcheson1r@china.com.cn','982-207-7768');
INSERT INTO Client(ClientNumber,PostCode,StreetName,StreetNumber,LastName,FirstName,Email,Phone) VALUES (6853922638,2823442219,'Wayridge',3,'Reuben','Rebekkah','rreuben1s@psu.edu','120-476-8673');
INSERT INTO Client(ClientNumber,PostCode,StreetName,StreetNumber,LastName,FirstName,Email,Phone) VALUES (8581058175,8800073034,'Kings',33,'Tytherton','Lila','ltytherton1t@newsvine.com','850-674-2364');
INSERT INTO Client(ClientNumber,PostCode,StreetName,StreetNumber,LastName,FirstName,Email,Phone) VALUES (4166183516,7116429018,'Linden',5,'Kemmett','Micheline','mkemmett1u@narod.ru','253-480-3811');
INSERT INTO Client(ClientNumber,PostCode,StreetName,StreetNumber,LastName,FirstName,Email,Phone) VALUES (1820145549,1849521964,'West',1,'Tribell','Conan','ctribell1v@vinaora.com','125-140-8198');
INSERT INTO Client(ClientNumber,PostCode,StreetName,StreetNumber,LastName,FirstName,Email,Phone) VALUES (7322636384,4781307647,'Fallview',265,'Daughton','Zitella','zdaughton1y@globo.com','680-945-0021');
INSERT INTO Client(ClientNumber,PostCode,StreetName,StreetNumber,LastName,FirstName,Email,Phone) VALUES (2527109616,2887845764,'Marquette',6,'Eakly','Merlina','meakly1z@tripod.com','701-616-9556');
INSERT INTO Client(ClientNumber,PostCode,StreetName,StreetNumber,LastName,FirstName,Email,Phone) VALUES (0963527304,6402749664,'Victoria',57048,'Waison','Betteann','bwaison20@blogger.com','382-712-4614');
INSERT INTO Client(ClientNumber,PostCode,StreetName,StreetNumber,LastName,FirstName,Email,Phone) VALUES (4717227379,1509872604,'Troy',11,'Lovett','Charissa','clovett21@themeforest.net','362-284-7565');
INSERT INTO Client(ClientNumber,PostCode,StreetName,StreetNumber,LastName,FirstName,Email,Phone) VALUES (1922041688,7661283182,'Di Loreto',9641,'Dabell','Lauree','ldabell22@php.net','911-812-0514');
INSERT INTO Client(ClientNumber,PostCode,StreetName,StreetNumber,LastName,FirstName,Email,Phone) VALUES (3617089178,5534158425,'Oriole',45,'Gercke','Dacia','dgercke24@dailymail.co.uk','278-188-2762');
INSERT INTO Client(ClientNumber,PostCode,StreetName,StreetNumber,LastName,FirstName,Email,Phone) VALUES (8924600117,8449112559,'Alpine',4,'Glave','Raymund','rglave25@foxnews.com','556-714-6118');
INSERT INTO Client(ClientNumber,PostCode,StreetName,StreetNumber,LastName,FirstName,Email,Phone) VALUES (0712848592,8861981305,'Eastlawn',74424,'Tarbath','Lebbie','ltarbath26@163.com','761-491-4412');
INSERT INTO Client(ClientNumber,PostCode,StreetName,StreetNumber,LastName,FirstName,Email,Phone) VALUES (8419113921,2224133375,'Anderson',834,'Keays','Cory','ckeays27@google.co.uk','333-968-6171');
GO

-- Employee 

INSERT INTO Employee(EmployeeID,PostCode,StreetName,StreetNumber,LastName,FirstName,Email,Phone) VALUES (8047506420,2224133375,'Anderson',834,'Lindenstrauss','Lynna','llindenstrauss0@sfgate.com','970-189-6133');
INSERT INTO Employee(EmployeeID,PostCode,StreetName,StreetNumber,LastName,FirstName,Email,Phone) VALUES (2046627849,8449112559,'Lindbergh',1258,'Shimmin','Mattias','mshimmin1@auda.org.au','922-183-4363');
INSERT INTO Employee(EmployeeID,PostCode,StreetName,StreetNumber,LastName,FirstName,Email,Phone) VALUES (8502920405,5499790515,'Memorial',4,'Leslie','Shanda','sleslie2@reverbnation.com','723-854-6193');
INSERT INTO Employee(EmployeeID,PostCode,StreetName,StreetNumber,LastName,FirstName,Email,Phone) VALUES (0274988607,5325421875,'Mitchell',1159,'Mordanti','Erick','emordanti3@uiuc.edu','296-124-0040');
INSERT INTO Employee(EmployeeID,PostCode,StreetName,StreetNumber,LastName,FirstName,Email,Phone) VALUES (3149785065,1849521964,'West',1,'Purkins','Elisabet','epurkins4@upenn.edu','458-297-9153');
INSERT INTO Employee(EmployeeID,PostCode,StreetName,StreetNumber,LastName,FirstName,Email,Phone) VALUES (0181966077,4791408128,'Merrick',381,'Trevorrow','Riva','rtrevorrow5@cisco.com','448-146-3798');
INSERT INTO Employee(EmployeeID,PostCode,StreetName,StreetNumber,LastName,FirstName,Email,Phone) VALUES (7774743820,6402749664,'Victoria',57048,'Billie','Dawn','dbillie6@addthis.com','550-120-7913');
INSERT INTO Employee(EmployeeID,PostCode,StreetName,StreetNumber,LastName,FirstName,Email,Phone) VALUES (2664224972,4292659745,'Buhler',3,'Gauntley','Tyler','tgauntley9@google.nl','613-820-9348');
INSERT INTO Employee(EmployeeID,PostCode,StreetName,StreetNumber,LastName,FirstName,Email,Phone) VALUES (8220096942,1849521964,'West',1,'Timmons','Cosimo','ctimmonsa@blog.com','922-990-8685');
INSERT INTO Employee(EmployeeID,PostCode,StreetName,StreetNumber,LastName,FirstName,Email,Phone) VALUES (3462572091,8861981305,'Eastlawn',74424,'Scotchmer','Clerc','cscotchmerb@netlog.com','419-511-6418');
INSERT INTO Employee(EmployeeID,PostCode,StreetName,StreetNumber,LastName,FirstName,Email,Phone) VALUES (0735530092,5982810088,'Monterey',55,'Lickess','Eugenius','elickessc@disqus.com','547-595-9938');
INSERT INTO Employee(EmployeeID,PostCode,StreetName,StreetNumber,LastName,FirstName,Email,Phone) VALUES (3040542680,5534158425,'Oriole',45,'Mateu','Wallache','wmateud@amazonaws.com','611-821-8003');
INSERT INTO Employee(EmployeeID,PostCode,StreetName,StreetNumber,LastName,FirstName,Email,Phone) VALUES (5718470243,2261571550,'Ridgeway',3225,'Emblen','Tyrus','temblenf@4shared.com','919-481-6395');
INSERT INTO Employee(EmployeeID,PostCode,StreetName,StreetNumber,LastName,FirstName,Email,Phone) VALUES (6487566055,2823442219,'Wayridge',3,'Brimming','Dyana','dbrimmingg@miitbeian.gov.cn','388-477-7134');
INSERT INTO Employee(EmployeeID,PostCode,StreetName,StreetNumber,LastName,FirstName,Email,Phone) VALUES (6393089148,5534158425,'Graceland',66,'Domone','Bronny','bdomoneh@sohu.com','119-138-7757');
INSERT INTO Employee(EmployeeID,PostCode,StreetName,StreetNumber,LastName,FirstName,Email,Phone) VALUES (1744270554,9853039680,'Spaight',5748,'Gibbieson','Kimberlee','kgibbiesoni@google.com.br','163-403-3133');
INSERT INTO Employee(EmployeeID,PostCode,StreetName,StreetNumber,LastName,FirstName,Email,Phone) VALUES (0063540770,1266871764,'Pond',1195,'Iannitti','Gizela','giannittij@ifeng.com','675-256-3605');
INSERT INTO Employee(EmployeeID,PostCode,StreetName,StreetNumber,LastName,FirstName,Email,Phone) VALUES (8731169643,5213104266,'Canary',965,'Shillitto','Cornie','cshillittok@merriam-webster.com','645-701-5187');
INSERT INTO Employee(EmployeeID,PostCode,StreetName,StreetNumber,LastName,FirstName,Email,Phone) VALUES (4563370274,9231089935,'Chive',7,'Melia','Damon','dmelial@barnesandnoble.com','253-954-5704');
INSERT INTO Employee(EmployeeID,PostCode,StreetName,StreetNumber,LastName,FirstName,Email,Phone) VALUES (0636218589,8861981305,'Eastlawn',74424,'Kohrt','Glynis','gkohrtm@dailymail.co.uk','882-783-1538');
INSERT INTO Employee(EmployeeID,PostCode,StreetName,StreetNumber,LastName,FirstName,Email,Phone) VALUES (9546791334,9231089935,'Chive',7,'Newling','Ode','onewlingn@discovery.com','198-502-6941');
INSERT INTO Employee(EmployeeID,PostCode,StreetName,StreetNumber,LastName,FirstName,Email,Phone) VALUES (8448712579,9853039680,'Spaight',5748,'MacGragh','Tallie','tmacgragho@toplist.cz','780-959-9291');
GO

-- SalesRepresentative

INSERT INTO SalesRepresentative(EmployeeID) VALUES (0181966077);
INSERT INTO SalesRepresentative(EmployeeID) VALUES (4563370274);
INSERT INTO SalesRepresentative(EmployeeID) VALUES (8220096942);
INSERT INTO SalesRepresentative(EmployeeID) VALUES (0636218589);
INSERT INTO SalesRepresentative(EmployeeID) VALUES (3040542680);
INSERT INTO SalesRepresentative(EmployeeID) VALUES (8448712579);
INSERT INTO SalesRepresentative(EmployeeID) VALUES (2664224972);
INSERT INTO SalesRepresentative(EmployeeID) VALUES (9546791334);
GO

-- Administrator

INSERT INTO Administrator(EmployeeID) VALUES (0274988607);
INSERT INTO Administrator(EmployeeID) VALUES (8731169643);
INSERT INTO Administrator(EmployeeID) VALUES (5718470243);
INSERT INTO Administrator(EmployeeID) VALUES (6487566055);
INSERT INTO Administrator(EmployeeID) VALUES (0063540770);
GO

-- ScoopMaintenanceContractor

INSERT INTO ScoopMaintenanceContractor(EmployeeID) VALUES (3149785065);
INSERT INTO ScoopMaintenanceContractor(EmployeeID) VALUES (7774743820);
INSERT INTO ScoopMaintenanceContractor(EmployeeID) VALUES (1744270554);
INSERT INTO ScoopMaintenanceContractor(EmployeeID) VALUES (2046627849);
INSERT INTO ScoopMaintenanceContractor(EmployeeID) VALUES (6393089148);
GO

-- Account

INSERT INTO Account(ClientNumber,DisplayName) VALUES (5368476426,'ccarcas0');
INSERT INTO Account(ClientNumber,DisplayName) VALUES (1315293889,'lcreffeild1');
INSERT INTO Account(ClientNumber,DisplayName) VALUES (8698437869,'abranson2');
INSERT INTO Account(ClientNumber,DisplayName) VALUES (3365682724,'hsmewin3');
INSERT INTO Account(ClientNumber,DisplayName) VALUES (7967924592,'sjuppe4');
INSERT INTO Account(ClientNumber,DisplayName) VALUES (3138623212,'csturch5');
INSERT INTO Account(ClientNumber,DisplayName) VALUES (1818498073,'alangstaff9');
INSERT INTO Account(ClientNumber,DisplayName) VALUES (1790663563,'rokuddyhya');
INSERT INTO Account(ClientNumber,DisplayName) VALUES (5908095249,'isybbeb');
INSERT INTO Account(ClientNumber,DisplayName) VALUES (0718825357,'ncursonsc');
INSERT INTO Account(ClientNumber,DisplayName) VALUES (9539931584,'dpitkaithlyd');
INSERT INTO Account(ClientNumber,DisplayName) VALUES (2480401235,'swhightmane');
INSERT INTO Account(ClientNumber,DisplayName) VALUES (6293677250,'mbloggf');
INSERT INTO Account(ClientNumber,DisplayName) VALUES (9085230039,'troyansg');
INSERT INTO Account(ClientNumber,DisplayName) VALUES (6826871602,'rcooleyh');
INSERT INTO Account(ClientNumber,DisplayName) VALUES (2590427832,'vsimoncinii');
INSERT INTO Account(ClientNumber,DisplayName) VALUES (1263371582,'aannesj');
INSERT INTO Account(ClientNumber,DisplayName) VALUES (9701148797,'avizorl');
INSERT INTO Account(ClientNumber,DisplayName) VALUES (2330654863,'phatchm');
INSERT INTO Account(ClientNumber,DisplayName) VALUES (6069251970,'skivelhano');
INSERT INTO Account(ClientNumber,DisplayName) VALUES (1120293308,'skinsonp');
INSERT INTO Account(ClientNumber,DisplayName) VALUES (4761042923,'khammelq');
INSERT INTO Account(ClientNumber,DisplayName) VALUES (2769627481,'ewebberleyr');
INSERT INTO Account(ClientNumber,DisplayName) VALUES (3784174744,'jkamans');
INSERT INTO Account(ClientNumber,DisplayName) VALUES (6858444785,'gscarsbricku');
INSERT INTO Account(ClientNumber,DisplayName) VALUES (0395712343,'rblickv');
INSERT INTO Account(ClientNumber,DisplayName) VALUES (0049710753,'nvanveldew');
INSERT INTO Account(ClientNumber,DisplayName) VALUES (1510758526,'jwilletsx');
INSERT INTO Account(ClientNumber,DisplayName) VALUES (0645956171,'jfranceschiy');
INSERT INTO Account(ClientNumber,DisplayName) VALUES (2566254869,'drestieaux10');
INSERT INTO Account(ClientNumber,DisplayName) VALUES (7726245433,'tkerans11');
INSERT INTO Account(ClientNumber,DisplayName) VALUES (5475552797,'asives13');
INSERT INTO Account(ClientNumber,DisplayName) VALUES (2792542675,'muccello14');
INSERT INTO Account(ClientNumber,DisplayName) VALUES (7911402566,'tainsby16');
INSERT INTO Account(ClientNumber,DisplayName) VALUES (6491690768,'isabater17');
INSERT INTO Account(ClientNumber,DisplayName) VALUES (9046389987,'rlhommeau18');
INSERT INTO Account(ClientNumber,DisplayName) VALUES (2905432586,'tdecreuze19');
INSERT INTO Account(ClientNumber,DisplayName) VALUES (0922727635,'gpickover1a');
INSERT INTO Account(ClientNumber,DisplayName) VALUES (0439539803,'hgoard1b');
INSERT INTO Account(ClientNumber,DisplayName) VALUES (1510586903,'crandell1c');
INSERT INTO Account(ClientNumber,DisplayName) VALUES (1523272244,'alowdyane1d');
INSERT INTO Account(ClientNumber,DisplayName) VALUES (6526595480,'adaish1f');
INSERT INTO Account(ClientNumber,DisplayName) VALUES (4078685242,'mbeardsdale1g');
INSERT INTO Account(ClientNumber,DisplayName) VALUES (2059565952,'bkybbye1i');
INSERT INTO Account(ClientNumber,DisplayName) VALUES (5795290173,'wcottie1k');
INSERT INTO Account(ClientNumber,DisplayName) VALUES (8986383187,'cbourne1l');
INSERT INTO Account(ClientNumber,DisplayName) VALUES (6247270747,'jfaircliffe1m');
INSERT INTO Account(ClientNumber,DisplayName) VALUES (1686632061,'jashe1n');
INSERT INTO Account(ClientNumber,DisplayName) VALUES (4873768268,'cdmitrichenko1o');
INSERT INTO Account(ClientNumber,DisplayName) VALUES (8811540097,'aharnor1p');
INSERT INTO Account(ClientNumber,DisplayName) VALUES (7575638466,'gclemes1q');
INSERT INTO Account(ClientNumber,DisplayName) VALUES (6905639591,'ggenery1r');
INSERT INTO Account(ClientNumber,DisplayName) VALUES (6853922638,'hstoven1s');
INSERT INTO Account(ClientNumber,DisplayName) VALUES (8581058175,'csidebottom1t');
INSERT INTO Account(ClientNumber,DisplayName) VALUES (4166183516,'ncoonihan1u');
INSERT INTO Account(ClientNumber,DisplayName) VALUES (1820145549,'bpiner1v');
GO

-- Subscription

INSERT INTO Subscription(SubscriptionID,EmployeeID,ClientNumber,DisplayName) VALUES (4206415331,3040542680,1790663563,'rokuddyhya');
INSERT INTO Subscription(SubscriptionID,EmployeeID,ClientNumber,DisplayName) VALUES (2763570925,8448712579,2769627481,'ewebberleyr');
INSERT INTO Subscription(SubscriptionID,EmployeeID,ClientNumber,DisplayName) VALUES (3316878246,4563370274,1820145549,'bpiner1v');
INSERT INTO Subscription(SubscriptionID,EmployeeID,ClientNumber,DisplayName) VALUES (0674537041,0636218589,1315293889,'lcreffeild1');
INSERT INTO Subscription(SubscriptionID,EmployeeID,ClientNumber,DisplayName) VALUES (5730795165,0636218589,7575638466,'gclemes1q');
INSERT INTO Subscription(SubscriptionID,EmployeeID,ClientNumber,DisplayName) VALUES (9126805367,2664224972,2330654863,'phatchm');
INSERT INTO Subscription(SubscriptionID,EmployeeID,ClientNumber,DisplayName) VALUES (5566609635,0636218589,8581058175,'csidebottom1t');
INSERT INTO Subscription(SubscriptionID,EmployeeID,ClientNumber,DisplayName) VALUES (7670722371,4563370274,4078685242,'mbeardsdale1g');
INSERT INTO Subscription(SubscriptionID,EmployeeID,ClientNumber,DisplayName) VALUES (3291595726,3040542680,2905432586,'tdecreuze19');
INSERT INTO Subscription(SubscriptionID,EmployeeID,ClientNumber,DisplayName) VALUES (2409136508,0181966077,4166183516,'ncoonihan1u');
INSERT INTO Subscription(SubscriptionID,EmployeeID,ClientNumber,DisplayName) VALUES (8367033612,4563370274,6526595480,'adaish1f');
INSERT INTO Subscription(SubscriptionID,EmployeeID,ClientNumber,DisplayName) VALUES (0247767484,2664224972,6853922638,'hstoven1s');
INSERT INTO Subscription(SubscriptionID,EmployeeID,ClientNumber,DisplayName) VALUES (3468823517,4563370274,1523272244,'alowdyane1d');
INSERT INTO Subscription(SubscriptionID,EmployeeID,ClientNumber,DisplayName) VALUES (7996768811,8448712579,7967924592,'sjuppe4');
INSERT INTO Subscription(SubscriptionID,EmployeeID,ClientNumber,DisplayName) VALUES (0838500412,0181966077,0439539803,'hgoard1b');
INSERT INTO Subscription(SubscriptionID,EmployeeID,ClientNumber,DisplayName) VALUES (5015594356,9546791334,1510758526,'jwilletsx');
INSERT INTO Subscription(SubscriptionID,EmployeeID,ClientNumber,DisplayName) VALUES (0748978550,3040542680,1120293308,'skinsonp');
INSERT INTO Subscription(SubscriptionID,EmployeeID,ClientNumber,DisplayName) VALUES (3451307561,0181966077,4761042923,'khammelq');
INSERT INTO Subscription(SubscriptionID,EmployeeID,ClientNumber,DisplayName) VALUES (7723384041,2664224972,5368476426,'ccarcas0');
INSERT INTO Subscription(SubscriptionID,EmployeeID,ClientNumber,DisplayName) VALUES (7372916194,0636218589,7575638466,'gclemes1q');
INSERT INTO Subscription(SubscriptionID,EmployeeID,ClientNumber,DisplayName) VALUES (2612144412,0636218589,4166183516,'ncoonihan1u');
INSERT INTO Subscription(SubscriptionID,EmployeeID,ClientNumber,DisplayName) VALUES (5151008269,4563370274,2566254869,'drestieaux10');
INSERT INTO Subscription(SubscriptionID,EmployeeID,ClientNumber,DisplayName) VALUES (4339516112,9546791334,9539931584,'dpitkaithlyd');
INSERT INTO Subscription(SubscriptionID,EmployeeID,ClientNumber,DisplayName) VALUES (5869245397,8220096942,6491690768,'isabater17');
INSERT INTO Subscription(SubscriptionID,EmployeeID,ClientNumber,DisplayName) VALUES (7279262260,4563370274,2590427832,'vsimoncinii');
INSERT INTO Subscription(SubscriptionID,EmployeeID,ClientNumber,DisplayName) VALUES (7829857989,8220096942,1263371582,'aannesj');
INSERT INTO Subscription(SubscriptionID,EmployeeID,ClientNumber,DisplayName) VALUES (9281092719,4563370274,0645956171,'jfranceschiy');
INSERT INTO Subscription(SubscriptionID,EmployeeID,ClientNumber,DisplayName) VALUES (1817874632,0636218589,6853922638,'hstoven1s');
INSERT INTO Subscription(SubscriptionID,EmployeeID,ClientNumber,DisplayName) VALUES (7961044027,4563370274,1686632061,'jashe1n');
INSERT INTO Subscription(SubscriptionID,EmployeeID,ClientNumber,DisplayName) VALUES (3426130475,0636218589,1510586903,'crandell1c');
INSERT INTO Subscription(SubscriptionID,EmployeeID,ClientNumber,DisplayName) VALUES (9207062631,4563370274,1790663563,'rokuddyhya');
INSERT INTO Subscription(SubscriptionID,EmployeeID,ClientNumber,DisplayName) VALUES (5489509961,0636218589,5368476426,'ccarcas0');
INSERT INTO Subscription(SubscriptionID,EmployeeID,ClientNumber,DisplayName) VALUES (5808790662,3040542680,1120293308,'skinsonp');
INSERT INTO Subscription(SubscriptionID,EmployeeID,ClientNumber,DisplayName) VALUES (0000547190,2664224972,2059565952,'bkybbye1i');
INSERT INTO Subscription(SubscriptionID,EmployeeID,ClientNumber,DisplayName) VALUES (6396721309,0636218589,7967924592,'sjuppe4');
INSERT INTO Subscription(SubscriptionID,EmployeeID,ClientNumber,DisplayName) VALUES (9347716286,8220096942,5908095249,'isybbeb');
INSERT INTO Subscription(SubscriptionID,EmployeeID,ClientNumber,DisplayName) VALUES (2178646999,0636218589,1510586903,'crandell1c');
INSERT INTO Subscription(SubscriptionID,EmployeeID,ClientNumber,DisplayName) VALUES (4748847832,9546791334,6853922638,'hstoven1s');
INSERT INTO Subscription(SubscriptionID,EmployeeID,ClientNumber,DisplayName) VALUES (6015683775,8448712579,7911402566,'tainsby16');
INSERT INTO Subscription(SubscriptionID,EmployeeID,ClientNumber,DisplayName) VALUES (8865393998,9546791334,2480401235,'swhightmane');
INSERT INTO Subscription(SubscriptionID,EmployeeID,ClientNumber,DisplayName) VALUES (7059942726,8448712579,9046389987,'rlhommeau18');
INSERT INTO Subscription(SubscriptionID,EmployeeID,ClientNumber,DisplayName) VALUES (8059923692,2664224972,2905432586,'tdecreuze19');
INSERT INTO Subscription(SubscriptionID,EmployeeID,ClientNumber,DisplayName) VALUES (5749455599,0181966077,2792542675,'muccello14');
INSERT INTO Subscription(SubscriptionID,EmployeeID,ClientNumber,DisplayName) VALUES (0520201396,9546791334,0395712343,'rblickv');
INSERT INTO Subscription(SubscriptionID,EmployeeID,ClientNumber,DisplayName) VALUES (2900508533,4563370274,1820145549,'bpiner1v');
INSERT INTO Subscription(SubscriptionID,EmployeeID,ClientNumber,DisplayName) VALUES (9126937662,8448712579,5795290173,'wcottie1k');
INSERT INTO Subscription(SubscriptionID,EmployeeID,ClientNumber,DisplayName) VALUES (5444617870,8220096942,6826871602,'rcooleyh');
GO

-- Gold

INSERT INTO Gold(SubscriptionID,Price) VALUES (5444617870,25.0);
INSERT INTO Gold(SubscriptionID,Price) VALUES (6015683775,25.0);
INSERT INTO Gold(SubscriptionID,Price) VALUES (9207062631,25.0);
INSERT INTO Gold(SubscriptionID,Price) VALUES (6396721309,25.0);
INSERT INTO Gold(SubscriptionID,Price) VALUES (0838500412,25.0);
INSERT INTO Gold(SubscriptionID,Price) VALUES (3451307561,25.0);
INSERT INTO Gold(SubscriptionID,Price) VALUES (7279262260,25.0);
INSERT INTO Gold(SubscriptionID,Price) VALUES (3468823517,25.0);
INSERT INTO Gold(SubscriptionID,Price) VALUES (7829857989,25.0);
INSERT INTO Gold(SubscriptionID,Price) VALUES (0520201396,25.0);
INSERT INTO Gold(SubscriptionID,Price) VALUES (9126805367,25.0);
GO

-- Platinum

INSERT INTO Platinum(SubscriptionID,Price) VALUES (0838500412,50.0);
INSERT INTO Platinum(SubscriptionID,Price) VALUES (3451307561,50.0);
INSERT INTO Platinum(SubscriptionID,Price) VALUES (7279262260,50.0);
INSERT INTO Platinum(SubscriptionID,Price) VALUES (3468823517,50.0);
INSERT INTO Platinum(SubscriptionID,Price) VALUES (7829857989,50.0);
INSERT INTO Platinum(SubscriptionID,Price) VALUES (0520201396,50.0);
INSERT INTO Platinum(SubscriptionID,Price) VALUES (9126805367,50.0);
GO

-- Super Platinum

INSERT INTO SuperPlatinum(SubscriptionID,Price) VALUES (7279262260,99.0);
INSERT INTO SuperPlatinum(SubscriptionID,Price) VALUES (3468823517,99.0);
INSERT INTO SuperPlatinum(SubscriptionID,Price) VALUES (7829857989,99.0);
INSERT INTO SuperPlatinum(SubscriptionID,Price) VALUES (0520201396,99.0);
INSERT INTO SuperPlatinum(SubscriptionID,Price) VALUES (9126805367,99.0);
GO

-- Contract

INSERT INTO Contract(ContractID,EmployeeID,SubscriptionID,OrganizationName) VALUES (1143475739,0274988607,7279262260,'Jast-Crona');
INSERT INTO Contract(ContractID,EmployeeID,SubscriptionID,OrganizationName) VALUES (6111280627,6487566055,3468823517,'Feest Inc');
INSERT INTO Contract(ContractID,EmployeeID,SubscriptionID,OrganizationName) VALUES (9353658659,8731169643,7829857989,'Ryan-Lowe');
INSERT INTO Contract(ContractID,EmployeeID,SubscriptionID,OrganizationName) VALUES (1772973653,8731169643,0520201396,'Bailey, West and Lynch');
INSERT INTO Contract(ContractID,EmployeeID,SubscriptionID,OrganizationName) VALUES (1132184232,5718470243,9126805367,'West-Jabe');
GO

-- Supplier

INSERT INTO Supplier(SupplierID,SupplierName) VALUES (0707274583,'Lesch-Hyatt');
INSERT INTO Supplier(SupplierID,SupplierName) VALUES (2451787457,'Vandervort Group');
INSERT INTO Supplier(SupplierID,SupplierName) VALUES (7661156741,'Beier, Renner and Gleichner');
INSERT INTO Supplier(SupplierID,SupplierName) VALUES (1122619944,'Cremin, Bauch and Roberts');
INSERT INTO Supplier(SupplierID,SupplierName) VALUES (9155425704,'Cronin Inc');
INSERT INTO Supplier(SupplierID,SupplierName) VALUES (3063951005,'Beatty-Larkin');
INSERT INTO Supplier(SupplierID,SupplierName) VALUES (7397688829,'Sanford Group');
GO

-- DroneComponent

INSERT INTO DroneComponent(ComponentID,ComponentName,Quantity,Price) VALUES (0794678572,'Wood',1,33.0);
INSERT INTO DroneComponent(ComponentID,ComponentName,Quantity,Price) VALUES (3086375795,'Rubber',36,80.0);
INSERT INTO DroneComponent(ComponentID,ComponentName,Quantity,Price) VALUES (1920878173,'Steel',31,47.0);
INSERT INTO DroneComponent(ComponentID,ComponentName,Quantity,Price) VALUES (9629395940,'Steel',31,57.0);
INSERT INTO DroneComponent(ComponentID,ComponentName,Quantity,Price) VALUES (0054769663,'Plexiglass',29,41.0);
INSERT INTO DroneComponent(ComponentID,ComponentName,Quantity,Price) VALUES (8193396421,'Aluminum',18,31.0);
INSERT INTO DroneComponent(ComponentID,ComponentName,Quantity,Price) VALUES (1506086756,'Aluminum',29,29.0);
INSERT INTO DroneComponent(ComponentID,ComponentName,Quantity,Price) VALUES (3479411169,'Glass',1,64.0);
INSERT INTO DroneComponent(ComponentID,ComponentName,Quantity,Price) VALUES (0971971064,'Plexiglass',23,17.0);
INSERT INTO DroneComponent(ComponentID,ComponentName,Quantity,Price) VALUES (9177887166,'Granite',8,81.0);
INSERT INTO DroneComponent(ComponentID,ComponentName,Quantity,Price) VALUES (7012199679,'Plastic',38,48.0);
INSERT INTO DroneComponent(ComponentID,ComponentName,Quantity,Price) VALUES (5525403854,'Granite',16,77.0);
INSERT INTO DroneComponent(ComponentID,ComponentName,Quantity,Price) VALUES (6483172508,'Wood',3,47.0);
INSERT INTO DroneComponent(ComponentID,ComponentName,Quantity,Price) VALUES (1719730539,'Stone',33,11.0);
INSERT INTO DroneComponent(ComponentID,ComponentName,Quantity,Price) VALUES (1902930037,'Plastic',16,42.0);
INSERT INTO DroneComponent(ComponentID,ComponentName,Quantity,Price) VALUES (4203448220,'Aluminum',4,57.0);
INSERT INTO DroneComponent(ComponentID,ComponentName,Quantity,Price) VALUES (6053712949,'Plastic',34,15.0);
INSERT INTO DroneComponent(ComponentID,ComponentName,Quantity,Price) VALUES (2286080410,'Plastic',22,14.0);
INSERT INTO DroneComponent(ComponentID,ComponentName,Quantity,Price) VALUES (1340865491,'Wood',16,96.0);
INSERT INTO DroneComponent(ComponentID,ComponentName,Quantity,Price) VALUES (5834151221,'Rubber',14,4.0);
INSERT INTO DroneComponent(ComponentID,ComponentName,Quantity,Price) VALUES (0041281438,'Vinyl',13,87.0);
INSERT INTO DroneComponent(ComponentID,ComponentName,Quantity,Price) VALUES (0119370042,'Stone',33,84.0);
INSERT INTO DroneComponent(ComponentID,ComponentName,Quantity,Price) VALUES (7030764676,'Granite',26,98.0);
INSERT INTO DroneComponent(ComponentID,ComponentName,Quantity,Price) VALUES (2763039243,'Steel',10,46.0);
INSERT INTO DroneComponent(ComponentID,ComponentName,Quantity,Price) VALUES (2154432948,'Aluminum',39,64.0);
GO

-- ComponentPurchase

INSERT INTO ComponentPurchase(SupplierID,ComponentID,EmployeeID,"Date","Time",TotalPrice,SaleDescription) VALUES (0707274583,0794678572,7774743820,'2023-08-06','1:51 AM',83.89,'Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.');
INSERT INTO ComponentPurchase(SupplierID,ComponentID,EmployeeID,"Date","Time",TotalPrice,SaleDescription) VALUES (3063951005,3086375795,7774743820,'2024-01-01','2:00 AM',63.95,'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.');
INSERT INTO ComponentPurchase(SupplierID,ComponentID,EmployeeID,"Date","Time",TotalPrice,SaleDescription) VALUES (2451787457,1920878173,7774743820,'2023-08-07','6:07 AM',91.92,'Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.');
INSERT INTO ComponentPurchase(SupplierID,ComponentID,EmployeeID,"Date","Time",TotalPrice,SaleDescription) VALUES (7661156741,9629395940,7774743820,'2023-12-10','11:54 AM',28.59,'Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.');
INSERT INTO ComponentPurchase(SupplierID,ComponentID,EmployeeID,"Date","Time",TotalPrice,SaleDescription) VALUES (7661156741,0054769663,2046627849,'2024-04-12','9:07 AM',30.61,'Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.');
INSERT INTO ComponentPurchase(SupplierID,ComponentID,EmployeeID,"Date","Time",TotalPrice,SaleDescription) VALUES (7661156741,8193396421,1744270554,'2024-01-15','8:19 PM',94.18,'Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.');
INSERT INTO ComponentPurchase(SupplierID,ComponentID,EmployeeID,"Date","Time",TotalPrice,SaleDescription) VALUES (2451787457,1506086756,2046627849,'2023-06-20','1:54 AM',95.67,'Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.');
INSERT INTO ComponentPurchase(SupplierID,ComponentID,EmployeeID,"Date","Time",TotalPrice,SaleDescription) VALUES (9155425704,3479411169,2046627849,'2023-07-13','2:42 PM',23.02,'Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.');
INSERT INTO ComponentPurchase(SupplierID,ComponentID,EmployeeID,"Date","Time",TotalPrice,SaleDescription) VALUES (1122619944,0971971064,1744270554,'2023-11-28','12:14 AM',11.7,'Fusce consequat. Nulla nisl. Nunc nisl.');
INSERT INTO ComponentPurchase(SupplierID,ComponentID,EmployeeID,"Date","Time",TotalPrice,SaleDescription) VALUES (0707274583,9177887166,2046627849,'2023-08-25','4:07 PM',36.47,'Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.');
INSERT INTO ComponentPurchase(SupplierID,ComponentID,EmployeeID,"Date","Time",TotalPrice,SaleDescription) VALUES (7397688829,7012199679,1744270554,'2023-12-27','11:06 AM',46.18,'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.');
INSERT INTO ComponentPurchase(SupplierID,ComponentID,EmployeeID,"Date","Time",TotalPrice,SaleDescription) VALUES (2451787457,5525403854,1744270554,'2024-01-11','9:32 PM',17.2,'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.');
GO

-- DataScoop

INSERT INTO DataScoop(DataScoopID,EmployeeID,SubscriptionID,DroneComponentID) VALUES (2808699328,2046627849,0838500412,7030764676);
INSERT INTO DataScoop(DataScoopID,EmployeeID,SubscriptionID,DroneComponentID) VALUES (7977315815,5718470243,0838500412,3086375795);
INSERT INTO DataScoop(DataScoopID,EmployeeID,SubscriptionID,DroneComponentID) VALUES (7255636713,0636218589,9207062631,5525403854);
INSERT INTO DataScoop(DataScoopID,EmployeeID,SubscriptionID,DroneComponentID) VALUES (9924605381,5718470243,9207062631,3086375795);
INSERT INTO DataScoop(DataScoopID,EmployeeID,SubscriptionID,DroneComponentID) VALUES (7758009573,0636218589,9207062631,0971971064);
INSERT INTO DataScoop(DataScoopID,EmployeeID,SubscriptionID,DroneComponentID) VALUES (2209480213,5718470243,9207062631,0054769663);
INSERT INTO DataScoop(DataScoopID,EmployeeID,SubscriptionID,DroneComponentID) VALUES (2162451263,0636218589,5444617870,0119370042);
INSERT INTO DataScoop(DataScoopID,EmployeeID,SubscriptionID,DroneComponentID) VALUES (7518606658,2046627849,5444617870,2154432948);
INSERT INTO DataScoop(DataScoopID,EmployeeID,SubscriptionID,DroneComponentID) VALUES (4193107868,2046627849,6396721309,0119370042);
INSERT INTO DataScoop(DataScoopID,EmployeeID,SubscriptionID,DroneComponentID) VALUES (0862715083,5718470243,0520201396,5834151221);
INSERT INTO DataScoop(DataScoopID,EmployeeID,SubscriptionID,DroneComponentID) VALUES (2504809999,7774743820,5444617870,7030764676);
INSERT INTO DataScoop(DataScoopID,EmployeeID,SubscriptionID,DroneComponentID) VALUES (7512740948,2046627849,7829857989,0054769663);
INSERT INTO DataScoop(DataScoopID,EmployeeID,SubscriptionID,DroneComponentID) VALUES (1714005984,1744270554,3468823517,7012199679);
INSERT INTO DataScoop(DataScoopID,EmployeeID,SubscriptionID,DroneComponentID) VALUES (7120533355,9546791334,0520201396,1340865491);
INSERT INTO DataScoop(DataScoopID,EmployeeID,SubscriptionID,DroneComponentID) VALUES (2790009953,2046627849,7829857989,5525403854);
INSERT INTO DataScoop(DataScoopID,EmployeeID,SubscriptionID,DroneComponentID) VALUES (4253689175,2046627849,5444617870,2154432948);
INSERT INTO DataScoop(DataScoopID,EmployeeID,SubscriptionID,DroneComponentID) VALUES (1283429314,7774743820,0520201396,0119370042);
INSERT INTO DataScoop(DataScoopID,EmployeeID,SubscriptionID,DroneComponentID) VALUES (7324438628,8448712579,3451307561,8193396421);
INSERT INTO DataScoop(DataScoopID,EmployeeID,SubscriptionID,DroneComponentID) VALUES (7262975579,5718470243,3451307561,5834151221);
INSERT INTO DataScoop(DataScoopID,EmployeeID,SubscriptionID,DroneComponentID) VALUES (6661389753,0181966077,3451307561,5834151221);
GO

-- Data

INSERT INTO Data(RecordID,DataScoopID,SubscriptionID,"Time",Temperature,OrganicData,AmbientLightStrength,Humidity) VALUES (7212800910,4193107868,0838500412,'3:14 AM',24.03,'In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, Nulla justo.',17,32);
INSERT INTO Data(RecordID,DataScoopID,SubscriptionID,"Time",Temperature,OrganicData,AmbientLightStrength,Humidity) VALUES (6123989847,7324438628,0838500412,'6:17 PM',46.33,'In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.',7,44);
INSERT INTO Data(RecordID,DataScoopID,SubscriptionID,"Time",Temperature,OrganicData,AmbientLightStrength,Humidity) VALUES (9201674597,2504809999,0838500412,'3:08 AM',72.06,'In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.',20,60);
INSERT INTO Data(RecordID,DataScoopID,SubscriptionID,"Time",Temperature,OrganicData,AmbientLightStrength,Humidity) VALUES (4335787995,4193107868,0838500412,'2:17 PM',38.85,'Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.',3,62);
INSERT INTO Data(RecordID,DataScoopID,SubscriptionID,"Time",Temperature,OrganicData,AmbientLightStrength,Humidity) VALUES (3595351703,4253689175,0838500412,'8:03 AM',45.19,'Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.',10,62);
INSERT INTO Data(RecordID,DataScoopID,SubscriptionID,"Time",Temperature,OrganicData,AmbientLightStrength,Humidity) VALUES (9491204262,7512740948,0838500412,'12:28 PM',94.62,'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.',15,61);
INSERT INTO Data(RecordID,DataScoopID,SubscriptionID,"Time",Temperature,OrganicData,AmbientLightStrength,Humidity) VALUES (7245402167,9924605381,7279262260,'7:49 AM',29.61,'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi.',7,34);
INSERT INTO Data(RecordID,DataScoopID,SubscriptionID,"Time",Temperature,OrganicData,AmbientLightStrength,Humidity) VALUES (7476397460,4253689175,7279262260,'8:13 AM',15.37,'In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.',6,49);
INSERT INTO Data(RecordID,DataScoopID,SubscriptionID,"Time",Temperature,OrganicData,AmbientLightStrength,Humidity) VALUES (3396781481,6661389753,7279262260,'8:06 PM',57.76,'Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.',18,11);
INSERT INTO Data(RecordID,DataScoopID,SubscriptionID,"Time",Temperature,OrganicData,AmbientLightStrength,Humidity) VALUES (2145141073,4253689175,7279262260,'8:46 AM',98.47,'In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.',4,52);
INSERT INTO Data(RecordID,DataScoopID,SubscriptionID,"Time",Temperature,OrganicData,AmbientLightStrength,Humidity) VALUES (5482763153,1283429314,3468823517,'4:47 PM',9.76,'Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.',5,15);
INSERT INTO Data(RecordID,DataScoopID,SubscriptionID,"Time",Temperature,OrganicData,AmbientLightStrength,Humidity) VALUES (6903025081,7255636713,3468823517,'6:19 PM',72.83,'Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.',7,39);
INSERT INTO Data(RecordID,DataScoopID,SubscriptionID,"Time",Temperature,OrganicData,AmbientLightStrength,Humidity) VALUES (3845880082,2790009953,7829857989,'2:14 AM',55.24,'Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.',7,40);
INSERT INTO Data(RecordID,DataScoopID,SubscriptionID,"Time",Temperature,OrganicData,AmbientLightStrength,Humidity) VALUES (3976341282,6661389753,7829857989,'8:25 AM',54.12,'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. nascetur ridiculus mus.',5,2);
INSERT INTO Data(RecordID,DataScoopID,SubscriptionID,"Time",Temperature,OrganicData,AmbientLightStrength,Humidity) VALUES (3184562123,7977315815,7829857989,'2:40 AM',10.49,'In congue. Etiam justo. Etiam pretium iaculis justo.',15,11);
INSERT INTO Data(RecordID,DataScoopID,SubscriptionID,"Time",Temperature,OrganicData,AmbientLightStrength,Humidity) VALUES (4909110976,2808699328,7829857989,'5:53 PM',17.89,'Fusce consequat. Nulla nisl. Nunc nisl.',17,6);
INSERT INTO Data(RecordID,DataScoopID,SubscriptionID,"Time",Temperature,OrganicData,AmbientLightStrength,Humidity) VALUES (0459514474,7262975579,0520201396,'4:08 AM',44.74,'Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Curabitur convallis.',1,13);
INSERT INTO Data(RecordID,DataScoopID,SubscriptionID,"Time",Temperature,OrganicData,AmbientLightStrength,Humidity) VALUES (8701248227,4193107868,0520201396,'12:05 AM',92.62,'Fusce consequat. Nulla nisl. Nunc nisl.',2,68);
INSERT INTO Data(RecordID,DataScoopID,SubscriptionID,"Time",Temperature,OrganicData,AmbientLightStrength,Humidity) VALUES (2450283137,1714005984,0520201396,'9:23 AM',27.86,'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.',12,25);
INSERT INTO Data(RecordID,DataScoopID,SubscriptionID,"Time",Temperature,OrganicData,AmbientLightStrength,Humidity) VALUES (7005093402,7518606658,0520201396,'2:05 AM',58.55,'In congue. Etiam justo. Etiam pretium iaculis justo.',15,70);
GO

-- LiveStream

INSERT INTO LiveStream(StreamID,DataScoopID,SubscriptionID) VALUES (1,6661389753,4206415331);
INSERT INTO LiveStream(StreamID,DataScoopID,SubscriptionID) VALUES (2,2209480213,4206415331);
INSERT INTO LiveStream(StreamID,DataScoopID,SubscriptionID) VALUES (3,7518606658,4206415331);
INSERT INTO LiveStream(StreamID,DataScoopID,SubscriptionID) VALUES (4,7512740948,2409136508);
INSERT INTO LiveStream(StreamID,DataScoopID,SubscriptionID) VALUES (5,7758009573,2409136508);
INSERT INTO LiveStream(StreamID,DataScoopID,SubscriptionID) VALUES (6,2504809999,5015594356);
INSERT INTO LiveStream(StreamID,DataScoopID,SubscriptionID) VALUES (7,7120533355,5015594356);
INSERT INTO LiveStream(StreamID,DataScoopID,SubscriptionID) VALUES (8,7977315815,0674537041);
INSERT INTO LiveStream(StreamID,DataScoopID,SubscriptionID) VALUES (9,2209480213,0674537041);
INSERT INTO LiveStream(StreamID,DataScoopID,SubscriptionID) VALUES (10,7324438628,9347716286);
INSERT INTO LiveStream(StreamID,DataScoopID,SubscriptionID) VALUES (11,6661389753,0247767484);
INSERT INTO LiveStream(StreamID,DataScoopID,SubscriptionID) VALUES (12,7758009573,0674537041);
INSERT INTO LiveStream(StreamID,DataScoopID,SubscriptionID) VALUES (13,2162451263,7996768811);
INSERT INTO LiveStream(StreamID,DataScoopID,SubscriptionID) VALUES (14,1283429314,4748847832);
GO

-- Zone

INSERT INTO Zone(ZoneID,SubscriptionID,DataScoopID,Climate) VALUES (58,0520201396,7512740948,'felis');
INSERT INTO Zone(ZoneID,SubscriptionID,DataScoopID,Climate) VALUES (33,0520201396,9924605381,'sapien');
INSERT INTO Zone(ZoneID,SubscriptionID,DataScoopID,Climate) VALUES (60,0520201396,7255636713,'massa');
INSERT INTO Zone(ZoneID,SubscriptionID,DataScoopID,Climate) VALUES (45,0520201396,7120533355,'et');
INSERT INTO Zone(ZoneID,SubscriptionID,DataScoopID,Climate) VALUES (10,3468823517,7255636713,'fusce');
INSERT INTO Zone(ZoneID,SubscriptionID,DataScoopID,Climate) VALUES (37,3468823517,7324438628,'volutpat');
INSERT INTO Zone(ZoneID,SubscriptionID,DataScoopID,Climate) VALUES (28,3468823517,2209480213,'vel');
INSERT INTO Zone(ZoneID,SubscriptionID,DataScoopID,Climate) VALUES (46,3468823517,2209480213,'faucibus');
GO

-- Location

INSERT INTO Location(Longitude,Latitude,DataScoopID,ZoneID) VALUES (121.0230236,14.570844,1714005984,'33');
INSERT INTO Location(Longitude,Latitude,DataScoopID,ZoneID) VALUES (17.0632716,51.3104211,4253689175,'60');
INSERT INTO Location(Longitude,Latitude,DataScoopID,ZoneID) VALUES (-73.287406,6.639497,7758009573,'58');
INSERT INTO Location(Longitude,Latitude,DataScoopID,ZoneID) VALUES (41.6873842,53.6557845,2209480213,'33');
INSERT INTO Location(Longitude,Latitude,DataScoopID,ZoneID) VALUES (44.2868976,40.2343129,7262975579,'58');
INSERT INTO Location(Longitude,Latitude,DataScoopID,ZoneID) VALUES (124.5350175,7.1774408,2162451263,'10');
INSERT INTO Location(Longitude,Latitude,DataScoopID,ZoneID) VALUES (107.8902,-7.1913,7977315815,'10');
INSERT INTO Location(Longitude,Latitude,DataScoopID,ZoneID) VALUES (19.0293816,49.5288417,1283429314,'58');
INSERT INTO Location(Longitude,Latitude,DataScoopID,ZoneID) VALUES (-8.0752858,40.7477848,7324438628,'33');
INSERT INTO Location(Longitude,Latitude,DataScoopID,ZoneID) VALUES (106.585841,27.783878,2808699328,'10');
INSERT INTO Location(Longitude,Latitude,DataScoopID,ZoneID) VALUES (-77.6407258,-11.0216067,7262975579,'60');
INSERT INTO Location(Longitude,Latitude,DataScoopID,ZoneID) VALUES (2.3496109,49.034461,6661389753,'45');
INSERT INTO Location(Longitude,Latitude,DataScoopID,ZoneID) VALUES (13.6546035,55.8346942,9924605381,'10');
INSERT INTO Location(Longitude,Latitude,DataScoopID,ZoneID) VALUES (3.2188961,43.3362822,7518606658,'33');
INSERT INTO Location(Longitude,Latitude,DataScoopID,ZoneID) VALUES (130.5921699,45.755062,2209480213,'45');
INSERT INTO Location(Longitude,Latitude,DataScoopID,ZoneID) VALUES (120.9138589,14.3082674,2504809999,'33');
INSERT INTO Location(Longitude,Latitude,DataScoopID,ZoneID) VALUES (111.3262355,-6.797767,7512740948,'45');
INSERT INTO Location(Longitude,Latitude,DataScoopID,ZoneID) VALUES (-0.6867939,38.0294026,7324438628,'46');
INSERT INTO Location(Longitude,Latitude,DataScoopID,ZoneID) VALUES (13.8437009,50.3348673,7977315815,'45');
INSERT INTO Location(Longitude,Latitude,DataScoopID,ZoneID) VALUES (108.413764,36.87492,7324438628,'10');
INSERT INTO Location(Longitude,Latitude,DataScoopID,ZoneID) VALUES (20.7477906,45.1099868,2209480213,'46');
INSERT INTO Location(Longitude,Latitude,DataScoopID,ZoneID) VALUES (-88.1837629,30.6758871,2209480213,'45');
INSERT INTO Location(Longitude,Latitude,DataScoopID,ZoneID) VALUES (-7.8554287,38.0208091,2209480213,'46');
INSERT INTO Location(Longitude,Latitude,DataScoopID,ZoneID) VALUES (107.1071,-6.2335134,7324438628,'60');
GO

-- Maintenance 

INSERT INTO Maintenance(MaintenanceRecordID,DataScoopID,EmployeeID,ComponentID,Date,Time,Description) VALUES (7412340379,0862715083,3149785065,6483172508,'2023-08-25','5:24 PM','Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.');
INSERT INTO Maintenance(MaintenanceRecordID,DataScoopID,EmployeeID,ComponentID,Date,Time,Description) VALUES (5712254026,7512740948,3149785065,1340865491,'2023-10-25','8:34 PM','Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.');
INSERT INTO Maintenance(MaintenanceRecordID,DataScoopID,EmployeeID,ComponentID,Date,Time,Description) VALUES (1591676061,6661389753,3149785065,9177887166,'2023-07-03','7:21 AM','Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.');
INSERT INTO Maintenance(MaintenanceRecordID,DataScoopID,EmployeeID,ComponentID,Date,Time,Description) VALUES (5217974060,7512740948,3149785065,3479411169,'2024-02-12','4:43 PM','Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.');
INSERT INTO Maintenance(MaintenanceRecordID,DataScoopID,EmployeeID,ComponentID,Date,Time,Description) VALUES (3858774677,7758009573,3149785065,8193396421,'2024-02-17','9:22 PM','Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.');
INSERT INTO Maintenance(MaintenanceRecordID,DataScoopID,EmployeeID,ComponentID,Date,Time,Description) VALUES (4710219613,2209480213,7774743820,5834151221,'2024-05-13','3:13 PM','Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.');
INSERT INTO Maintenance(MaintenanceRecordID,DataScoopID,EmployeeID,ComponentID,Date,Time,Description) VALUES (8810335406,7977315815,7774743820,1719730539,'2024-02-28','12:13 PM','Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. sit amet lobortis sapien sapien non mi. Integer ac neque.');
INSERT INTO Maintenance(MaintenanceRecordID,DataScoopID,EmployeeID,ComponentID,Date,Time,Description) VALUES (5874401008,1714005984,7774743820,0054769663,'2024-04-10','6:06 PM','Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.');
INSERT INTO Maintenance(MaintenanceRecordID,DataScoopID,EmployeeID,ComponentID,Date,Time,Description) VALUES (0778323781,9924605381,7774743820,5834151221,'2023-08-29','3:53 PM','Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.');
INSERT INTO Maintenance(MaintenanceRecordID,DataScoopID,EmployeeID,ComponentID,Date,Time,Description) VALUES (7277638956,7758009573,1744270554,6483172508,'2023-09-26','7:18 PM','Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.');
INSERT INTO Maintenance(MaintenanceRecordID,DataScoopID,EmployeeID,ComponentID,Date,Time,Description) VALUES (3462682148,7262975579,1744270554,9629395940,'2024-01-03','11:39 AM','Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.');
INSERT INTO Maintenance(MaintenanceRecordID,DataScoopID,EmployeeID,ComponentID,Date,Time,Description) VALUES (7201527592,4253689175,2046627849,1920878173,'2024-04-25','2:26 AM','Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.');
INSERT INTO Maintenance(MaintenanceRecordID,DataScoopID,EmployeeID,ComponentID,Date,Time,Description) VALUES (3019391881,4193107868,2046627849,0119370042,'2023-12-19','11:44 AM','Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.');
INSERT INTO Maintenance(MaintenanceRecordID,DataScoopID,EmployeeID,ComponentID,Date,Time,Description) VALUES (3545093204,9924605381,6393089148,7030764676,'2024-03-04','3:21 PM','Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.');
GO

-- Stored Procedures

CREATE PROCEDURE CreateProcedures
AS
BEGIN
SET NOCOUNT ON;

-- Transaction A: SubscribeSubscription
	EXEC('
	CREATE PROCEDURE SubscribeSubscription
	(
		@EmployeeID VARCHAR(10),
		@SubscriptionID VARCHAR(10),
		@ClientNumber VARCHAR(10),
		@DisplayName VARCHAR(50),
		@Discount DECIMAL(4,2)
	)
	AS
	BEGIN
	SET NOCOUNT ON;
		INSERT INTO Subscription (SubscriptionID, EmployeeID, ClientNumber, DisplayName, Discount)
		VALUES (@SubscriptionID, @EmployeeID, @ClientNumber, @DisplayName, @Discount);
	END;
	');

-- Transaction B: SalesRepSubs
	EXEC('
	CREATE PROCEDURE SalesRepSubs
	AS
	BEGIN
	SET NOCOUNT ON;
		SELECT 
			e.FirstName + '' '' + e.LastName AS SalesRep,
			c.FirstName + '' '' + c.LastName AS Client,
			a.StreetName,
			a.StreetNumber,
			sb.DisplayName,
			sb.Discount
		FROM 
			SalesRepresentative sr
		JOIN 
			Employee e ON sr.EmployeeID = e.EmployeeID
		JOIN 
			Subscription sb ON sr.EmployeeID = sb.EmployeeID
		JOIN 
			Client c ON sb.ClientNumber = c.ClientNumber
		JOIN 
			Address a ON c.PostCode = a.PostCode
			AND c.StreetName = a.StreetName
			AND c.StreetNumber = a.StreetNumber;
	END;
	');

-- Transaction C: InsertScoopData
	EXEC('
	CREATE PROCEDURE InsertScoopData
	(
		@RecordID VARCHAR(10),
		@DataScoopID VARCHAR(10),
		@SubscriptionID VARCHAR(10),
		@Temperature DECIMAL(4,2),
		@Humidity INT,
		@AmbientLightStrength INT,
		@OrganicData VARCHAR(150),
		@Time TIME(7),
		@Longitude DECIMAL(9,6),
		@Latitude DECIMAL(8,6)
	)
	AS
	BEGIN
	SET NOCOUNT ON;
		INSERT INTO Data (RecordID, DataScoopID, SubscriptionID, Time, Temperature, OrganicData, AmbientLightStrength, Humidity)
		VALUES (@RecordID, @DataScoopID, @SubscriptionID, @Time, @Temperature, @OrganicData, @AmbientLightStrength, @Humidity);

		INSERT INTO Location (Longitude, Latitude, DataScoopID)
		VALUES (@Longitude, @Latitude, @DataScoopID);
	END;
	');

-- Transaction D: ScoopLocation
	EXEC('
	CREATE PROCEDURE ScoopLocation
	AS
	BEGIN
	SET NOCOUNT ON;
		SELECT c.OrganizationName AS Organization,
			l.Latitude,
			l.Longitude,
			ds.DataScoopID
		FROM "Contract" c
		JOIN DataScoop ds ON c.EmployeeID = ds.EmployeeID
		JOIN "Location" l ON ds.DataScoopID = l.DataScoopID;
	END;
	');

-- Transaction E: DataCollected
	EXEC('
	CREATE PROCEDURE DataCollected
	AS
	BEGIN
    SET NOCOUNT ON;
		SELECT c.OrganizationName AS ContractingOrganization,
			ds.DataScoopID,
			d.Temperature,
			d.Humidity,
			d.AmbientLightStrength,
			d.OrganicData
		FROM 
			"Contract" c
		JOIN 
			DataScoop ds ON c.EmployeeID = ds.EmployeeID
		JOIN 
			"Data" d ON ds.DataScoopID = d.DataScoopID;
	END;
	');

-- Transaction F: WatchingLiveStream
	EXEC('
	CREATE PROCEDURE WatchingLiveStream
	AS
	BEGIN
	SET NOCOUNT ON;
		SELECT 
			ds.DataScoopID AS DataScoopID,
			CONCAT(c.FirstName, '' '', c.LastName) AS Subscriber,
			ls.StreamID AS Stream
		FROM 
			DataScoop ds
		JOIN 
			LiveStream ls ON ds.DataScoopID = ls.DataScoopID
		JOIN 
			Subscription s ON ls.SubscriptionID = s.SubscriptionID
		JOIN 
			Client c ON s.ClientNumber = c.ClientNumber
		ORDER BY 
			ds.DataScoopID, Subscriber;
	END;
	');

-- Transaction G: SupplierPartsForScoop
	EXEC('
	CREATE PROCEDURE SupplierPartsForScoop
		@DataScoopID VARCHAR(10)
	AS
	BEGIN
	SET NOCOUNT ON;
		SELECT 
			s.SupplierName AS Supplier,
			dc.ComponentName AS Part
		FROM 
			DataScoop ds
		JOIN 
			ComponentPurchase c ON ds.DataScoopID = DataScoopID
		JOIN 
			DroneComponent dc ON c.ComponentID = dc.ComponentID
		JOIN 
			Supplier s ON c.SupplierID = s.SupplierID
		WHERE 
		ds.DataScoopID = @DataScoopID;
	END;
	');

-- Transaction H: UpdateScoopLocationZone
	EXEC('
	CREATE PROCEDURE UpdateScoopLocationZone
		@DataScoopID VARCHAR(10),
		@Latitude DECIMAL(8,6),
		@Longitude DECIMAL(9,6),
		@Climate VARCHAR(30),
		@ZoneID VARCHAR(10)
	AS
	BEGIN
	SET NOCOUNT ON;
		UPDATE Location
		SET Latitude = @Latitude,
			Longitude = @Longitude
		WHERE DataScoopID = @DataScoopID;

		IF EXISTS (SELECT 1 FROM Zone WHERE DataScoopID = @DataScoopID)
		BEGIN
			UPDATE Zone
			SET Climate = @Climate
			WHERE DataScoopID = @DataScoopID;
		END
		ELSE
		BEGIN
			INSERT INTO Zone (ZoneID, SubscriptionID, DataScoopID, Climate)
			VALUES (@ZoneID, 
			(SELECT SubscriptionID FROM DataScoop WHERE DataScoopID = @DataScoopID),
			@DataScoopID,
			@Climate);
		END;
	END;
	');

-- Transaction I: DeleteContract
	EXEC('
	CREATE PROCEDURE DeleteContract
		@ContractID VARCHAR(10)
	AS
	BEGIN
	SET NOCOUNT ON;
		BEGIN TRY
			BEGIN TRANSACTION;    
				DELETE FROM 
					"Contract"
				WHERE 
					ContractID = @ContractID;
				DELETE FROM 
					SuperPlatinum
				WHERE 
					SubscriptionID = @ContractID;
				COMMIT TRANSACTION;
		END TRY
		BEGIN CATCH
			IF @@TRANCOUNT > 0
				ROLLBACK TRANSACTION;
			PRINT ERROR_MESSAGE();
		END CATCH;
	END;
	');

-- Transaction J: ScoopPartsTotalCost
	EXEC('
	CREATE PROCEDURE ScoopPartsTotalCost
	AS
	BEGIN
	SET NOCOUNT ON;
		SELECT
			m.DataScoopID,
			SUM(c.Price) AS TotalCostOfParts
		FROM
			Maintenance m
		INNER JOIN
			DroneComponent c ON m.DataScoopID = DataScoopID
		GROUP BY
			m.DataScoopID;
	END;
	');
END;
GO

-- Create all procedures 

EXEC CreateProcedures;
GO

-- Transaction A

/*
EXEC SubscribeSubscription 
	@SubscriptionID = '102131213',
	@EmployeeID = '8448712579',
	@ClientNumber = '5368476426',
	@DisplayName = 'ccarcas0',
	@Discount = 10.00;
*/

-- Transaction B

-- EXEC SalesRepSubs;

-- Transaction C

/*
EXEC InsertScoopData
	@RecordID = 'abcteawe322',
    @DataScoopID = '2808699328',
    @SubscriptionID = '3451307561',
    @Temperature = 25.5,
    @Humidity = 60,
    @AmbientLightStrength = 500,
    @OrganicData = 'test data',
    @Time = '12:00:00',
    @Longitude = 40.123456,
    @Latitude = -79.987624;
*/

-- Transaction D

-- EXEC ScoopLocation;

-- Transaction E

-- EXEC DataCollected;

-- Transactionn F

-- EXEC WatchingLiveStream;

-- Transaction G

-- EXEC SupplierPartsForScoop @DataScoopID = '7977315815';

--Transacton H

/*
EXEC UpdateScoopLocationZone
	@DataScoopID = '1714005984',
	@Latitude = 37.774929,
	@Longitude = -122.419418,
	@Climate = 'test',
	@ZoneID = 'ABC123';
*/

-- Transaction I

-- EXEC DeleteContract '1132184232';

-- transaction J

-- EXEC ScoopPartsTotalCost;