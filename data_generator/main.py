import pyodbc
from DataObjects import *
from DataGeneration import *


def main():
    size = 50
    # generate_companies(size)
    # generate_customers(size)
    # generate_tables(size)
    # generate_reservations(size)
    # generate_discounts(size)
    generate_products(size)
    # generate_orders(size)
    # generate_order_entries(size)


if __name__ == "__main__":
    main()
