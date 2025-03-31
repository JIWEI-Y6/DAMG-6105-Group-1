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