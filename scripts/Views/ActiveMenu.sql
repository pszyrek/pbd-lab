USE PBD_lab
GO
CREATE VIEW ActiveMenu AS
SELECT ProductID, Name, TotalPrice from Products
WHERE IsInMenu = 1 AND 
(IsPreordered = 0 OR (IsPreordered = 1 AND dbo.can_preorder() = 1))