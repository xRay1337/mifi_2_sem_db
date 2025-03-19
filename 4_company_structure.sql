-- Создание и наполнение таблиц

DROP SCHEMA IF EXISTS company_structure;

CREATE SCHEMA IF NOT EXISTS company_structure;

CREATE TABLE company_structure.Departments
(
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(100) NOT NULL
);

CREATE TABLE company_structure.Roles
(
    RoleID INT PRIMARY KEY,
    RoleName VARCHAR(100) NOT NULL
);

CREATE TABLE company_structure.Employees
(
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Position VARCHAR(100),
    ManagerID INT,
    DepartmentID INT,
    RoleID INT,
    FOREIGN KEY (ManagerID) REFERENCES Employees(EmployeeID),
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID),
    FOREIGN KEY (RoleID) REFERENCES Roles(RoleID)
);

CREATE TABLE company_structure.Projects
(
    ProjectID INT PRIMARY KEY,
    ProjectName VARCHAR(100) NOT NULL,
    StartDate DATE,
    EndDate DATE,
    DepartmentID INT,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

CREATE TABLE company_structure.Tasks
(
    TaskID INT PRIMARY KEY,
    TaskName VARCHAR(100) NOT NULL,
    AssignedTo INT,
    ProjectID INT,
    FOREIGN KEY (AssignedTo) REFERENCES Employees(EmployeeID),
    FOREIGN KEY (ProjectID) REFERENCES Projects(ProjectID)
);


INSERT INTO company_structure.Departments (DepartmentID, DepartmentName) VALUES
(1, 'Отдел продаж'),
(2, 'Отдел маркетинга'),
(3, 'IT-отдел'),
(4, 'Отдел разработки'),
(5, 'Отдел поддержки');

INSERT INTO company_structure.Roles (RoleID, RoleName) VALUES
(1, 'Менеджер'),
(2, 'Директор'),
(3, 'Генеральный директор'),
(4, 'Разработчик'),
(5, 'Специалист по поддержке'),
(6, 'Маркетолог');

INSERT INTO company_structure.Employees (EmployeeID, Name, Position, ManagerID, DepartmentID, RoleID) VALUES
(1, 'Иван Иванов', 'Генеральный директор', NULL, 1, 3),
(2, 'Петр Петров', 'Директор по продажам', 1, 1, 2),
(3, 'Светлана Светлова', 'Директор по маркетингу', 1, 2, 2),
(4, 'Алексей Алексеев', 'Менеджер по продажам', 2, 1, 1),
(5, 'Мария Мариева', 'Менеджер по маркетингу', 3, 2, 1),
(6, 'Андрей Андреев', 'Разработчик', 1, 4, 4),
(7, 'Елена Еленова', 'Специалист по поддержке', 1, 5, 5),
(8, 'Олег Олегов', 'Менеджер по продукту', 2, 1, 1),
(9, 'Татьяна Татеева', 'Маркетолог', 3, 2, 6),
(10, 'Николай Николаев', 'Разработчик', 6, 4, 4),
(11, 'Ирина Иринина', 'Разработчик', 6, 4, 4),
(12, 'Сергей Сергеев', 'Специалист по поддержке', 7, 5, 5),
(13, 'Кристина Кристинина', 'Менеджер по продажам', 4, 1, 1),
(14, 'Дмитрий Дмитриев', 'Маркетолог', 3, 2, 6),
(15, 'Виктор Викторов', 'Менеджер по продажам', 4, 1, 1),
(16, 'Анастасия Анастасиева', 'Специалист по поддержке', 7, 5, 5),
(17, 'Максим Максимов', 'Разработчик', 6, 4, 4),
(18, 'Людмила Людмилова', 'Специалист по маркетингу', 3, 2, 6),
(19, 'Наталья Натальева', 'Менеджер по продажам', 4, 1, 1),
(20, 'Александр Александров', 'Менеджер по маркетингу', 3, 2, 1),
(21, 'Галина Галина', 'Специалист по поддержке', 7, 5, 5),
(22, 'Павел Павлов', 'Разработчик', 6, 4, 4),
(23, 'Марина Маринина', 'Специалист по маркетингу', 3, 2, 6),
(24, 'Станислав Станиславов', 'Менеджер по продажам', 4, 1, 1),
(25, 'Екатерина Екатеринина', 'Специалист по поддержке', 7, 5, 5),
(26, 'Денис Денисов', 'Разработчик', 6, 4, 4),
(27, 'Ольга Ольгина', 'Маркетолог', 3, 2, 6),
(28, 'Игорь Игорев', 'Менеджер по продукту', 2, 1, 1),
(29, 'Анастасия Анастасиевна', 'Специалист по поддержке', 7, 5, 5),
(30, 'Валентин Валентинов', 'Разработчик', 6, 4, 4);

INSERT INTO company_structure.Projects (ProjectID, ProjectName, StartDate, EndDate, DepartmentID) VALUES
(1, 'Проект A', '2025-01-01', '2025-12-31', 1),
(2, 'Проект B', '2025-02-01', '2025-11-30', 2),
(3, 'Проект C', '2025-03-01', '2025-10-31', 4),
(4, 'Проект D', '2025-04-01', '2025-09-30', 5),
(5, 'Проект E', '2025-05-01', '2025-08-31', 3);

INSERT INTO company_structure.Tasks (TaskID, TaskName, AssignedTo, ProjectID) VALUES
(1, 'Задача 1: Подготовка отчета по продажам', 4, 1),
(2, 'Задача 2: Анализ рынка', 9, 2),
(3, 'Задача 3: Разработка нового функционала', 10, 3),
(4, 'Задача 4: Поддержка клиентов', 12, 4),
(5, 'Задача 5: Создание рекламной кампании', 5, 2),
(6, 'Задача 6: Обновление документации', 6, 3),
(7, 'Задача 7: Проведение тренинга для сотрудников', 8, 1),
(8, 'Задача 8: Тестирование нового продукта', 11, 3),
(9, 'Задача 9: Ответы на запросы клиентов', 12, 4),
(10, 'Задача 10: Подготовка маркетинговых материалов', 9, 2),
(11, 'Задача 11: Интеграция с новым API', 10, 3),
(12, 'Задача 12: Настройка системы поддержки', 7, 5),
(13, 'Задача 13: Проведение анализа конкурентов', 9, 2),
(14, 'Задача 14: Создание презентации для клиентов', 4, 1),
(15, 'Задача 15: Обновление сайта', 6, 3);


/*
Задача 1
Найти всех сотрудников, подчиняющихся Ивану Иванову (с EmployeeID = 1), включая их подчиненных и подчиненных подчиненных.
Для каждого сотрудника вывести следующую информацию:
1) EmployeeID: идентификатор сотрудника.
2) Имя сотрудника.
3) ManagerID: Идентификатор менеджера.
4) Название отдела, к которому он принадлежит.
5) Название роли, которую он занимает.
6) Название проектов, к которым он относится (если есть, конкатенированные в одном столбце через запятую).
7) Название задач, назначенных этому сотруднику (если есть, конкатенированные в одном столбце через запятую).
8) Если у сотрудника нет назначенных проектов или задач, отобразить NULL.

Требования:
1) Рекурсивно извлечь всех подчиненных сотрудников Ивана Иванова и их подчиненных.
2) Для каждого сотрудника отобразить информацию из всех таблиц.
3) Результаты должны быть отсортированы по имени сотрудника.
4) Решение задачи должно представлять из себя один sql-запрос и задействовать ключевое слово RECURSIVE.
*/
WITH RECURSIVE EmployeeHierarchy AS
(
    SELECT 	EmployeeID
			,Name
            ,ManagerID
            ,DepartmentID
            ,RoleID
    FROM company_structure.Employees
    WHERE EmployeeID = 1

    UNION ALL

    SELECT 	e.EmployeeID
			,e.Name
            ,e.ManagerID
            ,e.DepartmentID
            ,e.RoleID
    FROM company_structure.Employees AS e
    JOIN EmployeeHierarchy AS eh ON e.ManagerID = eh.EmployeeID
)
SELECT 	eh.EmployeeID
		,eh.Name AS EmployeeName
        ,eh.ManagerID
        ,d.DepartmentName
        ,r.RoleName
        ,COALESCE(GROUP_CONCAT(DISTINCT p.ProjectName ORDER BY p.ProjectName SEPARATOR ', ')) AS ProjectsNames
        ,COALESCE(GROUP_CONCAT(DISTINCT t.TaskName ORDER BY t.TaskName SEPARATOR ', ')) AS TasksNames
FROM EmployeeHierarchy AS eh
LEFT JOIN company_structure.Departments AS d ON eh.DepartmentID = d.DepartmentID
LEFT JOIN company_structure.Roles AS r ON eh.RoleID = r.RoleID
LEFT JOIN company_structure.Projects AS p ON p.DepartmentID = eh.DepartmentID
LEFT JOIN company_structure.Tasks AS t ON eh.EmployeeID = t.AssignedTo
GROUP BY eh.EmployeeID, eh.Name, eh.ManagerID, d.DepartmentName, r.RoleName
ORDER BY eh.Name;

/*
Задача 2
Найти всех сотрудников, подчиняющихся Ивану Иванову с EmployeeID = 1, включая их подчиненных и подчиненных подчиненных.
Для каждого сотрудника вывести следующую информацию:
- EmployeeID: идентификатор сотрудника.
- Имя сотрудника.
- Идентификатор менеджера.
- Название отдела, к которому он принадлежит.
- Название роли, которую он занимает.
- Название проектов, к которым он относится (если есть, конкатенированные в одном столбце).
- Название задач, назначенных этому сотруднику (если есть, конкатенированные в одном столбце).
- Общее количество задач, назначенных этому сотруднику.
- Общее количество подчиненных у каждого сотрудника (не включая подчиненных их подчиненных).
- Если у сотрудника нет назначенных проектов или задач, отобразить NULL.
*/
WITH RECURSIVE EmployeeHierarchy AS
(
    SELECT	EmployeeID
			,Name
            ,ManagerID
            ,DepartmentID
            ,RoleID
    FROM company_structure.Employees
    WHERE EmployeeID = 1

    UNION ALL

    SELECT	e.EmployeeID
			,e.Name
            ,e.ManagerID
            ,e.DepartmentID
            ,e.RoleID
    FROM company_structure.Employees AS e
    JOIN EmployeeHierarchy AS eh ON e.ManagerID = eh.EmployeeID
)
SELECT	eh.EmployeeID
		,eh.Name AS EmployeeName
        ,eh.ManagerID
        ,d.DepartmentName
        ,r.RoleName
        ,COALESCE(GROUP_CONCAT(DISTINCT p.ProjectName ORDER BY p.ProjectName SEPARATOR ', ')) AS ProjectsNames
        ,COALESCE(GROUP_CONCAT(DISTINCT t.TaskName ORDER BY t.TaskName SEPARATOR ', ')) AS TasksNames
        ,COUNT(DISTINCT t.TaskID) AS TotalTasks
        ,COUNT(DISTINCT e.EmployeeID) AS TotalSubordinates
FROM EmployeeHierarchy AS eh
LEFT JOIN company_structure.Departments AS d ON eh.DepartmentID = d.DepartmentID
LEFT JOIN company_structure.Roles AS r ON eh.RoleID = r.RoleID
LEFT JOIN company_structure.Projects AS p ON eh.DepartmentID = p.DepartmentID
LEFT JOIN company_structure.Tasks AS t ON eh.EmployeeID = t.AssignedTo
LEFT JOIN company_structure.Employees AS e ON eh.EmployeeID = e.ManagerID
GROUP BY eh.EmployeeID, eh.Name, eh.ManagerID, d.DepartmentName, r.RoleName
ORDER BY eh.Name;


/*
Задача 3
Найти всех сотрудников, которые занимают роль менеджера и имеют подчиненных (то есть число подчиненных больше 0).
Для каждого такого сотрудника вывести следующую информацию:
- EmployeeID: идентификатор сотрудника.
- Имя сотрудника.
- Идентификатор менеджера.
- Название отдела, к которому он принадлежит.
- Название роли, которую он занимает.
- Название проектов, к которым он относится (если есть, конкатенированные в одном столбце).
- Название задач, назначенных этому сотруднику (если есть, конкатенированные в одном столбце).
- Общее количество подчиненных у каждого сотрудника (включая их подчиненных).
- Если у сотрудника нет назначенных проектов или задач, отобразить NULL.
*/
WITH RECURSIVE ManagerHierarchy AS
(
    SELECT 	e.EmployeeID
			,e.Name
            ,e.ManagerID
            ,e.DepartmentID
            ,e.RoleID
    FROM company_structure.Employees AS e
    JOIN company_structure.Roles AS r ON e.RoleID = r.RoleID
    WHERE r.RoleName = 'Менеджер'

    UNION ALL

    SELECT 	e.EmployeeID
			,e.Name
            ,e.ManagerID
            ,e.DepartmentID
            ,e.RoleID
    FROM company_structure.Employees AS e
    JOIN ManagerHierarchy AS mh ON e.ManagerID = mh.EmployeeID
)
SELECT 	mh.EmployeeID
		,mh.Name AS EmployeeName
        ,mh.ManagerID
        ,d.DepartmentName
        ,r.RoleName
        ,COALESCE(GROUP_CONCAT(DISTINCT p.ProjectName ORDER BY p.ProjectName SEPARATOR ', ')) AS ProjectsNames
        ,COALESCE(GROUP_CONCAT(DISTINCT t.TaskName ORDER BY t.TaskName SEPARATOR ', ')) AS TasksNames
        ,COUNT(DISTINCT e.EmployeeID) AS TotalSubordinates
FROM ManagerHierarchy AS mh
LEFT JOIN company_structure.Departments AS d ON mh.DepartmentID = d.DepartmentID
LEFT JOIN company_structure.Roles AS r ON mh.RoleID = r.RoleID
LEFT JOIN company_structure.Projects AS p ON mh.DepartmentID = p.DepartmentID
LEFT JOIN company_structure.Tasks AS t ON mh.EmployeeID = t.AssignedTo
LEFT JOIN company_structure.Employees AS e ON mh.EmployeeID = e.ManagerID
GROUP BY mh.EmployeeID, mh.Name, mh.ManagerID, d.DepartmentName, r.RoleName
HAVING COUNT(DISTINCT e.EmployeeID) > 0
ORDER BY mh.Name;

