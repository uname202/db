WITH ClassAvgPositions AS (
    SELECT
        c.class,
        AVG(r.position) AS class_avg_position,
        COUNT(DISTINCT r.race) AS total_races
    FROM Results r
    JOIN Cars c ON r.car = c.name
    GROUP BY c.class
),
MinClassAvgPosition AS (
    SELECT
        MIN(class_avg_position) AS min_class_avg_position
    FROM ClassAvgPositions
),
AvgPositions AS (
    SELECT
        c.class,
        r.car,
        AVG(r.position) AS average_position,
        COUNT(r.race) AS race_count,
        cl.country,
        cap.total_races
    FROM Results r
    JOIN Cars c ON r.car = c.name
    JOIN Classes cl ON c.class = cl.class
    JOIN ClassAvgPositions cap ON c.class = cap.class
    WHERE cap.class_avg_position = (SELECT min_class_avg_position FROM MinClassAvgPosition)
    GROUP BY c.class, r.car, cl.country, cap.total_races
)
SELECT
    ap.car as car_name,
    ap.class as car_class,
    ap.average_position,
    ap.race_count,
    ap.country as car_country,
    ap.total_races
FROM AvgPositions ap
ORDER BY ap.class, ap.car;
