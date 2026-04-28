CREATE DATABASE danhGiaNangLuc1;
USE danhGiaNangLuc1;

CREATE TABLE Properties (
    property_id VARCHAR(5) PRIMARY KEY NOT NULL, 
    property_name VARCHAR(100) UNIQUE NOT NULL, 
    location VARCHAR(100) NOT NULL, 
    price_per_night DECIMAL(10,2) NOT NULL, 
    status VARCHAR(20) NOT NULL
);
-- Bảng Guests 
CREATE TABLE Guests (
    guest_id VARCHAR(5) PRIMARY KEY NOT NULL,
    full_name VARCHAR(100) NOT NULL, 
    email VARCHAR(100) UNIQUE NOT NULL, 
    phone VARCHAR(15) NOT NULL,
    guest_type VARCHAR(50) NOT NULL
);
-- Bảng Bookings 
CREATE TABLE Bookings (
    booking_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    property_id VARCHAR(5) NOT NULL, 
    guest_id VARCHAR(5) NOT NULL, 
    check_in_date DATE NOT NULL, 
    check_out_date DATE NOT NULL, 
    total_price DECIMAL(10,2),
    FOREIGN KEY (property_id) REFERENCES Properties(property_id),
    FOREIGN KEY (guest_id) REFERENCES Guests(guest_id)
);
-- Bảng Services 
CREATE TABLE Services (
    service_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT, 
    booking_id INT NOT NULL, 
    service_name VARCHAR(100) NOT NULL, 
    service_fee DECIMAL(10,2) NOT NULL, 
    service_date DATE NOT NULL, 
    FOREIGN KEY (booking_id) REFERENCES Bookings(booking_id)
);
-- Thêm ràng buộc unique
ALTER TABLE Bookings
ADD CONSTRAINT add_unique UNIQUE (property_id, check_in_date);
-- Chèn dữ liệu 
INSERT INTO Properties (property_id, property_name, location, price_per_night, status) VALUES
('P01', 'Sunrise Villa', 'Đà Lạt', 2000000, 'Available'),
('P02', 'Ocean View Apartment', 'Đà Nẵng', 1500000, 'Booked'),
('P03', 'Green Garden Homestay', 'Hà Nội', 800000, 'Available'),
('P04', 'Mountain Retreat', 'Sa Pa', 1200000, 'Booked'),
('P05', 'City Central Studio', 'TP HCM', 1000000, 'Maintenance');

INSERT INTO Guests (guest_id, full_name, email, phone, guest_type) VALUES
('G01', 'Nguyễn Văn Nam', 'nam.nv@gmail.com', '0912345678', 'VIP'),
('G02', 'Trần Thị Lan', 'lan.tt@gmail.com', '0987654321', 'Regular'),
('G03', 'Lê Minh Quang', 'quang.lm@gmail.com', '0978123456', 'Member'),
('G04', 'Phạm Bảo Châu', 'chau.pb@gmail.com', '0909876543', 'Regular'),
('G05', 'Hoàng Anh Đức', 'duc.ha@gmail.com', '0911222333', 'VIP');

INSERT INTO Bookings (booking_id, property_id, guest_id, check_in_date, check_out_date, total_price) VALUES
(1, 'P01', 'G01', '2025-11-01', '2025-11-05', 8000000),
(2, 'P02', 'G02', '2025-11-10', '2025-11-12', 3000000),
(3, 'P03', 'G03', '2025-11-15', '2025-11-16', 800000),
(4, 'P04', 'G01', '2025-11-20', '2025-11-25', 6000000),
(5, 'P01', 'G04', '2025-12-01', '2025-12-05', 8000000),
(6, 'P02', 'G05', '2025-12-10', '2025-12-15', 7500000);

INSERT INTO Services (service_id, booking_id, service_name, service_fee, service_date) VALUES
(1, 1, 'Ăn sáng', 200000, '2025-11-02'),
(2, 1, 'Giặt là', 100000, '2025-11-03'),
(3, 2, 'Thuê xe máy', 150000, '2025-11-11'),
(4, 4, 'Ăn sáng', 200000, '2025-11-21');
-- 4
UPDATE Properties
SET price_per_night = price_per_night * 1.1
WHERE property_id = 'P01';

-- 5
UPDATE Guests
SET guest_type = 'Member'
WHERE guest_id = 'G02';

-- 6
DELETE FROM Services
WHERE service_fee < 150000;

-- 7
ALTER TABLE Properties
ADD CONSTRAINT price_per_night1 CHECK (price_per_night > 0);

-- 8
ALTER TABLE Properties
ALTER COLUMN status SET DEFAULT 'Available';
-- 9
ALTER TABLE Properties
ADD COLUMN rating INT;
ALTER TABLE Properties
ADD CONSTRAINT CHK_RatingRange CHECK (status BETWEEN 1 AND 5);

-- PHẦN 2: Truy vấn dữ liệu cơ bản
-- 10
SELECT *
FROM Properties
WHERE price_per_night BETWEEN 1000000 AND 2000000;

-- 11
SELECT full_name, email
FROM Guests
WHERE full_name LIKE '%n%';

-- 12
SELECT property_id, property_name, location
FROM Properties
ORDER BY price_per_night ASC;

-- 13
SELECT *
FROM Bookings
ORDER BY total_price DESC
LIMIT 3;

-- 14
SELECT property_name, location
FROM Properties
LIMIT 3 OFFSET 1;

-- 15
UPDATE Bookings
SET total_price = total_price * 0.95
WHERE check_in_date < '2025-11-15'; 

-- 16
UPDATE Properties
SET location = UPPER(location);

-- 17
DELETE FROM Guests
WHERE guest_id NOT IN (
    SELECT DISTINCT guest_id
    FROM Bookings
);

-- PHẦN 3: Truy vấn dữ liệu nâng cao
-- 18
SELECT
    B.booking_id,
    G.full_name,
    P.property_name,
    B.check_in_date
FROM Bookings B
INNER JOIN Guests G 
ON B.guest_id = G.guest_id
JOIN Properties P 
ON B.property_id = P.property_id
WHERE G.guest_type = 'VIP';

-- 19
SELECT
    P.property_name,
    COUNT(B.booking_id) AS total_bookings
FROM Properties P
LEFT JOIN Bookings B 
ON P.property_id = B.property_id 
GROUP BY P.property_name
ORDER BY total_bookings DESC, P.property_name ASC;

-- 20
SELECT
    P.location,
    SUM(B.total_price) AS total_revenue
FROM Bookings B
INNER JOIN Properties P
ON B.property_id = P.property_id
GROUP BY P.location
ORDER BY total_revenue DESC;

-- 21
SELECT
    P.property_name,
    COUNT(DISTINCT B.guest_id) AS distinct_guest_count
FROM Properties P
INNER JOIN Bookings B 
ON P.property_id = B.property_id
GROUP BY P.property_name
HAVING distinct_guest_count >= 2
ORDER BY distinct_guest_count DESC;

-- 22
SELECT
    property_name,
    price_per_night
FROM Properties
WHERE price_per_night > (
    SELECT AVG(price_per_night) 
    FROM Properties
)
ORDER BY price_per_night DESC;

-- 23
SELECT DISTINCT
    G.full_name
FROM Guests G
JOIN Bookings B
ON G.guest_id = B.guest_id
JOIN Services S 
ON B.booking_id = S.booking_id
WHERE S.service_name = 'Ăn sáng';
