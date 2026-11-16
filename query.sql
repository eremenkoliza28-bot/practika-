PRAGMA foreign_keys = ON;

-- 1. Создаем таблицы
CREATE TABLE Roles (
    Id INTEGER PRIMARY KEY AUTOINCREMENT,
    Name TEXT NOT NULL UNIQUE
);

CREATE TABLE Categories (
    Id INTEGER PRIMARY KEY AUTOINCREMENT,
    Name TEXT NOT NULL UNIQUE
);

CREATE TABLE Priorities (
    Id INTEGER PRIMARY KEY AUTOINCREMENT,
    Name TEXT NOT NULL UNIQUE,
    SortOrder INTEGER NOT NULL
);

CREATE TABLE Statuses (
    Id INTEGER PRIMARY KEY AUTOINCREMENT,
    Name TEXT NOT NULL UNIQUE
);

CREATE TABLE Users (
    Id INTEGER PRIMARY KEY AUTOINCREMENT,
    Login TEXT NOT NULL UNIQUE,
    PasswordHash TEXT NOT NULL,
    FullName TEXT NOT NULL,
    RoleId INTEGER NOT NULL,
    IsActive INTEGER NOT NULL DEFAULT 1,
    FOREIGN KEY (RoleId) REFERENCES Roles(Id)
);

CREATE TABLE Tickets (
    Id INTEGER PRIMARY KEY AUTOINCREMENT,
    UserId INTEGER NOT NULL,
    CategoryId INTEGER NOT NULL,
    Description TEXT NOT NULL,
    PriorityId INTEGER NOT NULL,
    StatusId INTEGER NOT NULL,
    AssignedUserId INTEGER,
    CreatedAt TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TEXT,
    FOREIGN KEY (UserId) REFERENCES Users(Id),
    FOREIGN KEY (CategoryId) REFERENCES Categories(Id),
    FOREIGN KEY (PriorityId) REFERENCES Priorities(Id),
    FOREIGN KEY (StatusId) REFERENCES Statuses(Id),
    FOREIGN KEY (AssignedUserId) REFERENCES Users(Id)
);

-- 2. Заполняем данные
INSERT INTO Roles (Name) VALUES
('Пользователь'), ('Специалист'), ('Администратор');

INSERT INTO Categories (Name) VALUES
('Оборудование'), ('Программное обеспечение'), ('Сеть'),
('Учётная запись'), ('Периферия'), ('Другое');

INSERT INTO Priorities (Name, SortOrder) VALUES
('Низкий', 1), ('Средний', 2), ('Высокий', 3);

INSERT INTO Statuses (Name) VALUES
('Новая'), ('В работе'), ('Выполнена'), ('Отклонена');

INSERT INTO Users (Login, PasswordHash, FullName, RoleId, IsActive) VALUES
('admin',    'TEMP_ADMIN',   'Администратор системы',            3, 1),
('support1', 'TEMP_SUPPORT', 'Специалист технической поддержки', 2, 1),
('user1',    'TEMP_USER',    'Тестовый пользователь',            1, 1);

INSERT INTO Tickets (UserId, CategoryId, Description, PriorityId, StatusId, AssignedUserId) VALUES
(3, 3, 'Нет доступа в Интернет',            3, 1, NULL),
(3, 2, 'Не запускается Microsoft Word',     2, 2, 2),
(3, 1, 'Не включается компьютер',           3, 2, 2),
(3, 5, 'Не работает принтер',               2, 1, NULL),
(3, 4, 'Не удаётся войти в учётную запись', 3, 4, 2);

-- 3. Выводим результат JOIN (Задание 21)
SELECT
    t.Id,
    u.FullName  AS Author,
    c.Name      AS Category,
    t.Description,
    p.Name      AS Priority,
    s.Name      AS Status,
    au.FullName AS AssignedUser,
    t.CreatedAt
FROM Tickets t
JOIN Users u       ON u.Id = t.UserId
JOIN Categories c  ON c.Id = t.CategoryId
JOIN Priorities p  ON p.Id = t.PriorityId
JOIN Statuses s    ON s.Id = t.StatusId
LEFT JOIN Users au ON au.Id = t.AssignedUserId
ORDER BY t.Id;
-- Проверка UNIQUE
--INSERT INTO Categories (Name) VALUES ('Сеть');
INSERT INTO Tickets (UserId, CategoryId, Description, PriorityId, StatusId)
VALUES (9999, 3, 'Проверка внешнего ключа', 2, 1);