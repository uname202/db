SELECT
    c.ID_customer,
    c.name,
    CASE
        WHEN MAX(CASE WHEN hotel_category = 'Дорогой' THEN 1 ELSE 0 END) = 1 THEN 'Дорогой'
        WHEN MAX(CASE WHEN hotel_category = 'Средний' THEN 1 ELSE 0 END) = 1 THEN 'Средний'
        ELSE 'Дешевый'
    END AS preferred_hotel_type,
    GROUP_CONCAT(DISTINCT h.name ORDER BY h.name SEPARATOR ', ') AS visited_hotels
FROM Booking b
JOIN Room r ON b.ID_room = r.ID_room
JOIN Hotel h ON r.ID_hotel = h.ID_hotel
JOIN Customer c ON b.ID_customer = c.ID_customer
JOIN (
    SELECT
        h.ID_hotel,
        CASE
            WHEN AVG(r.price) < 175 THEN 'Дешевый'
            WHEN AVG(r.price) BETWEEN 175 AND 300 THEN 'Средний'
            ELSE 'Дорогой'
        END AS hotel_category
    FROM Room r
    JOIN Hotel h ON r.ID_hotel = h.ID_hotel
    GROUP BY h.ID_hotel
) AS hotel_categories ON h.ID_hotel = hotel_categories.ID_hotel
GROUP BY c.ID_customer
ORDER BY
    CASE
        WHEN MAX(CASE WHEN hotel_category = 'Дорогой' THEN 1 ELSE 0 END) = 1 THEN 3
        WHEN MAX(CASE WHEN hotel_category = 'Средний' THEN 1 ELSE 0 END) = 1 THEN 2
        ELSE 1
    END;
