-- q5.sql
-- Usuarios registrados en enero 2024 con al menos una transacción completada
-- en cada uno de los dos meses calendario siguientes (febrero y marzo 2024).
-- No se filtra moneda: se cuentan eventos, no dinero.
SELECT
    u.user_id
FROM users u
JOIN accounts a
  ON a.user_id = u.user_id
JOIN transactions t
  ON t.account_id = a.account_id
WHERE u.signup_date >= '2024-01-01'
  AND u.signup_date <  '2024-02-01'
  AND t.status      = 'completed'
  AND t.created_at >= '2024-02-01'
  AND t.created_at <  '2024-04-01'
GROUP BY u.user_id
HAVING COUNT(DISTINCT DATE_FORMAT(t.created_at, '%Y-%m')) = 2
ORDER BY u.user_id;
