-- stg_accounts
-- Puente cuenta -> usuario. stg_transactions no trae user_id, y el mart
-- necesita agrupar por usuario, así que se expone accounts con tipos limpios.

select
    account_id,
    user_id,
    account_type,
    cast(created_at as timestamp) as created_at
from {{ source('raw', 'accounts') }}
