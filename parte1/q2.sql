-- q2.sql
-- Saldo neto por usuario y moneda (solo transacciones completadas).
-- Supuesto: no se suman monedas distintas; el saldo se informa por moneda.
-- Usuarios sin transacciones completadas aparecen una vez, con currency NULL y saldo 0.
WITH saldo_por_moneda AS (
    SELECT
        a.user_id,
        t.currency,
        SUM(t.amount) AS saldo_neto
    FROM accounts a
    JOIN transactions t
      ON t.account_id = a.account_id
    WHERE t.status = 'completed'
    GROUP BY a.user_id, t.currency
)
SELECT
    u.user_id,
    s.currency,
    COALESCE(s.saldo_neto, 0) AS saldo_neto
FROM users u
LEFT JOIN saldo_por_moneda s
       ON s.user_id = u.user_id
ORDER BY
    s.currency IS NULL,          -- los usuarios sin movimientos van al final
    s.currency,
    saldo_neto DESC,
    u.user_id;
