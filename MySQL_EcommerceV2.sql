-- Creating a database for E-commerce
CREATE DATABASE IF NOT EXISTS modFis_Ecommerce;
USE modFis_Ecommerce;
DROP DATABASE IF EXISTS modFis_Ecommerce;
SET FOREIGN_KEY_CHECKS=0;
SET FOREIGN_KEY_CHECKS=1;

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
  PixKey ENUM('cpf', 'phone', 'email', 'randomkey') NOT NULL,
  Boleto FLOAT,
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

-- Relationship Table between Deliveries and Orders
CREATE TABLE IF NOT EXISTS DeliveryOrder (
  Delivery_idDelivery INT NOT NULL,
  Order_idOrder INT NOT NULL,
  PRIMARY KEY (Delivery_idDelivery, Order_idOrder),
  FOREIGN KEY (Delivery_idDelivery) REFERENCES Delivery (idDelivery),
  FOREIGN KEY (Order_idOrder) REFERENCES Order (idOrder)
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

-- Products Table
CREATE TABLE IF NOT EXISTS Product (
  idProduct INT NOT NULL AUTO_INCREMENT,
  Category ENUM('electronics', 'clothing', 'appliances', 'Kids') NOT NULL,
  Description VARCHAR(45),
  Value FLOAT NOT NULL,
  ShortName VARCHAR(20),
  Code VARCHAR(20),
  PRIMARY KEY (idProduct)
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

-- Suppliers Table
CREATE TABLE IF NOT EXISTS Supplier (
  idSupplier INT NOT NULL AUTO_INCREMENT,
  LegalName VARCHAR(45),
  CNPJ CHAR(14) NOT NULL,
  Location VARCHAR(45),
  Contact CHAR(11) NOT NULL,
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
CREATE TABLE IF NOT EXISTS Order (
  idOrder INT NOT NULL AUTO_INCREMENT,
  OrderStatus ENUM('In progress', 'In process', 'Shipped', 'Delivered') NULL DEFAULT 'In process',
  Description VARCHAR(45),
  Client_idClient INT NOT NULL,
  ShippingCost FLOAT,
  PRIMARY KEY (idOrder),
  FOREIGN KEY (Client_idClient) REFERENCES Client (idClient)
);

-- Relationship Table between Products and Orders
CREATE TABLE IF NOT EXISTS ProductOrder (
  id INT NOT NULL AUTO_INCREMENT,
  Product_idProduct INT NOT NULL,
  Order_idOrder INT NOT NULL,
  Quantity INT NOT NULL,
  Status ENUM('available', 'out of stock') NULL DEFAULT 'available',
  PRIMARY KEY (id),
  FOREIGN KEY (Product_idProduct) REFERENCES Product (idProduct),
  FOREIGN KEY (Order_idOrder) REFERENCES Order (idOrder)
);
