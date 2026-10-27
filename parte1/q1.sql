-- q1.sql
-- Transacciones completadas por mes, solo moneda ARS
SELECT
    DATE_FORMAT(created_at, '%Y-%m') AS mes,
    COUNT(*)                         AS cantidad_transacciones,
    SUM(amount)                      AS monto_total
FROM transactions
WHERE status   = 'completed'
  AND currency = 'ARS'
GROUP BY DATE_FORMAT(created_at, '%Y-%m')
ORDER BY mes;
