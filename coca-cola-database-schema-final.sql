CREATE TABLE SUPPLIER_T
(
SupplierID INTEGER not null,
 SupplierName VARCHAR2(25) not null,
 SupplierAddress VARCHAR2(25) not null,
 SupplierInfo VARCHAR2(50) null,
 CONSTRAINT Supplier_PK PRIMARY KEY (SupplierID)
);

CREATE TABLE PO_T
(
 PO_ID INTEGER not null,
 PO_Name VARCHAR2(25) not null,
 PO_Date DATE not null,
 SupplierID INTEGER not null,
 CONSTRAINT PO_PK PRIMARY KEY (PO_ID),
 CONSTRAINT PO_FK FOREIGN KEY (SupplierID) REFERENCES Supplier_T(SupplierID)
);

CREATE TABLE INVOICE_T
(
 InvoiceID INTEGER not null,
 PO_ID INTEGER not null,
 InvoiceDate DATE not null,
 Price NUMERIC not null,
 CONSTRAINT Invoice_PK PRIMARY KEY (InvoiceID),
 CONSTRAINT Invoice_FK FOREIGN KEY (PO_ID) REFERENCES PO_T (PO_ID)
);

CREATE TABLE RM_T
(
 RM_ID INTEGER not null,
 PO_ID INTEGER not null,
 RMname VARCHAR2(25) not null,
 SupplierID INTEGER not null,
 CONSTRAINT RM_PK PRIMARY KEY (RM_ID),
 CONSTRAINT RM_FK1 FOREIGN KEY (PO_ID) REFERENCES PO_T (PO_ID),
 CONSTRAINT RM_FK2 FOREIGN KEY (SupplierID) REFERENCES SUPPLIER_T (SupplierID)
);

CREATE TABLE PO_DETAIL_T
(
 PO_ID INTEGER not null,
 RM_ID INTEGER not null,
 Quantity NUMERIC not null,
 CONSTRAINT PO_DETAIL_PK PRIMARY KEY (PO_ID, RM_ID),
 CONSTRAINT PO_DETAIL_FK1 FOREIGN KEY (PO_ID) REFERENCES PO_T (PO_ID),
 CONSTRAINT PO_DETAIL_FK2 FOREIGN KEY (RM_ID) REFERENCES RM_T (RM_ID)
);

CREATE TABLE MANUFACTURE_T
(
 ManufactureID INTEGER not null,
 EmployeeID INTEGER not null,
 SiteAddress VARCHAR2(25) not null,
 CONSTRAINT MANUFACTURE_PK PRIMARY KEY (ManufactureID)
);

CREATE TABLE WAREHOUSE_T
(
 WarehouseID INTEGER not null,
Capacity NUMERIC not null,
 WH_Location VARCHAR2(25) not null,
 CONSTRAINT WAREHOUSE_PK PRIMARY KEY (WarehouseID)
);

CREATE TABLE EMPLOYEE_T
(
 EmployeeID INTEGER not null,
EmployeeName VARCHAR2(25) not null,
 EmpLocation VARCHAR2(25) not null,
 ManufactureID INTEGER null,
 WarehouseID INTEGER null,
 CONSTRAINT EMPLOYEE_PK PRIMARY KEY (EmployeeID),
 CONSTRAINT EMPLOYEE_FK1 FOREIGN KEY (ManufactureID) REFERENCES MANUFACTURE_T
(ManufactureID),
 CONSTRAINT EMPLOYEE_FK2 FOREIGN KEY (WarehouseID) REFERENCES WAREHOUSE_T
(WarehouseID)
);

CREATE TABLE RM_DETAIL_T
(
 RM_ID INTEGER not null,
 ManufactureID INTEGER not null,
 Quantity NUMERIC not null,
 CONSTRAINT RM_DETAIL_PK PRIMARY KEY (RM_ID, ManufactureID),
 CONSTRAINT RM_DETAIL_FK1 FOREIGN KEY (RM_ID) REFERENCES RM_T (RM_ID),
 CONSTRAINT RM_DETAIL_FK2 FOREIGN KEY (ManufactureID) REFERENCES MANUFACTURE_T
(ManufactureID)
);

