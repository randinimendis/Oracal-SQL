-- Create the Bank database
CREATE DATABASE BankDB;

-- Use the BankDB database
USE BankDB;

-- Create the Accounts table
CREATE TABLE Accounts (
    AccountNumber CHAR(10) PRIMARY KEY,
    Balance DECIMAL(10, 2) NOT NULL CHECK (Balance >= 0)
);

-- Insert initial account balances
INSERT INTO Accounts (AccountNumber, Balance) VALUES ('1234567899', 100.00);
INSERT INTO Accounts (AccountNumber, Balance) VALUES ('1234567898', 100.00);

-- Lab8.sql
SET XACT_ABORT ON;


DECLARE @sourceAcc CHAR(10) = '1234567899';
DECLARE @destAcc CHAR(10) = '1234567898';
DECLARE @fundsToTransfer DECIMAL(10, 2) = 150.00;

BEGIN TRANSACTION;

-- Credit the destination account first
UPDATE Accounts
SET Balance = Balance + @fundsToTransfer
WHERE AccountNumber = @destAcc;

-- Deduct from the source account
UPDATE Accounts
SET Balance = Balance - @fundsToTransfer
WHERE AccountNumber = @sourceAcc;

-- Check if the balance is valid
IF (SELECT Balance FROM Accounts WHERE AccountNumber = @sourceAcc) < 0
BEGIN
    ROLLBACK TRANSACTION;
    PRINT 'Transaction aborted: Insufficient funds.';
END
ELSE
BEGIN
    COMMIT TRANSACTION;
    PRINT 'Transaction completed successfully.';
END

-- Inputs for Simulation 1
DECLARE @sourceAcc CHAR(10) = '1234567899';
DECLARE @destAcc CHAR(10) = '1234567898';
DECLARE @fundsToTransfer DECIMAL(10, 2) = 150.00;


-- Load Lab8.sql and execute up to the first update statement
SET XACT_ABORT ON;


DECLARE @sourceAcc CHAR(10) = '1234567899';
DECLARE @destAcc CHAR(10) = '1234567898';
DECLARE @fundsToTransfer DECIMAL(10, 2) = 150.00;

BEGIN TRANSACTION;

-- Credit the destination account first
UPDATE Accounts
SET Balance = Balance + @fundsToTransfer
WHERE AccountNumber = @destAcc;

-- Deduct from the source account
UPDATE Accounts
SET Balance = Balance - @fundsToTransfer
WHERE AccountNumber = @sourceAcc;

-- Check if the balance is valid
IF (SELECT Balance FROM Accounts WHERE AccountNumber = @sourceAcc) < 0
BEGIN
    ROLLBACK TRANSACTION;
    PRINT 'Transaction aborted: Insufficient funds.';
END
ELSE
BEGIN
    COMMIT TRANSACTION;
    PRINT 'Transaction completed successfully.';
END

SELECT * FROM Accounts;

-- Deduct from the source account
UPDATE Accounts
SET Balance = Balance - @fundsToTransfer
WHERE AccountNumber = @sourceAcc;

-- Check if the balance is valid
IF (SELECT Balance FROM Accounts WHERE AccountNumber = @sourceAcc) < 0
BEGIN
    ROLLBACK TRANSACTION;
    PRINT 'Transaction aborted: Insufficient funds.';
END
ELSE
BEGIN
    COMMIT TRANSACTION;
    PRINT 'Transaction completed successfully.';
END

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
BEGIN TRANSACTION;

UPDATE Accounts
SET Balance = Balance + 50.00
WHERE AccountNumber = '1234567898';

WAITFOR DELAY '00:00:10'; -- Introduce a delay to simulate deadlock
UPDATE Accounts
SET Balance = Balance - 50.00
WHERE AccountNumber = '1234567899';

COMMIT TRANSACTION;