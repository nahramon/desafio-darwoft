-- stg_transactions
-- Capa de staging: una fila por transacción, con tipos correctos y sin transacciones fallidas.
-- Decisiones:
--   * Se excluye solo status = 'failed' (lo pide la consigna). Las 'pending' se conservan
--     para que otros modelos puedan usarlas; el mart filtra 'completed' por su cuenta.
--   * coalesce(status, ...) evita que un status NULL se descarte en silencio:
--     la fila se conserva y el test accepted_values de status la hace visible.
--   * is_credit = amount > 0. Un monto NULL da is_credit NULL (lo detecta el test not_null).

with source as (

    select * from {{ source('raw', 'transactions') }}

),

typed as (

    select
        transaction_id,
        account_id,
        cast(amount as decimal(18, 2)) as amount,
        currency,
        transaction_type,
        status,
        cast(created_at as timestamp)  as created_at
    from source
    where coalesce(status, 'unknown') <> 'failed'

)

select
    transaction_id,
    account_id,
    amount,
    currency,
    transaction_type,
    status,
    created_at,
    amount > 0 as is_credit
from typed
