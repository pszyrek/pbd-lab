import pyodbc

from DataObjects import *

connection = pyodbc.connect(
    'DRIVER={ODBC Driver 17 for SQL Server};SERVER=DESKTOP-1;DATABASE=PBD_lab;UID=test;PWD=test')
cursor = connection.cursor()


def generate_companies(size):
    generateID(CompanyID, size)
    generateCompanyName(size)
    generateCompanyAddress(size)
    generateCompanyTaxID(size)

    for i in range(0, size - 1):
        cursor.execute("INSERT INTO Companies (CompanyID, Name, Adress, TaxID) VALUES (?, ?, ?, ?)",
                       CompanyID[i], CompanyName[i], CompanyAddress[i], TaxID[i])
        connection.commit()
        print("Rows inserted: " + str(connection))


def generate_customers(size):
    generateID(CustomerID, size)
    generateIDwithNull(CompanyID, size)
    generateCustomerName(size)
    generateCustomerSurname(size)
    generateCustomerEmail(size)
    generateCustomerPhoneNumber(size)

    for i in range(0, size - 1):
        cursor.execute("INSERT INTO Customers (CustomerID, CompanyID, Name, Surname, EmailAdress, PhoneNumber)"
                       "VALUES (?, ?, ?, ?, ?, ?)", CustomerID[i], CompanyID[i], CustomerName[i], CustomerSurname[i],
                       CustomerEmail[i], CustomerPhoneNumber[i])
        connection.commit()
        print("Rows inserted: " + str(connection))


def generate_tables(size):
    generateID(TableID, size)
    generateBoolean(size, TableIsActive, size)

    for i in range(0, size - 1):
        cursor.execute("INSERT INTO Tables (TableID, IsActive) VALUES (?, ?)", TableID[i], TableIsActive[i])
        connection.commit()
        print("Rows inserted: " + str(connection))


def generate_reservations(size):
    generateID(ReservationID, size)
    generateID(CustomerID, size)
    generateIDwithNull(TableID, size)
    generateDatesForReservations(2018, 1, 1, size)
    generateBoolean(size, IsBusinessMeeting, 30)
    generateBoolean(size, IsAccepted, 99)

    for i in range(0, size - 1):
        cursor.execute("INSERT INTO Reservations (ReservationID, CustomerID, TableID, PlacementDateTime, "
                       "ReservationStartDateTime, ReservationEndDateTime, IsBusinessMeeting, IsAccepted) VALUES"
                       "(?, ?, ?, ?, ?, ?, ?, ?)", ReservationID[i], CustomerID[i], TableID[i],
                       ReservationDatePlacement[i], ReservationStartDateTime[i], ReservationEndDateTime[i],
                       IsBusinessMeeting[i], IsAccepted[i])
        connection.commit()
        print("Rows inserted: " + str(connection))


def generate_orders(size):
    generateID(OrderID, size)
    generateID(CustomerID, size)
    generateDatesForOrders(2018, 1, 1, size)
    generateBoolean(size, WasInvoiced, 35)
    generateIDwithNull(DiscountID, size)

    for i in range(0, size - 1):
        cursor.execute("INSERT INTO Orders (OrderID, CustomerID, PlacementDateTime, RealizationDateTime,"
                       "WasInvoiced, DiscountID) VALUES (?, ?, ?, ?, ?, ?)", OrderID[i], CustomerID[i],
                       OrderPlacementDateTime[i], OrderRealizationDateTime[i], WasInvoiced[i], DiscountID[i])
        connection.commit()
        print("Rows inserted: " + str(connection))


def generate_order_entries(size):
    generateID(OrderID, size)
    generateID(ProductID, size)
    generateQuantity(size)

    for i in range(0, size - 1):
        cursor.execute("INSERT INTO OrderEntries (OrderID, ProductID, Quantity) VALUES (?, ?, ?)", OrderID[i],
                       ProductID[i], ProductQuantity[i])
        connection.commit()
        print("Rows inserted: " + str(connection))


def generate_products(size):
    generateID(ProductID, size)
    generateProductName(size)
    generatePrice(size, 5.00, 500.00)
    generateBoolean(size, ProductIsInMenu, 40)
    generateBoolean(size, ProductIsPreordered, 99)

    for i in range(0, size - 1):
        cursor.execute("INSERT INTO Products (ProductID, Name, TotalPrice, IsInMenu, IsPreordered) VALUES "
                       "(?, ?, ?, ?, ?)", ProductID[i], ProductName[i], ProductTotalPrice[i], ProductIsInMenu[i],
                       ProductIsPreordered[i])
        connection.commit()
        print("Rows inserted: " + str(connection))


def generate_discounts(size):
    generateID(DiscountID, 50)
    generateID(CustomerID, 50)
    generateDiscountPercentage(size)
    generateDatesForDiscounts(2018, 1, 1, 50, 10)

    for i in range(0, size - 1):
        cursor.execute("INSERT INTO Discounts (DiscountID, CustomerID, DiscountPercentage, IssuanceDateTime, "
                       "ExpirationDateTime) VALUES (?, ?, ?, ?, ?)", DiscountID[i], CustomerID[i],
                       DiscountPercentage[i],
                       DiscountIssuanceDateTime[i], DiscountExpirationDateTime[i])
        connection.commit()
        print("Rows inserted: " + str(connection))
