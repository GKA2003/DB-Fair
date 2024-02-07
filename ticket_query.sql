-- ticket_query.sql

-- Query 1: List all relevant information about festivals with Adult and Child tickets
SELECT 
    e.name AS FestivalName,
    e.description AS Description,
    e.venue AS Venue,
    e.startTime AS StartTime,
    e.endTime AS EndTime,
    SUM(CASE WHEN t.type = 'Adult' THEN t.quantityAvailable ELSE 0 END) AS TotalAdultTickets,
    SUM(CASE WHEN t.type = 'Child' THEN t.quantityAvailable ELSE 0 END) AS TotalChildTickets
FROM 
    Event e
JOIN 
    TicketType t ON e.eventID = t.eventID
WHERE 
    e.name LIKE '%Exeter Food Festival 2023%'
GROUP BY 
    e.eventID;
    
-- Query 2: Find all the events in a specific location within a date range
SELECT 
    name AS EventTitle,
    startTime AS StartingTime,
    endTime AS EndTime,
    description
FROM 
    Event
WHERE 
    venue = 'Exeter' AND
    startTime >= '2023-07-01 00:00:00' AND 
    endTime <= '2023-07-10 23:59:59';
    
-- Query 3: List available amount and price for Bronze tickets for festivals

SELECT 
    tt.quantityAvailable AS AvailableAmount,
    tt.price AS Price
FROM 
    TicketType tt
JOIN 
    Event e ON tt.eventID = e.eventID
WHERE 
    tt.type = 'Bronze' AND
    e.name LIKE '%Exmouth Music Festival 2023%';

-- Query 4: List all customers who have booked Gold tickets for the Exmouth Music Festival 2023

SELECT 
    c.fName,
    c.lName,
    SUM(bt.ticketQuantity) AS NumberOfGoldTickets
FROM 
    Customer c
JOIN 
    Booking b ON c.customerID = b.customerID
JOIN 
    BookingTicket bt ON b.bookingID = bt.bookingID
JOIN 
    TicketType tt ON bt.ticketTypeID = tt.ticketTypeID
JOIN 
    Event e ON tt.eventID = e.eventID
WHERE 
    tt.type = 'Gold' AND
    e.name = 'Exmouth Music Festival 2023'
GROUP BY 
    c.customerID;

-- Query 5: List all event names and the number of tickets sold for each event

SELECT 
    e.name AS EventName,
    SUM(bt.ticketQuantity) AS TicketsSold
FROM 
    Event e
JOIN 
    TicketType tt ON e.eventID = tt.eventID
JOIN 
    BookingTicket bt ON tt.ticketTypeID = bt.ticketTypeID
GROUP BY 
    e.eventID
ORDER BY 
    TicketsSold DESC;
    
-- Query 6: Retrieve all relevant information for a given booking ID

SELECT 
    c.fName,
    c.lName,
    b.bookingID,
    b.totalAmount AS TotalPayment,
    b.deliveryMethod,
    b.bookingStatus,
    e.name AS EventTitle,
    tt.type AS TicketType,
    bt.ticketQuantity,
    p.paymentStatus
FROM 
    Booking b
LEFT JOIN Customer c ON b.customerID = c.customerID
LEFT JOIN BookingTicket bt ON b.bookingID = bt.bookingID
LEFT JOIN TicketType tt ON bt.ticketTypeID = tt.ticketTypeID
LEFT JOIN Event e ON tt.eventID = e.eventID
LEFT JOIN Payment p ON b.bookingID = p.bookingID
WHERE 
    b.bookingID = 1;

-- Query 7: Find the event with the maximum income and list its title and total income

SELECT 
    e.name AS EventTitle,
    SUM(tt.price * bt.ticketQuantity) AS TotalIncome
FROM 
    Event e
JOIN 
    TicketType tt ON e.eventID = tt.eventID
JOIN 
    BookingTicket bt ON tt.ticketTypeID = bt.ticketTypeID
GROUP BY 
    e.eventID
ORDER BY 
    TotalIncome DESC
LIMIT 1;