CREATE TABLE FG_T
(
 FG_ID INTEGER not null,
FG_Type VARCHAR2(25) not null,
 Quantity NUMERIC not null,
 WarehouseID INTEGER not null,
 CONSTRAINT FG_PK PRIMARY KEY (FG_ID),
 CONSTRAINT FG_FK FOREIGN KEY (WarehouseID) REFERENCES WAREHOUSE_T (WarehouseID)
);

CREATE TABLE RECIPE_T
(
 RM_ID INTEGER not null,
 FG_ID INTEGER not null,
 Quantity NUMERIC not null,
 CONSTRAINT RECIPE_PK PRIMARY KEY (RM_ID, FG_ID),
 CONSTRAINT RECIPE_FK1 FOREIGN KEY (RM_ID) REFERENCES RM_T (RM_ID),
 CONSTRAINT RECIPE_FK2 FOREIGN KEY (FG_ID) REFERENCES FG_T (FG_ID)
);

CREATE TABLE RM_INV_T
(
 InventoryID INTEGER not null,
 ManufactureID INTEGER not null,
 PO_ID INTEGER not null,
 CONSTRAINT RM_INV_PK PRIMARY KEY (InventoryID),
 CONSTRAINT RM_INV_FK1 FOREIGN KEY (ManufactureID) REFERENCES MANUFACTURE_T
(ManufactureID),
 CONSTRAINT RM_INV_FK2 FOREIGN KEY (PO_ID) REFERENCES PO_T (PO_ID)
);

CREATE TABLE FG_DETAIL_T
(
 FG_ID INTEGER not null,
 WarehouseID INTEGER not null,
 WH_Location VARCHAR2(25) not null,
 CONSTRAINT FG_DETAIL_PK PRIMARY KEY (FG_ID, WarehouseID),
 CONSTRAINT FG_DETAIL_FK1 FOREIGN KEY (FG_ID) REFERENCES FG_T (FG_ID),
 CONSTRAINT FG_DETAIL_FK2 FOREIGN KEY (WarehouseID) REFERENCES WAREHOUSE_T
(WarehouseID)
);

CREATE TABLE SHIPMENT_T
(
 ShippingID INTEGER not null,
 WarehouseID INTEGER not null,
 CONSTRAINT SHIPMENT_PK PRIMARY KEY (ShippingID),
 CONSTRAINT SHIPMENT_FK FOREIGN KEY (WarehouseID) REFERENCES WAREHOUSE_T
(WarehouseID)
);

CREATE TABLE CUSTOMER_T
(
 CustomerID INTEGER not null,
 CustomerType VARCHAR2(2) not null,
 Address VARCHAR2(25) not null,
 ShippingID INTEGER not null,
Name VARCHAR(25) not null,
 CONSTRAINT CUSTOMER_PK PRIMARY KEY (CustomerID),
 CONSTRAINT CUSTOMER_FK FOREIGN KEY (ShippingID) REFERENCES SHIPMENT_T
(ShippingID)
);

CREATE TABLE ORDER_T
(
 OrderID INTEGER not null,
 ShippingID INTEGER not null,
 CustomerID INTEGER not null,
 CONSTRAINT ORDER_PK PRIMARY KEY (OrderID),
 CONSTRAINT ORDER_FK FOREIGN KEY (CustomerID) REFERENCES CUSTOMER_T (CustomerID)
);

CREATE TABLE SHIPMENT_DETAIL_T
(
 ShippingID INTEGER not null,
 OrderID INTEGER not null,
 CONSTRAINT SHIPMENT_DETAIL_PK PRIMARY KEY (ShippingID, OrderID),
 CONSTRAINT SHIPMENT_DETAIL_FK1 FOREIGN KEY (ShippingID) REFERENCES SHIPMENT_T
(ShippingID),
 CONSTRAINT SHIPMENT_DETAIL_FK2 FOREIGN KEY (OrderID) REFERENCES ORDER_T
(OrderID)
);

