-- Drop and recreate the database
DROP DATABASE IF EXISTS MTRS;
GO

CREATE DATABASE MTRS;
GO

USE MTRS;
GO

CREATE TABLE Users (
    User_ID INT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Email VARCHAR(255) UNIQUE NOT NULL,
    Phone_Number VARCHAR(20),
    Password VARCHAR(255) NOT NULL,
    Address VARCHAR(255)
);

CREATE TABLE Movies (
    Movie_ID INT PRIMARY KEY,
    Title VARCHAR(255) NOT NULL,
    Genre VARCHAR(100),
    Language VARCHAR(100),
    Rating DECIMAL(3, 1) CHECK (Rating >= 0 AND Rating <= 10),
    Duration DECIMAL(5, 2),
    Description VARCHAR(1000)
);

CREATE TABLE Theaters (
    Theater_ID INT PRIMARY KEY,
    Theater_Name VARCHAR(255) NOT NULL,
    Address VARCHAR(255),
    Capacity INT CHECK (Capacity > 0),
    Contact_Information VARCHAR(255)
);

CREATE TABLE Shows (
    Show_ID INT PRIMARY KEY,
    Movie_ID INT,
    Theater_ID INT,
    Show_Time TIME NOT NULL,
    Show_Date DATE NOT NULL,
    Ticket_Price DECIMAL(10, 2) CHECK (Ticket_Price > 0),
    FOREIGN KEY (Movie_ID) REFERENCES Movies(Movie_ID),
    FOREIGN KEY (Theater_ID) REFERENCES Theaters(Theater_ID)
);

CREATE TABLE Seats (
    Seat_ID INT PRIMARY KEY,
    Show_ID INT,
    Seat_Number VARCHAR(10) NOT NULL,
    Status CHAR(1) CHECK (Status IN ('A', 'B')),
    FOREIGN KEY (Show_ID) REFERENCES Shows(Show_ID)
);

CREATE TABLE Saved_Payments (
    Saved_Payment_ID INT PRIMARY KEY,
    User_ID INT,
    Card_Last_4_Digits VARCHAR(4) NOT NULL,
    Payment_Method VARCHAR(50),
    Billing_Address VARCHAR(255),
    FOREIGN KEY (User_ID) REFERENCES Users(User_ID)
);

CREATE TABLE Search_History (
    Search_ID INT PRIMARY KEY,
    User_ID INT,
    Search_Query VARCHAR(255) NOT NULL,
    Search_Date DATE NOT NULL,
    FOREIGN KEY (User_ID) REFERENCES Users(User_ID)
);

CREATE TABLE Notifications (
    Notification_ID INT PRIMARY KEY,
    User_ID INT,
    Message VARCHAR(255) NOT NULL,
    FOREIGN KEY (User_ID) REFERENCES Users(User_ID)
);

CREATE TABLE Reviews (
    Review_ID INT PRIMARY KEY,
    User_ID INT,
    Movie_ID INT,
    Rating DECIMAL(3, 1) CHECK (Rating >= 0 AND Rating <= 10),
    Comment VARCHAR(1000),
    FOREIGN KEY (User_ID) REFERENCES Users(User_ID),
    FOREIGN KEY (Movie_ID) REFERENCES Movies(Movie_ID)
);

CREATE TABLE Discounts (
    Discount_ID INT PRIMARY KEY,
    Discount_Name VARCHAR(255) NOT NULL,
    Discount_Percentage DECIMAL(5, 2) CHECK (Discount_Percentage >= 0 AND Discount_Percentage <= 100),
    Start_Date DATE NOT NULL,
    End_Date DATE NOT NULL
);

CREATE TABLE Bookings (
    Booking_ID INT PRIMARY KEY,
    User_ID INT,
    Show_ID INT,
    Booking_Date DATE NOT NULL,
    Payment_Status VARCHAR(20) CHECK (Payment_Status IN ('Pending', 'Completed', 'Canceled')),
    Total_Amount DECIMAL(10, 2),
    Discount_ID INT,
    FOREIGN KEY (User_ID) REFERENCES Users(User_ID),
    FOREIGN KEY (Show_ID) REFERENCES Shows(Show_ID),
    FOREIGN KEY (Discount_ID) REFERENCES Discounts(Discount_ID)
);

