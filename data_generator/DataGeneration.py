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


# sizeA - size of customers list, sizeB - size of companies list
def generate_customers(sizeA, sizeB):
    generateID(CustomerID, sizeA)
    generateIDwithNullAndDiffrentListSize(CompanyID, sizeA, sizeB)
    generateCustomerName(sizeA)
    generateCustomerSurname(sizeA)
    generateCustomerEmail(sizeA)
    generateCustomerPhoneNumber(sizeA)

    for i in range(0, sizeA - 1):
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


# sizeA - size of reservations list, sizeB - size of customers list, sizeC - size of tables list
def generate_reservations(sizeA, sizeB, sizeC):
    # generateID(ReservationID, sizeA)
    generateIDwithDiffrentListSize(CustomerID, sizeA, sizeB)
    generateIDwithDiffrentListSize(TableID, sizeA, sizeC)
    generateDatesForReservations(2018, 1, 1, sizeA)
    generateBoolean(sizeA, IsBusinessMeeting, 30)
    generateBoolean(sizeA, IsAccepted, 99)

    for i in range(0, sizeA - 1):
        cursor.execute("INSERT INTO Reservations (CustomerID, TableID, PlacementDateTime, "
                       "ReservationStartDateTime, ReservationEndDateTime, IsBusinessMeeting, IsAccepted) VALUES"
                       "(?, ?, ?, ?, ?, ?, ?)",CustomerID[i], TableID[i],
                       ReservationDatePlacement[i], ReservationStartDateTime[i], ReservationEndDateTime[i],
                       IsBusinessMeeting[i], IsAccepted[i])
        connection.commit()
        print("Rows inserted: " + str(connection))


# TODO we should bind users with their discounts in order to assign correct discounts to users
# sizeA - size of orders list, sizeB - size of customers list, sizeC - size of discounts list
def generate_orders(sizeA, sizeB, sizeC):
    # generateID(OrderID, sizeA)
    generateIDwithDiffrentListSize(CustomerID, sizeA, sizeB)
    generateDatesForOrders(2018, 1, 1, sizeA)
    generateBoolean(sizeA, WasInvoiced, 35)
    generateIDwithNullAndDiffrentListSize(DiscountID, sizeA, sizeC)

    for i in range(0, sizeA - 1):
        cursor.execute("INSERT INTO Orders (CustomerID, PlacementDateTime, RealizationDateTime,"
                       "WasInvoiced, DiscountID) VALUES (?, ?, ?, ?, ?)", CustomerID[i],
                       OrderPlacementDateTime[i], OrderRealizationDateTime[i], WasInvoiced[i], DiscountID[i])
        connection.commit()
        print("Rows inserted: " + str(connection))


# sizeA - size of order entries list, sizeB - size of products list
def generate_order_entries(sizeA, sizeB):
    for i in range (1, sizeA):
        tmp = random.randint(1, 9)
        generateIDwithDiffrentListSize(ProductID, tmp, sizeB)
        generateQuantity(tmp)
        for j in range(0, tmp - 1):
            try:
                cursor.execute("INSERT INTO OrderEntries (OrderID, ProductID, Quantity) VALUES (?, ?, ?)", i,
                           ProductID[j], ProductQuantity[j])
                connection.commit()
                print("Rows inserted: " + str(connection))
            except pyodbc.IntegrityError:
                pass


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


# sizeA - size of discounts list size, sizeB - size of customers list size
def generate_discounts(sizeA, sizeB, numberOfDays):
    # generateID(DiscountID, sizeA)
    generateIDwithDiffrentListSize(CustomerID, sizeA, sizeB)
    generateDiscountPercentage(sizeA)
    generateDatesForDiscounts(2018, 1, 1, sizeA, numberOfDays)

    for i in range(0, sizeA - 1):
        cursor.execute("INSERT INTO Discounts (CustomerID, DiscountPercentage, IssuanceDateTime, "
                       "ExpirationDateTime) VALUES (?, ?, ?, ?)", CustomerID[i],
                       DiscountPercentage[i], DiscountIssuanceDateTime[i], DiscountExpirationDateTime[i])
        connection.commit()
        print("Rows inserted: " + str(connection))


def test_insert():
    cursor.execute("INSERT INTO Customers (CustomerID, CompanyID, Name, Surname, EmailAdress, PhoneNumber)"
                   "VALUES (?, ?, ?, ?, ?, ?)", 1, None, "Name", "Surname", "Mail", "PhoneNumber")
    connection.commit()
    print("Rows inserted: " + str(connection))


def test_select():
    cursor.execute("SELECT DiscountID, CustomerID FROM Discounts")
    for row in cursor.fetchall():
        print(row)


def insert_roles():
    for i in range(4):
        cursor.execute("INSERT INTO Roles (RoleID, Name) VALUES (?, ?)", RoleID[i], RoleName[i])
        connection.commit()
        print("Rows inserted: " + str(connection))


def insert_users():
    generateID(UserID, 8)
    for i in range(0, 7):
        cursor.execute("INSERT INTO Users (UserID, Login, Name, RoleID) VALUES (?, ?, ?, ?)",
                       UserID[i], UserLogin[i], UserName[i], UserRoles[i])
        connection.commit()
        print("Rows inserted: " + str(connection))


def insert_functionalities():
    generateID(FunctionalityID, 5)
    for i in range(0, 4):
        cursor.execute("INSERT INTO Permissions (FunctionalityID, FunctionalityName, RoleID) VALUES (?, ?, ?)",
                       FunctionalityID[i], FunctionalitiesName[i], FunctionalitiesToRoles[i])
        connection.commit()
        print("Rows inserted: " + str(connection))