CREATE TABLE ORDER_DETAIL_T
(
 FG_ID INTEGER not null,
 OrderID INTEGER not null,
 CONSTRAINT ORDER_DETAIL_PK PRIMARY KEY (FG_ID, OrderID),
 CONSTRAINT ORDER_DETAIL_FK1 FOREIGN KEY (FG_ID) REFERENCES FG_T (FG_ID),
 CONSTRAINT ORDER_DETAIL_FK2 FOREIGN KEY (OrderID) REFERENCES ORDER_T (OrderID)
);

CREATE TABLE OUT_INVOICE_T
(
 OutInvoiceID INTEGER not null,
 OrderID INTEGER not null,
 OutInvoiceDate DATE not null,
 Price NUMERIC not null,
 CONSTRAINT OUT_INVOICE_PK PRIMARY KEY (OutInvoiceID),
 CONSTRAINT OUT_INVOICE_FK FOREIGN KEY (OrderID) REFERENCES ORDER_T (OrderID)
);

CREATE TABLE RETAILER_T
(
 RCustomerID INTEGER not null,
 Name VARCHAR2(25) not null,
 Address VARCHAR2(25) not null,
 CONSTRAINT RETAILER_PK PRIMARY KEY (RCustomerID)
);

CREATE TABLE DISTRIBUTOR_T
(
 DCustomerID INTEGER not null,
 Name VARCHAR2(25) not null,
 Address VARCHAR2(25) not null,
 CONSTRAINT DISTRIBUTOR_PK PRIMARY KEY (DCustomerID)
);

Insert into SUPPLIER_T values (1,'Khalid','Chicago,IL','');
Insert into SUPPLIER_T values (2,'Bon Jovi','Seattle,WA','No Longer Supplying');
Insert into SUPPLIER_T values (3,'Alicia Keys','Los Angeles,CA','');
Insert into SUPPLIER_T values (4,'Justin Timberlake','New Jersey,NJ','');
Insert into SUPPLIER_T values (5,'Cardi B','Atlanta,GA','');

Insert into PO_T values (100,'Cane Sugar', '01-JAN-2018',1);
Insert into PO_T values (101,'Gas', '02-JAN-2018',3);
Insert into PO_T values (102,'Bottle', '15-FEB-2018',5);
Insert into PO_T values (103,'Sticker', '27-MAR-2018',4);
Insert into PO_T values (104,'Bottle Caps','08-JUN-2018',3);

Insert into INVOICE_T values (2001,100, '03-JAN-2018',3500);
Insert into INVOICE_T values (2002,101, '04-JAN-2018',2700);
Insert into INVOICE_T values (2003,102, '17-FEB-2018',9000);
Insert into INVOICE_T values (2004,103, '29-MAR-2018',1200);
Insert into INVOICE_T values (2005,104, '10-JUN-2018',5000);

Insert into RM_T values (50,100,'Cane Sugar',1);
Insert into RM_T values (51,101,'Gas',2);
Insert into RM_T values (52,102,'Bottle',3);
Insert into RM_T values (53,103,'Sticker',4);
Insert into RM_T values (54,104,'Bottle Caps',5);

INSERT into MANUFACTURE_T values (1,300,'North Jordan Ave');
INSERT into MANUFACTURE_T values (2,301,'10th Street');
INSERT into MANUFACTURE_T values (3,303,'Kirkwood Ave');

INSERT into RM_DETAIL_T values (50,1,700);
INSERT into RM_DETAIL_T values (51,1,200);
INSERT into RM_DETAIL_T values (52,2,1500);
INSERT into RM_DETAIL_T values (53,3,1750);
INSERT into RM_DETAIL_T values (54,3,1750);
Insert into WAREHOUSE_T values (250, 50, 'North');
Insert into WAREHOUSE_T values (260, 50, 'South');
Insert into SHIPMENT_T values (300, 250);
Insert into SHIPMENT_T values (301, 250);
Insert into SHIPMENT_T values (302, 260);

