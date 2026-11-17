USE IT_ServiceCenter_Practice;
GO

-- Запрос 1: Полный список заявок
SELECT RequestId, Description, CreatedAt, Cost
FROM ServiceRequests
ORDER BY CreatedAt DESC;

-- Запрос 2: Новые заявки
SELECT sr.RequestId, sr.Description, sr.CreatedAt
FROM ServiceRequests sr
INNER JOIN RequestStatuses rs ON sr.StatusId = rs.StatusId
WHERE rs.StatusName = 'Новая';

-- Запрос 3: Дорогие сетевые обращения
SELECT sr.RequestId, sr.Description, sr.Cost, c.CategoryName
FROM ServiceRequests sr
INNER JOIN Categories c ON sr.CategoryId = c.CategoryId
WHERE c.CategoryName = 'Сеть' AND sr.Cost > 1000;

-- Запрос 4: Поиск по фрагменту текста
SELECT RequestId, Description
FROM ServiceRequests
WHERE Description LIKE '%принтер%';

-- Запрос 5: Подробный отчёт по заявкам
SELECT 
    sr.RequestId, 
    cl.FullName AS ClientName, 
    cat.CategoryName, 
    sr.Description, 
    stat.StatusName, 
    emp.FullName AS EmployeeName, 
    sr.Cost
FROM ServiceRequests sr
INNER JOIN Clients cl ON sr.ClientId = cl.ClientId
INNER JOIN Categories cat ON sr.CategoryId = cat.CategoryId
INNER JOIN RequestStatuses stat ON sr.StatusId = stat.StatusId
LEFT JOIN Employees emp ON sr.EmployeeId = emp.EmployeeId;

-- Запрос 6: Заявки без назначенного сотрудника
SELECT sr.RequestId, sr.Description, sr.CreatedAt, cl.FullName
FROM ServiceRequests sr
INNER JOIN Clients cl ON sr.ClientId = cl.ClientId
WHERE sr.EmployeeId IS NULL
ORDER BY sr.CreatedAt ASC;

-- Запрос 7: Количество заявок по статусам
SELECT rs.StatusName, COUNT(sr.RequestId) AS RequestCount
FROM RequestStatuses rs
LEFT JOIN ServiceRequests sr ON rs.StatusId = sr.StatusId
GROUP BY rs.StatusName
ORDER BY RequestCount DESC;

-- Запрос 8: Анализ стоимости по категориям
SELECT c.CategoryName, AVG(sr.Cost) AS AvgCost, MAX(sr.Cost) AS MaxCost
FROM Categories c
INNER JOIN ServiceRequests sr ON c.CategoryId = sr.CategoryId
GROUP BY c.CategoryName
HAVING AVG(sr.Cost) > 1000;

-- Запрос 9: Клиенты с несколькими обращениями
SELECT cl.FullName, COUNT(sr.RequestId) AS RequestCount
FROM Clients cl
INNER JOIN ServiceRequests sr ON cl.ClientId = sr.ClientId
GROUP BY cl.FullName
HAVING COUNT(sr.RequestId) >= 2
ORDER BY RequestCount DESC;

-- Запрос 10: Клиенты без заявок
SELECT cl.FullName, cl.City
FROM Clients cl
LEFT JOIN ServiceRequests sr ON cl.ClientId = sr.ClientId
WHERE sr.RequestId IS NULL;