-- q4.sql
-- Tasa de fallo por tipo de transacción.
-- Denominador: todas las transacciones del tipo (completed, failed y pending).
-- No se filtra moneda: se cuentan eventos, no dinero.
SELECT
    transaction_type,
    COUNT(*) AS total_transacciones,
    SUM(CASE WHEN status = 'failed' THEN 1 ELSE 0 END) AS cantidad_fallidas,
    ROUND(
        100.0 * SUM(CASE WHEN status = 'failed' THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS tasa_fallo_pct
FROM transactions
GROUP BY transaction_type
ORDER BY tasa_fallo_pct DESC, transaction_type;
