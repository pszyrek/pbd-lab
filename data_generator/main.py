import pyodbc
from GenerateData import *


def main():
    connection = pyodbc.connect(
        'DRIVER={ODBC Driver 17 for SQL Server};SERVER=DESKTOP-1;DATABASE=PBD_lab;UID=test;PWD=test')
    cursor = connection.cursor()
    varA = 1
    cursor.execute("INSERT INTO Users (UserID, Login, Name, RoleID) VALUES (?, ?, ?, ?)", varA, 'test', 'Jan', 2)
    connection.commit()
    print('Rows inserted: ' + str(connection))


if __name__ == "__main__":
    main()
