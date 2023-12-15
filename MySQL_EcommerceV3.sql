-- Creating a database for E-commerce
CREATE DATABASE IF NOT EXISTS modFis_Ecommerce;
USE modFis_Ecommerce;

-- Drop existing tables (if any)
DROP TABLE IF EXISTS DeliveryOrder, ProductOrder, ProductStock, Supplier, ProductSupplier, ProductSeller, Product, Stock, Delivery, ClientPayment, PaymentMethod, Client;

-- Clients Table
CREATE TABLE IF NOT EXISTS Client (
 idClient INT NOT NULL AUTO_INCREMENT,
 Name VARCHAR(50) NOT NULL,
 ClientType ENUM('Individual', 'Legal Entity') NOT NULL,
 Identification VARCHAR(45) NOT NULL,
 Address VARCHAR(100),
 Contact VARCHAR(45),
 BirthDate DATE,
 PRIMARY KEY (idClient),
 UNIQUE (Identification)
);

-- Payment Methods Table
CREATE TABLE IF NOT EXISTS PaymentMethod (
 idPaymentMethod INT NOT NULL AUTO_INCREMENT,
 Type ENUM('Credit', 'Debit', 'Two cards') NOT NULL,
 PixKey VARCHAR(20) NOT NULL,
 Boleto VARCHAR(255), -- Adjusted data type
 PRIMARY KEY (idPaymentMethod)
);

-- Relationship Table between Clients and Payment Methods
CREATE TABLE IF NOT EXISTS ClientPayment (
 id INT NOT NULL AUTO_INCREMENT,
 Client_idClient INT NOT NULL,
 PaymentMethod_idPaymentMethod INT NOT NULL,
 PRIMARY KEY (id),
 FOREIGN KEY (Client_idClient) REFERENCES Client (idClient),
 FOREIGN KEY (PaymentMethod_idPaymentMethod) REFERENCES PaymentMethod (idPaymentMethod)
);

-- Deliveries Table
CREATE TABLE IF NOT EXISTS Delivery (
 idDelivery INT NOT NULL AUTO_INCREMENT,
 Status ENUM('Approved', 'Declined', 'In process') NOT NULL,
 TrackingCode VARCHAR(45),
 PRIMARY KEY (idDelivery)
);

-- Create the Orders table first
CREATE TABLE IF NOT EXISTS Orders (
    idOrder INT NOT NULL AUTO_INCREMENT,
    -- Other columns for the Orders table
    PRIMARY KEY (idOrder)
);

-- Then create the DeliveryOrder table
CREATE TABLE IF NOT EXISTS DeliveryOrder (
    Delivery_idDelivery INT NOT NULL,
    Order_idOrder INT NOT NULL,
    PRIMARY KEY (Delivery_idDelivery, Order_idOrder),
    FOREIGN KEY (Delivery_idDelivery) REFERENCES Delivery (idDelivery),
    FOREIGN KEY (Order_idOrder) REFERENCES Orders (idOrder)
);


-- Sellers Table
CREATE TABLE IF NOT EXISTS Seller (
 idSeller INT NOT NULL AUTO_INCREMENT,
 Name VARCHAR(50) NOT NULL,
 SellerType ENUM('Individual', 'Legal Entity') NOT NULL,
 Identification VARCHAR(45) NOT NULL,
 Contact VARCHAR(45),
 PRIMARY KEY (idSeller),
 UNIQUE (Identification)
);

-- Products Table
CREATE TABLE IF NOT EXISTS Product (
 idProduct INT NOT NULL AUTO_INCREMENT,
 Category ENUM('electronics', 'clothing', 'appliances', 'Kids') NOT NULL,
 Description VARCHAR(45),
 Value DECIMAL(10, 2) NOT NULL,
 ShortName VARCHAR(20),
 Code VARCHAR(20),
 PRIMARY KEY (idProduct)
);

