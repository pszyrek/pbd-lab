import pyodbc
from DataObjects import *
from DataGeneration import *


def main():
    customersSize = 500
    companiesSize = 150
    tablesSize = 50
    reservationsSize = 1000
    discountsSize = 750
    discountValidDays = 10
    productsSize = 1250
    ordersSize = 2000
    orderEntriesSize = 3000

    generate_companies(companiesSize)
    generate_customers(customersSize, companiesSize)
    generate_tables(tablesSize)
    generate_reservations(reservationsSize, customersSize, tablesSize)
    generate_discounts(discountsSize, customersSize, discountValidDays)
    generate_products(productsSize)
    generate_orders(ordersSize, customersSize, discountsSize)
    generate_order_entries(ordersSize, productsSize)
    insert_roles()
    insert_users()
    insert_functionalities()

    # test_insert()
    # test_select()




if __name__ == "__main__":
    main()
