SELECT
    c.ID_customer,
    c.name,
    COUNT(b.ID_booking) AS total_bookings,
    COUNT(DISTINCT h.ID_hotel) AS unique_hotels,
    SUM(DATEDIFF(b.check_out_date, b.check_in_date) * r.price) AS total_spent
FROM Booking b
JOIN Room r ON b.ID_room = r.ID_room
JOIN Hotel h ON r.ID_hotel = h.ID_hotel
JOIN Customer c ON b.ID_customer = c.ID_customer
GROUP BY c.ID_customer
HAVING COUNT(b.ID_booking) > 2
   AND COUNT(DISTINCT h.ID_hotel) > 1
   AND total_spent > 500
ORDER BY total_spent ASC;