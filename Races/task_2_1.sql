WITH AvgPositions AS (
    SELECT
    	r.car as car_name,
        c.class as car_class,
        AVG(r.position) AS avg_position,
        COUNT(r.race) AS race_count
    FROM Results r
    JOIN Cars c ON r.car = c.name
    GROUP BY car_class, car_name
),
MinAvgPositions AS (
    SELECT
        car_class,
        MIN(avg_position) AS min_avg_position
    FROM AvgPositions
    GROUP BY car_class
)
SELECT
    ap.car_name,
    ap.car_class,
    ap.avg_position,
    ap.race_count
FROM AvgPositions ap
JOIN MinAvgPositions map ON ap.car_class = map.car_class AND ap.avg_position = map.min_avg_position
ORDER BY ap.avg_position;
