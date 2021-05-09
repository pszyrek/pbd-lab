import datetime, random

from faker import Faker

# Shared
CustomerID = []
CompanyID = []
TableID = []
OrderID = []
ProductID = []

# Customer table
CustomerName = []
CustomerSurname = []
CustomerEmail = []
CustomerPhoneNumber = []

# Companies table
CompanyName = []
CompanyAddress = []
TaxID = []

# Reservations table
ReservationID = []
ReservationDate = []
IsBusinessMeeting = []
IsAccepted = []

# Tables table
TableIsActive = []

# Orders table
OrderDate = []
OrderTotalGross = []
OrderTotalNet = []
ProductsAmount = []
IsDiscountActive = []

# Products table
ProductName = []
ProductNetPrice = []
ProductGrossPrice = []
ProductIsActive = []
ProductIsExtra = []

faker = Faker()
Faker.seed(1)


def generateID(list, size):
    for i in range(0, size-1):
        list.append(i)


def generateCustomerName(size):
    for i in range(0, size-1):
        CustomerName.append(faker.first_name())


def generateCustomerSurname(size):
    for i in range(0, size-1):
        CustomerSurname.append(faker.last_name())


def generateCustomerEmail(size):
    for i in range(0, size-1):
        CustomerEmail.append(faker.ascii_email())


def generateCustomerPhoneNumber(size):
    for i in range(0, size-1):
        CustomerPhoneNumber.append(faker.phone_number())


def generateCompanyName(size):
    for i in range(0, size-1):
        CompanyName.append(faker.company())


def generateCompanyAddress(size):
    for i in range(0, size-1):
        CompanyAddress.append(faker.adress())


def generateCompanyTaxID(size):
    for i in range(0, size-1):
        TaxID.append(faker.ssn())


def generateDate(start, end, size, list):
    for i in range(0, size):
        list.append(faker.date_time_between(start, end))


def generateBoolean(size, list, probability):
    for i in range(0, size-1):
        list.append(faker.boolean(probability))


def generatePrice(size, netlist, grosslist, startprice, endprice):
    for i in range(0, size-1):
        x = round(random.uniform(startprice, endprice), 2)
        netlist.append(x)
        grosslist.append(x*1.18)


def generateProductName(size):
    file = open("foodList.txt", "r")
    foodList = []
    for line in file:
        stripped_line = line.strip()
        line_list = stripped_line.split()
        foodList.append(line_list)

    file.close()
    for i in range(0, size-1):
        x = random.randint(0, len(foodList))
        list.append(foodList[x])
