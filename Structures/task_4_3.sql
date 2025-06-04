WITH RECURSIVE ManagerSubordinates AS (
    SELECT
        m.EmployeeID AS ManagerID,
        e.EmployeeID AS SubordinateID,
        1 AS Level
    FROM Employees m
    JOIN Employees e ON e.ManagerID = m.EmployeeID
    JOIN Roles r ON m.RoleID = r.RoleID
    WHERE r.RoleName = 'Менеджер'

    UNION ALL

    SELECT
        ms.ManagerID,
        e.EmployeeID,
        ms.Level + 1
    FROM ManagerSubordinates ms
    JOIN Employees e ON e.ManagerID = ms.SubordinateID
),

ManagerInfo AS (
    SELECT
        ms.ManagerID,
        COUNT(DISTINCT ms.SubordinateID) AS TotalSubordinates
    FROM ManagerSubordinates ms
    GROUP BY ms.ManagerID
)

SELECT
    m.EmployeeID,
    m.Name,
    m.ManagerID,
    d.DepartmentName,
    r.RoleName,
    GROUP_CONCAT(DISTINCT p.ProjectName ORDER BY p.ProjectName SEPARATOR ', ') AS Projects,
    GROUP_CONCAT(DISTINCT t.TaskName ORDER BY t.TaskName SEPARATOR ', ') AS Tasks,
    mi.TotalSubordinates
FROM
    Employees m
JOIN Roles r ON m.RoleID = r.RoleID
JOIN Departments d ON m.DepartmentID = d.DepartmentID
LEFT JOIN Projects p ON d.DepartmentID = p.DepartmentID
LEFT JOIN Tasks t ON t.AssignedTo = m.EmployeeID
JOIN ManagerInfo mi ON m.EmployeeID = mi.ManagerID
WHERE
    r.RoleName = 'Менеджер'
GROUP BY
    m.EmployeeID, m.Name, m.ManagerID, d.DepartmentName, r.RoleName, mi.TotalSubordinates
ORDER BY
    mi.TotalSubordinates DESC, m.Name;