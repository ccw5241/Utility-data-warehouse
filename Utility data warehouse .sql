CREATE DATABASE Utility;
USE Utility;

Create table DimResident(AccountNumber varchar(255) not null,
LastName varchar(255),
FirstName varchar(255),
Street varchar(255),
Apt varchar(255),
Zip varchar(255),
Phone varchar(255),
WaterMeter varchar(255),
ElectricityMeter varchar(255)
CONSTRAINT DimResident_PK PRIMARY KEY (AccountNumber));


CREATE TABLE DimDate(Date Datetime, 
                      Year INT, 
					  Month INT, 
					  Day INT, 
					  WeekDayValue INT, 
					  MonthValueName VARCHAR(20),
					  WeekDayValueName VARCHAR(20),
CONSTRAINT DimDate_PK PRIMARY KEY (Date));

  DECLARE @StartDate DATE = '2017-01-01';
  DECLARE @EndDate DATE = '2018-12-31';
  WHILE @StartDate <= @EndDate
  BEGIN
	INSERT INTO  DimDate(Date,
	                     Year, 
						 Month, 
						 Day, 
						 WeekDayValue, 
						 MonthValueName,
						 WeekDayValueName )
	VALUES(@StartDate,
	        DATEPART(YY, @StartDate),
			DATEPART(mm, @StartDate),
			DATEPART(dd, @StartDate), 
			DATEPART(dw, @StartDate), 
			DATENAME(mm, @StartDate),
			DATENAME(dw, @StartDate))
	
	SET @StartDate = DATEADD(dd, 1, @StartDate)
  END;

Create table FactElectricityBill(CycleID INT NOT NULL,
AccountNumber varchar(255),
CycleDate datetime,
Rate float,
ElectricityUsage float,
UsageFee float,
PayDate datetime,
AmountPay float,
AmountDue float,
CONSTRAINT FactElectricityBill_PK PRIMARY KEY (CycleID),
CONSTRAINT FactElectricityBill_FK1 Foreign Key (CycleDate) references DimDate(Date),
CONSTRAINT FactElectricityBill_FK2 Foreign Key (PayDate) references DimDate(Date),
CONSTRAINT FactElectricityBill_FK3 Foreign Key (AccountNumber) references DimResident(AccountNumber));

BULK
INSERT FactElectricityBill
FROM 'C:\Users\zj6362\Desktop\Final\ElectricityBills\BillingCycles.txt'
WITH
(
FIRSTROW = 2,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n'
)
GO

Create table FactWaterBill(BillingID INT NOT NULL,
AccountNumber varchar(255),
BillingDate datetime,
Rate float,
WaterUsage float,
BillingFee float,
PayDate datetime,
AmountPaid float,
AmountDue float,
Audited int,
CONSTRAINT FactWaterBill_PK PRIMARY KEY (BillingID),
CONSTRAINT FactWaterBill_FK1 Foreign Key (BillingDate) references DimDate(Date),
CONSTRAINT FactWaterBill_FK2 Foreign Key (PayDate) references DimDate(Date),
CONSTRAINT FactWaterBill_FK3 Foreign Key (AccountNumber) references DimResident(AccountNumber));

BULK
INSERT FactWaterBill
FROM 'C:\Users\zj6362\Desktop\Final\WaterBills\WaterBills.txt'
WITH
(
FIRSTROW = 2,
FIELDTERMINATOR = ',',
ROWTERMINATOR = '\n'
)
GO

select * from FactElectricityBill;
select * from FactWaterBill;
select * from DimResident;
select * from DimDate;