Insert into CUSTOMER_T values (1001, 'RE', 'New Jersey,NJ', 300, 'Ellon Musk');
Insert into CUSTOMER_T values (1002, 'RE', 'Seattle,WA', 301, 'Bruce Wayne');
Insert into CUSTOMER_T values (1003, 'RE', 'Tacoma,WA', 301, 'Tony Stark');
Insert into CUSTOMER_T values (1004, 'DI', 'Chicago,IL', 301, 'Peter Parker');
Insert into CUSTOMER_T values (1005, 'DI', 'Bloomington,IN', 302, 'Mark Cuban');
Insert into CUSTOMER_T values (1006, 'DI', 'Bloomington,IN', 302, 'Mark Cuban');

Insert into ORDER_T values (10500, 300, 1001);
Insert into ORDER_T values (10501, 301, 1002);
Insert into ORDER_T values (10502, 302, 1003);
Insert into ORDER_T values (10503, 302, 1005);
Insert into ORDER_T values (10504, 301, 1004);

Insert into SHIPMENT_DETAIL_T values (300, 10500);
Insert into SHIPMENT_DETAIL_T values (301, 10501);
Insert into SHIPMENT_DETAIL_T values (302, 10502);
Insert into SHIPMENT_DETAIL_T values (302, 10503);
Insert into SHIPMENT_DETAIL_T values (301, 10504);

Insert into OUT_INVOICE_T values (3001,10500, '03-JAN-2019',3500);
Insert into OUT_INVOICE_T values (3002,10501, '09-FEB-2018',7200);
Insert into OUT_INVOICE_T values (3003,10502, '11-MAR-2018',25000);
Insert into OUT_INVOICE_T values (3004,10503, '22-MAR-2018',2100);
Insert into OUT_INVOICE_T values (3005,10504, '21-SEP-2018',900);

 CREATE INDEX MANUFACTURE_DETAIL_IDX
 ON MANUFACTURE_T (ManufactureID, SiteAddress);

 CREATE INDEX INVOICE_DETAIL_IDX
 ON INVOICE_T (Price, InvoiceDate);

 CREATE INDEX CUSTOMER_ORDER_IDX
 ON ORDER_T (CustomerID, OrderID);

 CREATE INDEX OUT_INVOICE_DETAIL_IDX
 ON OUT_INVOICE_T (Price, OutInvoiceDate);

DELETE from CUSTOMER_T
WHERE CustomerID = 1006;

UPDATE OUT_INVOICE_T
SET OutInvoiceDate = '03-JAN-2018'
    WHERE OutInvoiceID = 3001;
 
SELECT RM_T.RMName, MANUFACTURE_T.ManufactureID, MANUFACTURE_T.SiteAddress,
INVOICE_T.Price, INVOICE_T.InvoiceDate
    FROM MANUFACTURE_T, RM_DETAIL_T,RM_T, PO_T, INVOICE_T
    WHERE MANUFACTURE_T.ManufactureID = RM_DETAIL_T.ManufactureID
    AND RM_DETAIL_T.RM_ID = RM_T.RM_ID
    AND RM_T.PO_ID = PO_T.PO_ID
    AND PO_T.PO_ID = INVOICE_T.PO_ID;
    
SELECT CUSTOMER_T.Name, SHIPMENT_T.ShippingID, OUT_INVOICE_T.OrderID,
OUT_INVOICE_T.OutInvoiceDate, OUT_INVOICE_T.Price
    FROM CUSTOMER_T, SHIPMENT_T,OUT_INVOICE_T,ORDER_T
    WHERE CUSTOMER_T.CustomerID = ORDER_T.CustomerID
    AND CUSTOMER_T.ShippingID = SHIPMENT_T.ShippingID
    AND ORDER_T.OrderID = OUT_INVOICE_T.OrderID;