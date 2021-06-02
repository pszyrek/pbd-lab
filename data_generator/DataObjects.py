import datetime, random

from faker import Faker

# Shared
CustomerID = []
CompanyID = []
TableID = []
OrderID = []
ProductID = []
DiscountID = []
RoleID = [1, 2, 3, 4]
UserID = []
FunctionalityID = []
customer_discount = {}

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
ReservationDatePlacement = []
# TODO check if we need both start and end
ReservationStartDateTime = []
ReservationEndDateTime = []
IsBusinessMeeting = []
IsAccepted = []

# Tables table
TableIsActive = []

# Orders table
OrderPlacementDateTime = []
OrderRealizationDateTime = []
WasInvoiced = []
DiscountID = []

# Order entries table
ProductQuantity = []

# Discounts table
DiscountPercentage = []
DiscountIssuanceDateTime = []
DiscountExpirationDateTime = []

# Products table
ProductName = []
ProductTotalPrice = []
ProductIsInMenu = []
ProductIsPreordered = []

# Roles table
RoleName = ["Administrator", "Manager", "Employee", "Guest"]

# Permissions table
# TODO insert functionalities names
FunctionalitiesName = ["Functionality1", "Functionality2", "Functionality3", "Functionality4"]
FunctionalitiesToRoles = [1, 2, 3, 4]

# Users table
UserLogin = ["tomek123", "ania33", "droid1", "kociara00", "nowy18", "gracz3", "guest"]
UserName = ["Tomasz Kowalski", "Anna Nowak", "Bartosz Bąk", "Maria Dąbrowska", "Jan Wesołowski", "Marcel Słowacki", "Gość"]
UserRoles = [1, 2, 3, 3, 3, 3, 4]

faker = Faker()
Faker.seed(1)


def generateID(list, size):
    list.clear()
    for i in range(1, size):
        list.append(i)


def generateIDwithNull(list, size):
    list.clear()
    null = None
    values = [1, 2]
    distribution = [.65, .35]
    for i in range(1, size):
        random_number = random.choices(values, distribution)
        if random_number == [1]:
            list.append(null)
        else:
            list.append(i)


def generateIDwithDiffrentListSize(list, sizeA, sizeB):
    list.clear()
    for i in range(1, sizeA):
        x = random.randrange(1, sizeB)
        list.append(x)


def generateIDwithNullAndDiffrentListSize(list, sizeA, sizeB):
    list.clear()
    null = None
    values = [1, 2]
    distribution = [.65, .35]
    for i in range(1, sizeA):
        random_number = random.choices(values, distribution)
        x = random.randrange(1, sizeB)
        if random_number == [1]:
            list.append(null)
        else:
            list.append(x)


def generateCustomerName(size):
    CustomerName.clear()
    for i in range(0, size - 1):
        CustomerName.append(faker.first_name())


def generateCustomerSurname(size):
    CustomerSurname.clear()
    for i in range(0, size - 1):
        CustomerSurname.append(faker.last_name())


def generateCustomerEmail(size):
    CustomerEmail.clear()
    for i in range(0, size - 1):
        CustomerEmail.append(faker.ascii_email())


def generateCustomerPhoneNumber(size):
    CustomerPhoneNumber.clear()
    for i in range(0, size - 1):
        CustomerPhoneNumber.append(faker.phone_number())


def generateCompanyName(size):
    CompanyName.clear()
    for i in range(0, size - 1):
        CompanyName.append(faker.company())


def generateCompanyAddress(size):
    CompanyAddress.clear()
    for i in range(0, size - 1):
        CompanyAddress.append(faker.address())


def generateCompanyTaxID(size):
    TaxID.clear()
    for i in range(0, size - 1):
        TaxID.append(faker.ssn())


# start date as a string "year, month, day"
def generateDatesForOrders(startYear, startMonth, startDay, size):
    OrderPlacementDateTime.clear()
    OrderRealizationDateTime.clear()
    for i in range(0, size - 1):
        tmp = datetime.datetime(startYear, startMonth, startDay)
        placementDate = faker.date_time_between(tmp)
        OrderPlacementDateTime.append(placementDate)
        delta = datetime.timedelta(hours=5)
        OrderRealizationDateTime.append(placementDate + delta)


# start date as a string "year, month, day"
def generateDatesForReservations(startYear, startMonth, startDay, size):
    ReservationDatePlacement.clear()
    ReservationStartDateTime.clear()
    ReservationEndDateTime.clear()
    for i in range(0, size - 1):
        providedDate = datetime.datetime(startYear, startMonth, startDay)
        # generate placement date after provided date
        placementDate = faker.date_time_between(providedDate)
        ReservationDatePlacement.append(placementDate)
        # generate start date after placement date
        startDate = faker.date_time_between(placementDate)
        ReservationStartDateTime.append(startDate)
        # end date is set for 2 hours later
        deltaHours = datetime.timedelta(hours=2)
        ReservationEndDateTime.append(startDate + deltaHours)


def generateDatesForDiscounts(startYear, startMonth, startDay, size, numberOfDays):
    DiscountIssuanceDateTime.clear()
    DiscountExpirationDateTime.clear()
    for i in range(0, size - 1):
        tmp = datetime.datetime(startYear, startMonth, startDay)
        issuanceDate = faker.date_time_between(tmp)
        DiscountIssuanceDateTime.append(issuanceDate)
        delta = datetime.timedelta(days=numberOfDays)
        DiscountExpirationDateTime.append(issuanceDate + delta)


def generateBoolean(size, list, probability):
    list.clear()
    for i in range(0, size - 1):
        list.append(faker.boolean(probability))


def generatePrice(size, startprice, endprice):
    for i in range(0, size - 1):
        x = round(random.uniform(startprice, endprice), 2)
        ProductTotalPrice.append(x)


def generateProductName(size):
    file = open("foodList.txt", "r")
    foodList = []
    for line in file:
        stripped_line = line.strip()
        foodList.append(stripped_line)
    file.close()
    for i in range(0, size - 1):
        x = random.randint(0, len(foodList)-1)
        ProductName.append(foodList[x])


def generateQuantity(size):
    for i in range(0, size - 1):
        x = random.randint(1, 3)
        ProductQuantity.append(x)


def generateDiscountPercentage(size):
    for i in range(0, size - 1):
        x = round(random.uniform(0.1, 0.25), 2)
        DiscountPercentage.append(x)

