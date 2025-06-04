WITH LowAvgCars AS (
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
    HAVING AVG(r.position) > 3.0
),
ClassLowAvgCount AS (
    SELECT
        class,
        COUNT(car) AS low_position_count,
        COUNT(DISTINCT r.race) AS race_count
    FROM Results r
    JOIN Cars c ON r.car = c.name
    WHERE c.class IN (SELECT class FROM LowAvgCars)
    GROUP BY class
)
SELECT
    lac.car as car_name,
    lac.class as car_class,
    lac.average_position,
    lac.race_count,
    lac.country as car_country,
    clac.race_count as total_races,
    clac.low_position_count
FROM LowAvgCars lac
JOIN ClassLowAvgCount clac ON lac.class = clac.class
ORDER BY clac.low_position_count DESC;
