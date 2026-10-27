-- mart_user_activity
-- Actividad por usuario, mes y moneda (solo transacciones completadas).
-- Decisiones:
--   * Grano = usuario x mes x moneda. No se suman ARS con USD (no hay tipo de cambio),
--     así que la moneda forma parte del grano.
--   * Solo status = 'completed': stg_transactions conserva 'pending', el mart no las cuenta.
--   * total_credits  = suma de montos positivos (depósitos y transferencias entrantes).
--     total_debits   = suma de montos negativos, expresada como magnitud positiva
--     (pagos y retiros). net_balance = total_credits - total_debits = SUM(amount).
--   * Mart "disperso": un usuario sin actividad completada en un mes no genera fila.

with completed_transactions as (

    select
        account_id,
        currency,
        amount,
        is_credit,
        cast(date_trunc('month', created_at) as date) as activity_month
    from {{ ref('stg_transactions') }}
    where status = 'completed'

),

accounts as (

    select
        account_id,
        user_id
    from {{ ref('stg_accounts') }}

),

user_transactions as (

    select
        a.user_id,
        t.activity_month,
        t.currency,
        t.amount,
        t.is_credit
    from completed_transactions as t
    inner join accounts as a
        on a.account_id = t.account_id

),

monthly_activity as (

    select
        user_id,
        activity_month,
        currency,
        count(*)                                           as completed_transactions,
        sum(case when is_credit then amount else 0 end)    as total_credits,
        sum(case when is_credit then 0 else -amount end)   as total_debits,
        sum(amount)                                        as net_balance
    from user_transactions
    group by
        user_id,
        activity_month,
        currency

)

select
    concat(cast(user_id as varchar), '|', cast(activity_month as varchar), '|', currency) as user_month_currency_key,
    user_id,
    activity_month,
    currency,
    completed_transactions,
    total_credits,
    total_debits,
    net_balance
from monthly_activity
