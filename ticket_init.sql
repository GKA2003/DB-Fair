-- ticket_init.sql
-- SQL script to create and populate tables for the Online Ticket Booking System

CREATE DATABASE IF NOT EXISTS TicketBookingDB;
USE TicketBookingDB;

-- Drop tables if they already exist
DROP TABLE IF EXISTS BookingVoucher, BookingTicket, PaymentDetails, Payment, Booking, TicketType, Voucher, Event, Customer;

-- Creating tables
CREATE TABLE Customer (
    customerID INT AUTO_INCREMENT PRIMARY KEY,
    fName VARCHAR(100),
    lName VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(20)
);


CREATE TABLE Event (
    eventID INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    description TEXT,
    venue VARCHAR(100),
    startTime DATETIME,
    endTime DATETIME 
);


CREATE TABLE TicketType (
    ticketTypeID INT AUTO_INCREMENT PRIMARY KEY,
    eventID INT,
    type VARCHAR(50),
    price DECIMAL(10, 2),
    quantityAvailable INT,
    minAge INT,
    maxAge INT,
    FOREIGN KEY (eventID) REFERENCES Event(eventID)
);

CREATE TABLE Booking (
    bookingID INT AUTO_INCREMENT PRIMARY KEY,
    customerID INT,
    totalAmount DECIMAL(10, 2),
    deliveryMethod VARCHAR(50),
    bookingStatus VARCHAR(50),
    FOREIGN KEY (customerID) REFERENCES Customer(customerID)
);

CREATE TABLE Payment (
    paymentID INT AUTO_INCREMENT PRIMARY KEY,
    bookingID INT,
    paymentStatus VARCHAR(50),
    FOREIGN KEY (bookingID) REFERENCES Booking(bookingID)
);

CREATE TABLE PaymentDetails (
    paymentDetailsID INT AUTO_INCREMENT PRIMARY KEY,
    customerID INT,
    cardType VARCHAR(50),
    cardNumber VARCHAR(20),
    securityID VARCHAR(5),
    expiryDate DATE,
    FOREIGN KEY (customerID) REFERENCES Customer(customerID)
);

CREATE TABLE Voucher (
    voucherID INT AUTO_INCREMENT PRIMARY KEY,
    eventID INT,
    voucherCODE VARCHAR(50),
    discountAmount DECIMAL(10, 2),
    FOREIGN KEY (eventID) REFERENCES Event(eventID)
);

CREATE TABLE BookingTicket (
    bookingID INT,
    ticketTypeID INT,
    ticketQuantity INT,
    PRIMARY KEY (bookingID, ticketTypeID),
    FOREIGN KEY (bookingID) REFERENCES Booking(bookingID),
    FOREIGN KEY (ticketTypeID) REFERENCES TicketType(ticketTypeID)
);

CREATE TABLE BookingVoucher (
    bookingID INT,
    voucherID INT,
    PRIMARY KEY (bookingID, voucherID),
    FOREIGN KEY (bookingID) REFERENCES Booking(bookingID),
    FOREIGN KEY (voucherID) REFERENCES Voucher(voucherID)
);

-- Populate tables with initial data
-- Insert data into Customer
INSERT INTO Customer (fName, lName, email, phone) VALUES 
('John', 'Doe', 'john.doe@example.com', '555-1234'),
('Joe', 'Smiths', 'joe.smiths@example.com', '555-5678'),
('Emily', 'Jones', 'emily.jones@example.com', '555-9101'),
('Ian', 'Cooper', 'ian.cooper@example.com', '555-6789');

-- Insert data into Event
INSERT INTO Event (name, description, venue, startTime, endTime) VALUES 
('Exeter Food Festival 2023', 'An outdoor summer food festival.', 'Exeter', '2023-07-01 00:00:00', '2023-07-10 23:59:59'),
('Exmouth Music Festival 2023', 'Annual music fair for all ages.', 'Exmouth', '2024-08-15 09:00:00', '2024-08-16 17:00:00'),
('Exeter Food Festival 2023', 'A lot of food.', 'Exeter', '2024-09-20 20:00:00', '2024-09-20 23:00:00');

-- Insert data into TicketType
INSERT INTO TicketType (eventID, type, price, quantityAvailable, minAge, maxAge) VALUES 
(1, 'Adult', 59.99, 200, 16, NULL),
(1, 'Child', 29.99, 100, 5, 15),
(2, 'Adult', 50.00, 150, 16, NULL),
(2, 'Child', 25.00, 150, 5, 15),
(2, 'Bronze', 45.00, 150, 3, NULL),
(2, 'Bronze', 55.00, 150, 3, NULL),
(2, 'Gold', 75.00, 100, NULL, NULL);

-- Insert data into Booking
INSERT INTO Booking (customerID, totalAmount, deliveryMethod, bookingStatus) VALUES 
(1, 119.98, 'Email', 'Confirmed'),
(2, 30.00, 'Pick-up', 'Confirmed'),
(3, 40.00, 'Email', 'Cancelled'),
(1, 150.00, 'Email', 'Confirmed');

-- Insert data into Payment
INSERT INTO Payment (bookingID, paymentStatus) VALUES 
(1, 'Paid'),
(3, 'Pending');

-- Insert data into PaymentDetails
INSERT INTO PaymentDetails (customerID, cardType, cardNumber, securityID, expiryDate) VALUES 
(1, 'Visa', '4111111111111111', '123', '2027-10-31'),
(2, 'MasterCard', '5500000000000004', '456', '2029-04-30');

-- Insert data into Voucher
INSERT INTO Voucher (eventID, voucherCode, discountAmount) VALUES 
(1, 'FOOD10', 0.10),
(3, 'FOOD10', 0.10);

-- Insert data into BookingTicket
INSERT INTO BookingTicket (bookingID, ticketTypeID, ticketQuantity) VALUES 
(1, 1, 2),
(2, 5, 2),
(3, 4, 2),
(4, 7, 2);

-- Insert data into BookingVoucher
INSERT INTO BookingVoucher (bookingID, voucherID) VALUES 
(1, 1),
(3, 2);

