-- ticket_update.sql

-- Query 1: Increase the amount of Adult tickets for the Exeter Food Festival by 100

UPDATE TicketType
SET quantityAvailable = quantityAvailable + 100
WHERE eventID IN (SELECT eventID FROM Event WHERE name = 'Exeter Food Festival 2023')
  AND type = 'Adult';

-- Query 2: Ian Cooper books tickets for the Exeter Food Festival

-- Insert a new booking for Ian Cooper
INSERT INTO Booking (customerID, totalAmount, deliveryMethod, bookingStatus) 
VALUES (4, 0, 'Email', 'Confirmed');

SET @lastBookingID = LAST_INSERT_ID();

INSERT INTO BookingTicket (bookingID, ticketTypeID, ticketQuantity) VALUES
(@lastBookingID, 1, 2), -- 2 Adult tickets
(@lastBookingID, 2, 1); -- 1 Child ticket

-- Apply the voucher 'FOOD10'
INSERT INTO BookingVoucher (bookingID, voucherID) VALUES 
(@lastBookingID, (SELECT voucherID FROM Voucher WHERE voucherCode = 'FOOD10' AND eventID = 1));

SET @adultTicketPrice = (SELECT price FROM TicketType WHERE ticketTypeID = 1);
SET @childTicketPrice = (SELECT price FROM TicketType WHERE ticketTypeID = 2);
SET @voucherDiscount = (SELECT discountAmount FROM Voucher WHERE voucherCode = 'FOOD10' AND eventID = 1);
SET @totalAmount = ROUND((2 * @adultTicketPrice + @childTicketPrice) * (1 - @voucherDiscount), 2);

UPDATE Booking
SET totalAmount = @totalAmount
WHERE bookingID = @lastBookingID;

INSERT INTO Payment (bookingID, paymentStatus) 
VALUES (@lastBookingID, 'Paid');


-- Query 3: Cancel Joe Smith's booking

UPDATE Booking b
JOIN BookingTicket bt ON b.bookingID = bt.bookingID
JOIN TicketType tt ON bt.ticketTypeID = tt.ticketTypeID
JOIN Event e ON tt.eventID = e.eventID
SET b.bookingStatus = 'Cancelled'
WHERE b.bookingID = 2 AND e.endTime > CURRENT_TIMESTAMP AND
      b.customerID = (SELECT customerID FROM Customer WHERE email = 'joe.smiths@example.com');
      
-- Query 4: Add a new voucher code for the Exmouth Music Festival 2023

INSERT INTO Voucher (eventID, voucherCode, discountAmount) VALUES
(2, 'SUMMER20', 0.20);