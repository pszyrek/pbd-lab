USE PBD_lab
GO

INSERT INTO Companies
VALUES ('DB Creators', 'Kraków, al.Mickiewicza 100', '123-456-78-90')

DECLARE @CompanyId bigint = SCOPE_IDENTITY()

INSERT INTO Customers VALUES
(@CompanyId, 'Jan', 'Kowalski', 'kowalski@gmail.com', '123-456-78-90')