CREATE TABLE Booked_Seats (
    Booking_ID INT,
    Seat_ID INT,
    PRIMARY KEY (Booking_ID, Seat_ID),
    FOREIGN KEY (Booking_ID) REFERENCES Bookings(Booking_ID),
    FOREIGN KEY (Seat_ID) REFERENCES Seats(Seat_ID)
);

CREATE TABLE Payments (
    Payment_ID INT PRIMARY KEY,
    Booking_ID INT,
    Payment_Date DATE NOT NULL,
    Payment_Amount DECIMAL(10, 2) CHECK (Payment_Amount > 0),
    Payment_Status VARCHAR(20) CHECK (Payment_Status IN ('Success', 'Failed', 'Refunded')),
    Payment_Method VARCHAR(50),
    FOREIGN KEY (Booking_ID) REFERENCES Bookings(Booking_ID)
);




INSERT INTO Users (User_ID, Name, Email, Phone_Number, Password, Address) VALUES
(1, 'Alice Smith', 'alice.smith@gmail.com', '123-456-7890', 'P@ssw0rd123!', '123 Main St'),
(2, 'Bob Johnson', 'bob.johnson@yahoo.com', '234-567-8901', 'B0bSecureP@ss!', '456 Elm St'),
(3, 'Charlie Brown', 'charlie.brown@hotmail.com', '345-678-9012', 'Ch@rlie_567!', '789 Oak St'),
(4, 'Diana Prince', 'diana.prince@gmail.com', '456-789-0123', 'WonderW0m@n!', '321 Pine St'),
(5, 'Ethan Hunt', 'ethan.hunt@outlook.com', '567-890-1234', 'M1ssionP@ssible!', '654 Maple St'),
(6, 'Frank Castle', 'frank.castle@gmail.com', '678-901-2345', 'Pun1sh3rSecure!', '987 Cedar St'),
(7, 'Grace Hopper', 'grace.hopper@yahoo.com', '789-012-3456', 'Gr@ceC0d3r!', '654 Birch St'),
(8, 'Hank Pym', 'hank.pym@icloud.com', '890-123-4567', 'AntM@nLab!', '321 Walnut St'),
(9, 'Ivy Watson', 'ivy.watson@gmail.com', '901-234-5678', 'Sherl0ck123!', '111 Redwood St'),
(10, 'Jack Ryan', 'jack.ryan@protonmail.com', '012-345-6789', 'CI@_Clandestine!', '222 Magnolia St');


INSERT INTO Movies (Movie_ID, Title, Genre, Language, Rating, Duration, Description) VALUES
(1, 'The Matrix', 'Action', 'English', 8.7, 136.0, 'A computer hacker learns about the true nature of reality.'),
(2, 'Inception', 'Sci-Fi', 'English', 8.8, 148.0, 'A thief who steals corporate secrets through the use of dream-sharing technology.'),
(3, 'Parasite', 'Drama', 'Korean', 8.6, 132.0, 'A poor family schemes to become employed by a rich family.'),
(4, 'Spirited Away', 'Animation', 'Japanese', 8.6, 125.0, 'A young girl navigates a world of spirits and gods.'),
(5, 'Interstellar', 'Sci-Fi', 'English', 8.6, 169.0, 'A team of explorers travels through a wormhole in space.'),
(6, 'The Dark Knight', 'Action', 'English', 9.0, 152.0, 'A vigilante fights crime in Gotham City.'),
(7, 'Avatar', 'Sci-Fi', 'English', 7.9, 162.0, 'Humans colonize an alien planet.'),
(8, 'Titanic', 'Romance', 'English', 7.8, 195.0, 'A love story aboard a doomed ship.'),
(9, 'The Lion King', 'Animation', 'English', 8.5, 88.0, 'A young lion learns his true destiny.'),
(10, 'Joker', 'Drama', 'English', 8.4, 122.0, 'The origin story of Gotham’s clown prince of crime.');

