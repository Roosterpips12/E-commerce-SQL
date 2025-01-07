-- Sample test data for E-commerce system

-- Insert Categories
INSERT INTO Categories (Name, Description) VALUES
('Electronics', 'Electronic devices and accessories'),
('Clothing', 'Fashion items and accessories'),
('Books', 'Books and digital content'),
('Home', 'Home and garden items');

-- Insert Products
INSERT INTO Products (SKU, Name, Description, Price, Category, StockQuantity, MinStockLevel) VALUES
('ELEC001', 'Smartphone X', 'Latest smartphone model', 999.99, 'Electronics', 50, 10),
('ELEC002', 'Laptop Pro', 'Professional laptop', 1299.99, 'Electronics', 30, 5),
('CLOTH001', 'Cotton T-Shirt', 'Comfortable cotton t-shirt', 29.99, 'Clothing', 100, 20),
('CLOTH002', 'Jeans Classic', 'Classic blue jeans', 59.99, 'Clothing', 80, 15),
('BOOK001', 'Programming 101', 'Programming guidebook', 49.99, 'Books', 60, 10),
('HOME001', 'Coffee Maker', 'Automatic coffee maker', 79.99, 'Home', 40, 8);

-- Insert Customers
INSERT INTO Customers (Email, Password, FirstName, LastName, Phone) VALUES
('john.doe@email.com', 'hashed_password_1', 'John', 'Doe', '1234567890'),
('jane.smith@email.com', 'hashed_password_2', 'Jane', 'Smith', '0987654321'),
('bob.wilson@email.com', 'hashed_password_3', 'Bob', 'Wilson', '5555555555');

-- Insert Addresses
INSERT INTO Addresses (CustomerID, AddressType, Street, City, State, PostalCode, Country, IsDefault) VALUES
(1, 'Shipping', '123 Main St', 'New York', 'NY', '10001', 'USA', TRUE),
(1, 'Billing', '123 Main St', 'New York', 'NY', '10001', 'USA', TRUE),
(2, 'Shipping', '456 Oak Ave', 'Los Angeles', 'CA', '90001', 'USA', TRUE),
(2, 'Billing', '456 Oak Ave', 'Los Angeles', 'CA', '90001', 'USA', TRUE);

-- Insert Orders
INSERT INTO Orders (CustomerID, ShippingAddressID, BillingAddressID, TotalAmount, Status, PaymentStatus) VALUES
(1, 1, 2, 1029.98, 'Delivered', 'Paid'),
(2, 3, 4, 139.98, 'Processing', 'Paid');

-- Insert Order Items
INSERT INTO OrderItems (OrderID, ProductID, Quantity, UnitPrice, Subtotal) VALUES
(1, 1, 1, 999.99, 999.99),
(1, 3, 1, 29.99, 29.99),
(2, 3, 2, 29.99, 59.98),
(2, 6, 1, 79.99, 79.99);

-- Insert Shopping Cart Items
INSERT INTO ShoppingCart (CustomerID, ProductID, Quantity) VALUES
(3, 2, 1),
(3, 4, 2);

-- Insert Product Reviews
INSERT INTO ProductReviews (ProductID, CustomerID, Rating, Comment) VALUES
(1, 1, 5, 'Great smartphone, very satisfied!'),
(3, 2, 4, 'Good quality t-shirt, fits well'),
(6, 1, 5, 'Excellent coffee maker, works perfectly');

-- Insert Order Tracking
INSERT INTO OrderTracking (OrderID, Status, Location) VALUES
(1, 'Delivered', 'Customer address'),
(2, 'In Transit', 'Local distribution center');

-- Create sample stock alert
INSERT INTO StockAlerts (ProductID, CurrentStock, MinimumStock)
SELECT ProductID, StockQuantity, MinStockLevel
FROM Products
WHERE StockQuantity <= MinStockLevel;
