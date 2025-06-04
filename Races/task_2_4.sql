WITH ClassAvgPositions AS (
    SELECT
        c.class,
        AVG(r.position) AS class_avg_position,
        COUNT(c.name) AS car_count
    FROM Results r
    JOIN Cars c ON r.car = c.name
    GROUP BY c.class
    HAVING COUNT(c.name) > 1
),
AvgPositions AS (
    SELECT
        c.class,
        r.car,
        AVG(r.position) AS average_position,
        COUNT(r.race) AS race_count,
        cl.country
    FROM Results r
    JOIN Cars c ON r.car = c.name
    JOIN Classes cl ON c.class = cl.class
    GROUP BY c.class, r.car, cl.country
),
FilteredCars AS (
    SELECT
        ap.class,
        ap.car,
        ap.average_position,
        ap.race_count,
        ap.country
    FROM AvgPositions ap
    JOIN ClassAvgPositions cap ON ap.class = cap.class
    WHERE ap.average_position < cap.class_avg_position
)
SELECT
    fc.car as car_name,
	fc.class as car_class,
    fc.average_position,
    fc.race_count,
    fc.country as car_country
FROM FilteredCars fc
ORDER BY fc.class, fc.average_position;