INSERT INTO Theaters (Theater_ID, Theater_Name, Address, Capacity, Contact_Information) VALUES
(1, 'Screen 1', '123 Cinema Street, Boston, MA', 150, '555-0101'),
(2, 'Screen 2', '123 Cinema Street, Boston, MA', 180, '555-0102'),
(3, 'Screen 3', '123 Cinema Street, Boston, MA', 120, '555-0103'),
(4, 'Screen 4', '123 Cinema Street, Boston, MA', 200, '555-0104'),
(5, 'Screen 5', '123 Cinema Street, Boston, MA', 170, '555-0105'),
(6, 'Screen 6', '123 Cinema Street, Boston, MA', 100, '555-0106'),
(7, 'Screen 7', '123 Cinema Street, Boston, MA', 220, '555-0107'),
(8, 'Screen 8', '123 Cinema Street, Boston, MA', 250, '555-0108'),
(9, 'Screen 9', '123 Cinema Street, Boston, MA', 300, '555-0109'),
(10, 'Screen 10', '123 Cinema Street, Boston, MA', 275, '555-0110');


INSERT INTO Shows (Show_ID, Movie_ID, Theater_ID, Show_Time, Show_Date, Ticket_Price) VALUES
(1, 1, 1, '18:00:00', '2023-08-01', 10.00),
(2, 2, 1, '20:30:00', '2023-08-01', 12.00),
(3, 3, 2, '19:00:00', '2023-08-02', 9.00),
(4, 4, 3, '17:00:00', '2023-08-02', 11.00),
(5, 1, 2, '21:00:00', '2023-08-03', 10.00),
(6, 5, 4, '19:30:00', '2023-08-04', 11.00),
(7, 6, 5, '20:00:00', '2023-08-05', 13.00),
(8, 7, 6, '18:45:00', '2023-08-06', 12.00),
(9, 8, 7, '21:00:00', '2023-08-07', 14.00),
(10, 9, 1, '19:15:00', '2023-08-08', 10.50);


INSERT INTO Seats (Seat_ID, Show_ID, Seat_Number, Status) VALUES
(1, 1, 'A1', 'A'),
(2, 1, 'A2', 'A'),
(3, 1, 'A3', 'B'),
(4, 2, 'B1', 'A'),
(5, 2, 'B2', 'A'),
(6, 6, 'C1', 'A'),
(7, 6, 'C2', 'B'),
(8, 7, 'D1', 'A'),
(9, 7, 'D2', 'A'),
(10, 8, 'E1', 'B');

INSERT INTO Saved_Payments (Saved_Payment_ID, User_ID, Card_Last_4_Digits, Payment_Method, Billing_Address) VALUES
(1, 1, '1234', 'Visa', '123 Main St'),
(2, 2, '5678', 'MasterCard', '456 Elm St'),
(3, 3, '9101', 'PayPal', '789 Oak St'),
(4, 4, '2345', 'Visa', '101 Maple St'),
(5, 5, '6789', 'Debit Card', '567 Pine St'),
(6, 6, '3456', 'Apple Pay', '303 Cedar St'),
(7, 7, '7890', 'Google Pay', '505 Birch St'),
(8, 8, '4321', 'Visa', '707 Willow St'),
(9, 9, '8765', 'MasterCard', '909 Cherry St'),
(10, 10, '5432', 'Cryptocurrency', '111 Peach St');

INSERT INTO Search_History (Search_ID, User_ID, Search_Query, Search_Date) VALUES
(1, 1, 'latest action movies', '2023-07-29'),
(2, 2, 'best sci-fi films', '2023-07-30'),
(3, 3, 'family-friendly movies', '2023-08-01'),
(4, 4, 'new horror releases', '2023-08-02'),
(5, 5, 'top romantic comedies', '2023-08-03'),
(6, 6, 'classic crime movies', '2023-08-04'),
(7, 7, 'fantasy movie suggestions', '2023-08-05'),
(8, 8, 'historical dramas', '2023-08-06'),
(9, 9, 'movies based on true stories', '2023-08-07'),
(10, 10, 'animated films for kids', '2023-08-08');

INSERT INTO Notifications (Notification_ID, User_ID, Message) VALUES
(1, 1, 'Your booking for "The Matrix" is confirmed.'),
(2, 2, 'New movies are available this week!'),
(3, 3, 'Don��t miss your next showtime!'),
(4, 4, 'Special discount available on your next booking.'),
(5, 5, 'Reminder: Your booking for "Interstellar" is tomorrow.'),
(6, 6, 'Your payment was successful for "Inception".'),
(7, 7, 'Flash Sale: 20% off on all shows today!'),
(8, 8, 'New horror movies added this weekend.'),
(9, 9, 'Your refund for "The Joker" has been processed.'),
(10, 10, 'Enjoy exclusive behind-the-scenes content!');

