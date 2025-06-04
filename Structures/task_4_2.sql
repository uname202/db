WITH RECURSIVE EmployeeHierarchy AS (
    SELECT
        e.EmployeeID,
        e.Name,
        e.ManagerID,
        e.DepartmentID,
        e.RoleID,
        0 AS Level
    FROM Employees e
    WHERE e.EmployeeID = 1

    UNION ALL

    SELECT
        e.EmployeeID,
        e.Name,
        e.ManagerID,
        e.DepartmentID,
        e.RoleID,
        eh.Level + 1
    FROM Employees e
    JOIN EmployeeHierarchy eh ON e.ManagerID = eh.EmployeeID
),

SubordinateCount AS (
    SELECT
        ManagerID,
        COUNT(*) AS DirectSubordinatesCount
    FROM Employees
    WHERE ManagerID IS NOT NULL
    GROUP BY ManagerID
),

EmployeeProjects AS (
    SELECT
        e.EmployeeID,
        GROUP_CONCAT(DISTINCT p.ProjectName ORDER BY p.ProjectName SEPARATOR ', ') AS Projects
    FROM Employees e
    JOIN Departments d ON e.DepartmentID = d.DepartmentID
    LEFT JOIN Projects p ON d.DepartmentID = p.DepartmentID
    GROUP BY e.EmployeeID
),

EmployeeTasks AS (
    SELECT
        t.AssignedTo AS EmployeeID,
        GROUP_CONCAT(DISTINCT t.TaskName ORDER BY t.TaskName SEPARATOR ', ') AS Tasks,
        COUNT(*) AS TaskCount
    FROM Tasks t
    GROUP BY t.AssignedTo
)

SELECT
    eh.EmployeeID,
    eh.Name,
    eh.ManagerID,
    d.DepartmentName,
    r.RoleName,
    ep.Projects,
    et.Tasks,
    et.TaskCount AS TotalTasks,
    IFNULL(sc.DirectSubordinatesCount, 0) AS DirectSubordinatesCount
FROM
    EmployeeHierarchy eh
LEFT JOIN Departments d ON eh.DepartmentID = d.DepartmentID
LEFT JOIN Roles r ON eh.RoleID = r.RoleID
LEFT JOIN EmployeeProjects ep ON eh.EmployeeID = ep.EmployeeID
LEFT JOIN EmployeeTasks et ON eh.EmployeeID = et.EmployeeID
LEFT JOIN SubordinateCount sc ON eh.EmployeeID = sc.ManagerID
WHERE
    eh.EmployeeID != 1  -- Исключаем самого Ивана Иванова
ORDER BY
    eh.Name;