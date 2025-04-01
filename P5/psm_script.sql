USE MTRS;
GO

CREATE PROCEDURE GetUserDetails 
    @UserID INT,
    @UserEmail VARCHAR(255) OUTPUT
AS
BEGIN
    SELECT @UserEmail = Email 
    FROM Users
    WHERE User_ID = @UserID;
    DECLARE @UserName VARCHAR(255), @UserPhone VARCHAR(20);
    
    SELECT @UserName = Name, @UserPhone = Phone_Number
    FROM Users
    WHERE User_ID = @UserID;
END;
GO

CREATE PROCEDURE UpdateMovieRating 
    @MovieID INT,
    @NewRating DECIMAL(3, 1)
AS
BEGIN
    UPDATE Movies
    SET Rating = @NewRating
    WHERE Movie_ID = @MovieID;
END;
GO

CREATE PROCEDURE GetTotalBookingsForMovie 
    @MovieID INT,
    @TotalBookings INT OUTPUT
AS
BEGIN
    SELECT @TotalBookings = COUNT(*)
    FROM Bookings
    WHERE Show_ID IN (SELECT Show_ID FROM Shows WHERE Movie_ID = @MovieID);
END;
GO

CREATE FUNCTION GetDiscountedPrice(@OriginalPrice DECIMAL(10, 2), @DiscountID INT)
RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @DiscountRate DECIMAL(5, 2);
    SELECT @DiscountRate = Discount_Percentage FROM Discounts WHERE Discount_ID = @DiscountID;
    RETURN @OriginalPrice * (1 - @DiscountRate / 100);
END;
GO

CREATE FUNCTION GetUserFullName(@UserID INT)
RETURNS VARCHAR(255)
AS
BEGIN
    DECLARE @FullName VARCHAR(255);
    SELECT @FullName = Name FROM Users WHERE User_ID = @UserID;
    RETURN @FullName;
END;
GO

CREATE FUNCTION AvailableSeatsForShow(@ShowID INT)
RETURNS INT
AS
BEGIN
    RETURN (SELECT COUNT(*) FROM Seats WHERE Show_ID = @ShowID AND Status = 'A');
END;
GO

CREATE VIEW UserBookingDetails AS
SELECT u.Name, b.Booking_ID, s.Show_Time, m.Title
FROM Users u
JOIN Bookings b ON u.User_ID = b.User_ID
JOIN Shows s ON b.Show_ID = s.Show_ID
JOIN Movies m ON s.Movie_ID = m.Movie_ID;
GO

CREATE VIEW AvailableSeats AS
SELECT s.Seat_Number, m.Title, sh.Show_Time
FROM Seats s
JOIN Shows sh ON s.Show_ID = sh.Show_ID
JOIN Movies m ON sh.Movie_ID = m.Movie_ID 
WHERE s.Status = 'A';
GO

CREATE VIEW MovieRatings AS
SELECT m.Title, AVG(r.Rating) AS AvgRating
FROM Reviews r
JOIN Movies m ON r.Movie_ID = m.Movie_ID 
GROUP BY m.Title;
GO

CREATE TRIGGER trgAfterBookingUpdate
ON Bookings
AFTER UPDATE
AS
BEGIN
    INSERT INTO BookingLogs (Booking_ID, ChangedOn, ChangeType)
    SELECT Booking_ID, GETDATE(), 'UPDATE'
    FROM INSERTED;
END;
GO