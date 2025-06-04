SELECT v.maker, c.model, c.horsepower, c.engine_capacity, 'Car' AS type
FROM Car c
JOIN Vehicle v ON c.model = v.model
WHERE c.horsepower > 150
  AND c.engine_capacity < 3
  AND c.price < 35000

UNION

SELECT v.maker, m.model, m.horsepower, m.engine_capacity, 'Motorcycle' AS type
FROM Motorcycle m
JOIN Vehicle v ON m.model = v.model
WHERE m.horsepower > 150
  AND m.engine_capacity < 1.5
  AND m.price < 20000

UNION

SELECT v.maker, b.model, NULL AS horsepower, NULL AS engine_capacity, 'Bicycle' AS type
FROM Bicycle b
JOIN Vehicle v ON b.model = v.model
WHERE b.gear_count > 18
  AND b.price < 4000

ORDER BY horsepower DESC;
