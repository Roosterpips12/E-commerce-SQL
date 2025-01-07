-- Main tables for E-commerce system

-- Products table
CREATE TABLE Products (
    ProductID INT PRIMARY KEY AUTO_INCREMENT,
    SKU VARCHAR(50) UNIQUE NOT NULL,
    Name VARCHAR(200) NOT NULL,
    Description TEXT,
    Price DECIMAL(10,2) NOT NULL,
    DiscountPrice DECIMAL(10,2),
    Category VARCHAR(100),
    SubCategory VARCHAR(100),
    Brand VARCHAR(100),
    StockQuantity INT NOT NULL DEFAULT 0,
    MinStockLevel INT DEFAULT 10,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Customers table
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Password VARCHAR(255) NOT NULL,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Phone VARCHAR(20),
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    LastLogin TIMESTAMP,
    Status ENUM('Active', 'Inactive', 'Blocked') DEFAULT 'Active'
);

-- Addresses table
CREATE TABLE Addresses (
    AddressID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT,
    AddressType ENUM('Billing', 'Shipping') NOT NULL,
    Street VARCHAR(255) NOT NULL,
    City VARCHAR(100) NOT NULL,
    State VARCHAR(100) NOT NULL,
    PostalCode VARCHAR(20) NOT NULL,
    Country VARCHAR(100) NOT NULL,
    IsDefault BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- Orders table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT,
    OrderDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Status ENUM('Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled') DEFAULT 'Pending',
    ShippingAddressID INT,
    BillingAddressID INT,
    TotalAmount DECIMAL(10,2) NOT NULL,
    ShippingCost DECIMAL(10,2) DEFAULT 0.00,
    TaxAmount DECIMAL(10,2) DEFAULT 0.00,
    PaymentStatus ENUM('Pending', 'Paid', 'Failed', 'Refunded') DEFAULT 'Pending',
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (ShippingAddressID) REFERENCES Addresses(AddressID),
    FOREIGN KEY (BillingAddressID) REFERENCES Addresses(AddressID)
);

-- Order Items table
CREATE TABLE OrderItems (
    OrderItemID INT PRIMARY KEY AUTO_INCREMENT,
    OrderID INT,
    ProductID INT,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,
    Subtotal DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Shopping Cart table
CREATE TABLE ShoppingCart (
    CartID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT,
    ProductID INT,
    Quantity INT NOT NULL,
    AddedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Product Reviews table
CREATE TABLE ProductReviews (
    ReviewID INT PRIMARY KEY AUTO_INCREMENT,
    ProductID INT,
    CustomerID INT,
    Rating INT NOT NULL CHECK (Rating >= 1 AND Rating <= 5),
    Comment TEXT,
    ReviewDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- Product Categories table
CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    ParentCategoryID INT,
    Description TEXT,
    FOREIGN KEY (ParentCategoryID) REFERENCES Categories(CategoryID)
);

-- Order Tracking table
CREATE TABLE OrderTracking (
    TrackingID INT PRIMARY KEY AUTO_INCREMENT,
    OrderID INT,
    Status VARCHAR(50) NOT NULL,
    Location VARCHAR(255),
    UpdateDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- Stored Procedure for placing an order
DELIMITER //
CREATE PROCEDURE PlaceOrder(
    IN p_CustomerID INT,
    IN p_ShippingAddressID INT,
    IN p_BillingAddressID INT
)
BEGIN
    DECLARE v_OrderID INT;
    DECLARE v_TotalAmount DECIMAL(10,2);
    
    -- Calculate total from shopping cart
    SELECT SUM(p.Price * sc.Quantity)
    INTO v_TotalAmount
    FROM ShoppingCart sc
    JOIN Products p ON sc.ProductID = p.ProductID
    WHERE sc.CustomerID = p_CustomerID;
    
    -- Create order
    INSERT INTO Orders (CustomerID, ShippingAddressID, BillingAddressID, TotalAmount)
    VALUES (p_CustomerID, p_ShippingAddressID, p_BillingAddressID, v_TotalAmount);
    
    SET v_OrderID = LAST_INSERT_ID();
    
    -- Transfer items from cart to order
    INSERT INTO OrderItems (OrderID, ProductID, Quantity, UnitPrice, Subtotal)
    SELECT 
        v_OrderID,
        sc.ProductID,
        sc.Quantity,
        p.Price,
        (p.Price * sc.Quantity)
    FROM ShoppingCart sc
    JOIN Products p ON sc.ProductID = p.ProductID
    WHERE sc.CustomerID = p_CustomerID;
    
    -- Clear shopping cart
    DELETE FROM ShoppingCart WHERE CustomerID = p_CustomerID;
    
    -- Update product stock
    UPDATE Products p
    JOIN OrderItems oi ON p.ProductID = oi.ProductID
    SET p.StockQuantity = p.StockQuantity - oi.Quantity
    WHERE oi.OrderID = v_OrderID;
END //
DELIMITER ;

-- Trigger for stock level notification
DELIMITER //
CREATE TRIGGER CheckStockLevel
AFTER UPDATE ON Products
FOR EACH ROW
BEGIN
    IF NEW.StockQuantity <= NEW.MinStockLevel THEN
        INSERT INTO StockAlerts (ProductID, CurrentStock, MinimumStock)
        VALUES (NEW.ProductID, NEW.StockQuantity, NEW.MinStockLevel);
    END IF;
END //
DELIMITER ;