-- Relationship Table between Products and Sellers
CREATE TABLE IF NOT EXISTS ProductSeller (
 id INT NOT NULL AUTO_INCREMENT,
 Product_idProduct INT NOT NULL,
 Seller_idSeller INT NOT NULL,
 Quantity INT,
 PRIMARY KEY (id),
 FOREIGN KEY (Product_idProduct) REFERENCES Product (idProduct),
 FOREIGN KEY (Seller_idSeller) REFERENCES Seller (idSeller)
);

-- Suppliers Table
CREATE TABLE IF NOT EXISTS Supplier (
 idSupplier INT NOT NULL AUTO_INCREMENT,
 LegalName VARCHAR(45),
 CNPJ VARCHAR(14) NOT NULL,
 Location VARCHAR(45),
 Contact VARCHAR(11) NOT NULL,
 TradeName VARCHAR(45),
 PRIMARY KEY (idSupplier),
 UNIQUE (CNPJ),
 UNIQUE (LegalName)
);

-- Stock Table
CREATE TABLE IF NOT EXISTS Stock (
 idStock INT NOT NULL AUTO_INCREMENT,
 Location VARCHAR(45) NOT NULL,
 PRIMARY KEY (idStock)
);

-- Relationship Table between Products and Suppliers
CREATE TABLE IF NOT EXISTS ProductSupplier (
 id INT NOT NULL AUTO_INCREMENT,
 Product_idProduct INT NOT NULL,
 Supplier_idSupplier INT NOT NULL,
 Quantity INT,
 PRIMARY KEY (id),
 FOREIGN KEY (Product_idProduct) REFERENCES Product (idProduct),
 FOREIGN KEY (Supplier_idSupplier) REFERENCES Supplier (idSupplier)
);

-- Relationship Table between Products and Stocks
CREATE TABLE IF NOT EXISTS ProductStock (
 id INT NOT NULL AUTO_INCREMENT,
 Product_idProduct INT NOT NULL,
 Stock_idStock INT NOT NULL,
 Location VARCHAR(100),
 PRIMARY KEY (id),
 FOREIGN KEY (Product_idProduct) REFERENCES Product (idProduct),
 FOREIGN KEY (Stock_idStock) REFERENCES Stock (idStock)
);

-- Orders Table
CREATE TABLE IF NOT EXISTS Orders (
 idOrder INT NOT NULL AUTO_INCREMENT,
 OrderStatus ENUM('In progress', 'In process', 'Shipped', 'Delivered') DEFAULT 'In process', -- Adjusted default value
 Description VARCHAR(45),
 Client_idClient INT NOT NULL,
 ShippingCost DECIMAL(10, 2),
 PRIMARY KEY (idOrder),
 FOREIGN KEY (Client_idClient) REFERENCES Client (idClient)
);

-- Relationship Table between Products and Orders
CREATE TABLE IF NOT EXISTS ProductOrder (
 id INT NOT NULL AUTO_INCREMENT,
 Product_idProduct INT NOT NULL,
 Order_idOrder INT NOT NULL,
 Quantity INT NOT NULL,
 Status ENUM('available', 'out of stock') DEFAULT 'available', -- Adjusted default value
 PRIMARY KEY (id),
 FOREIGN KEY (Product_idProduct) REFERENCES Product (idProduct),
 FOREIGN KEY (Order_idOrder) REFERENCES Orders (idOrder)
);

-- Insert data into Client table
INSERT INTO Client (Name, ClientType, Identification, Address, Contact, BirthDate)
VALUES
 ('John Doe', 'Individual', '123456789', '123 Main St', '555-1234', '1990-01-01'),
 ('ABC Corp', 'Legal Entity', '789012345', '456 Business Ave', '555-5678', NULL);

-- Insert data into PaymentMethod table
INSERT INTO PaymentMethod (Type, PixKey, Boleto)
VALUES
 ('Credit', 'john.doe@example.com', '5.00'), -- Adjusted value
 ('Debit', 'john.doe@bank', NULL),
 ('Two cards', 'john.doe@example.com', '2.50'); -- Adjusted value

-- Insert data into ClientPayment table
INSERT INTO ClientPayment (Client_idClient, PaymentMethod_idPaymentMethod)
VALUES
 (1, 1),
 (2, 2),
 (1, 3);