INSERT INTO Reviews (Review_ID, User_ID, Movie_ID, Rating, Comment) VALUES
(1, 1, 1, 9.0, 'Amazing special effects and a gripping story.'),
(2, 2, 2, 8.5, 'A thought-provoking and beautifully made film.'),
(3, 3, 3, 8.0, 'A unique take on class division.'),
(4, 4, 4, 7.5, 'Good but not as good as expected.'),
(5, 5, 5, 9.2, 'Loved the soundtrack and cinematography.'),
(6, 6, 6, 8.8, 'A must-watch for sci-fi fans.'),
(7, 7, 7, 7.9, 'Solid performances and engaging story.'),
(8, 8, 8, 8.6, 'Great character development.'),
(9, 9, 9, 6.5, 'It was okay, but a bit slow.'),
(10, 10, 10, 9.5, 'Masterpiece! Highly recommended.');

INSERT INTO Discounts (Discount_ID, Discount_Name, Discount_Percentage, Start_Date, End_Date) VALUES
(1, 'Summer Special', 10.00, '2023-06-01', '2023-08-31'),
(2, 'Student Discount', 15.00, '2023-07-01', '2023-12-31'),
(3, 'Weekend Deal', 20.00, '2023-08-01', '2023-08-31'),
(4, 'Early Bird Offer', 5.00, '2023-09-01', '2023-12-31'),
(5, 'Loyalty Bonus', 12.00, '2023-07-15', '2023-10-15'),
(6, 'Senior Citizen Discount', 18.00, '2023-06-01', '2023-12-31'),
(7, 'Buy 1 Get 1 Free', 50.00, '2023-08-10', '2023-08-20'),
(8, 'Holiday Special', 25.00, '2023-12-01', '2023-12-31'),
(9, 'Flash Sale', 30.00, '2023-08-05', '2023-08-07'),
(10, 'Member Exclusive', 10.00, '2023-06-15', '2023-12-31');

INSERT INTO Bookings (Booking_ID, User_ID, Show_ID, Booking_Date, Payment_Status, Total_Amount, Discount_ID) VALUES
(1, 1, 1, '2023-07-30', 'Completed', 20.00, NULL),
(2, 2, 3, '2023-07-30', 'Pending', 18.00, NULL),
(3, 3, 2, '2023-07-31', 'Canceled', 30.00, 1),
(4, 4, 1, '2023-08-01', 'Completed', 25.00, 2),
(5, 5, 4, '2023-08-02', 'Completed', 22.50, NULL),
(6, 6, 5, '2023-08-03', 'Pending', 15.00, 1),
(7, 7, 6, '2023-08-04', 'Completed', 28.00, NULL),
(8, 8, 3, '2023-08-05', 'Completed', 35.00, 2),
(9, 9, 7, '2023-08-06', 'Canceled', 40.00, NULL),
(10, 10, 8, '2023-08-07', 'Completed', 19.00, 1);

INSERT INTO Booked_Seats (Booking_ID, Seat_ID) VALUES
(1, 3),
(2, 6),
(3, 1),
(4, 7),
(5, 8),
(6, 2),
(7, 4),
(8, 5),
(9, 9),
(10, 10);

INSERT INTO Payments (Payment_ID, Booking_ID, Payment_Date, Payment_Amount, Payment_Status, Payment_Method) VALUES
(1, 1, '2023-07-30', 20.00, 'Success', 'Credit Card'),
(2, 2, '2023-07-30', 18.00, 'Success', 'PayPal'),
(3, 4, '2023-08-01', 25.00, 'Success', 'Debit Card'),
(4, 5, '2023-08-02', 22.50, 'Success', 'Apple Pay'),
(5, 6, '2023-08-03', 15.00, 'Failed', 'Google Pay'),
(6, 7, '2023-08-04', 28.00, 'Success', 'Visa'),
(7, 8, '2023-08-05', 35.00, 'Success', 'MasterCard'),
(8, 10, '2023-08-07', 19.00, 'Success', 'Credit Card'),
(9, 3, '2023-07-31', 30.00, 'Refunded', 'Bank Transfer'),
(10, 9, '2023-08-06', 40.00, 'Failed', 'Cryptocurrency');


