-- q3.sql
-- Saldo acumulado (running balance) por cuenta, transacción por transacción.
-- Solo transacciones completadas. El acumulado se calcula por cuenta Y moneda:
-- varias cuentas operan en ARS y USD y no se pueden sumar entre sí.
SELECT
    account_id,
    currency,
    transaction_id,
    created_at,
    amount,
    SUM(amount) OVER (
        PARTITION BY account_id, currency
        ORDER BY created_at, transaction_id
    ) AS saldo_acumulado
FROM transactions
WHERE status = 'completed'
ORDER BY account_id, currency, created_at, transaction_id;