-- Insert data into Delivery table
INSERT INTO Delivery (Status, TrackingCode)
VALUES
 ('Approved', 'ABC123'),
 ('In process', 'XYZ789');

-- Insert data into DeliveryOrder table
INSERT INTO DeliveryOrder (Delivery_idDelivery, Order_idOrder)
VALUES
 (1, 1),
 (2, 2);

-- Insert data into Seller table
INSERT INTO Seller (Name, SellerType, Identification, Contact)
VALUES
 ('Seller 1', 'Individual', 'S123', '555-1111'),
 ('Seller 2', 'Legal Entity', 'S456', '555-2222');

-- Insert data into Product table
INSERT INTO Product (Category, Description, Value, ShortName, Code)
VALUES
 ('electronics', 'Smartphone', '500.00', 'Phone1', 'P001'), -- Adjusted value
 ('clothing', 'T-Shirt', '20.00', 'Shirt1', 'P002'); -- Adjusted value

-- Insert data into ProductSeller table
INSERT INTO ProductSeller (Product_idProduct, Seller_idSeller, Quantity)
VALUES
 (1, 1, 100),
 (2, 2, 50);

-- Insert data into Supplier table
INSERT INTO Supplier (LegalName, CNPJ, Location, Contact, TradeName)
VALUES
 ('Supplier 1', '12345678901234', 'Supplier Location 1', '123-4567', 'Trade Supplier 1'),
 ('Supplier 2', '98765432109876', 'Supplier Location 2', '987-6543', 'Trade Supplier 2');

-- Insert data into Stock table
INSERT INTO Stock (Location)
VALUES
 ('Stock Location 1'),
 ('Stock Location 2');

-- Insert data into ProductSupplier table
INSERT INTO ProductSupplier (Product_idProduct, Supplier_idSupplier, Quantity)
VALUES
 (1, 1, 50),
 (2, 2, 30);

-- Insert data into ProductStock table
INSERT INTO ProductStock (Product_idProduct, Stock_idStock, Location)
VALUES
 (1, 1, 'Stock Location 1'),
 (2, 2, 'Stock Location 2');

-- Insert data into Orders table
INSERT INTO Orders (OrderStatus, Description, Client_idClient, ShippingCost)
VALUES
 ('In process', 'Order 1', 1, '10.00'), -- Adjusted value
 ('Shipped', 'Order 2', 2, '15.00'); -- Adjusted value

-- Insert data into ProductOrder table
INSERT INTO ProductOrder (Product_idProduct, Order_idOrder, Quantity, Status)
VALUES
 (1, 1, 2, 'available'),
 (2, 2, 1, 'available');

-- Retrieves all clients
SELECT * FROM Client;

-- Retrieves all products
SELECT * FROM Product;

-- Retrieve clients of the Legal Entity type
SELECT * FROM Client WHERE ClientType = 'Legal Entity';

-- Retrieve orders in progress
SELECT * FROM Orders WHERE OrderStatus = 'In process';

-- Calculates the total for each order
SELECT idOrder, SUM(Value * Quantity) AS Total
FROM Orders
JOIN ProductOrder ON Orders.idOrder = ProductOrder.Order_idOrder
JOIN Product ON ProductOrder.Product_idProduct = Product.idProduct
GROUP BY idOrder;

-- Retrieves products sorted by value in descending order
SELECT * FROM Product ORDER BY Value DESC;

-- Recover customers who placed more than 3 orders
SELECT Client_idClient, COUNT(*) AS NumOrders
FROM Orders
GROUP BY Client_idClient
HAVING NumOrders > 3;

-- Retrieves the products, their suppliers, and the quantity in stock
SELECT Product.ShortName, Supplier.LegalName, ProductStock.Quantity
FROM Product
JOIN ProductSupplier ON Product.idProduct = ProductSupplier.Product_idProduct
JOIN Supplier ON ProductSupplier.Supplier_idSupplier = Supplier.idSupplier
JOIN ProductStock ON Product.idProduct = ProductStock.Product_idProduct;
