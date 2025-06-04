WITH AvgPositions AS (
    SELECT
        c.class,
        r.car,
        AVG(r.position) AS avg_position,
        COUNT(r.race) AS race_count,
        cl.country
    FROM Results r
    JOIN Cars c ON r.car = c.name
    JOIN Classes cl ON c.class = cl.class
    GROUP BY c.class, r.car, cl.country
),
MinAvgPosition AS (
    SELECT
        MIN(avg_position) AS min_avg_position
    FROM AvgPositions
)
SELECT
    ap.car as car_name,
    ap.class as car_class,
    ap.avg_position as average_position,
    ap.race_count,
    ap.country as car_country
FROM AvgPositions ap
JOIN MinAvgPosition map ON ap.avg_position = map.min_avg_position
ORDER BY ap.car
LIMIT 1;
