# 2.d — Materialización a 50M de filas por mes

1. **`stg_transactions` → `incremental`** (`unique_key = transaction_id`, estrategia merge o delete+insert). Como `view` cada consumo recalcularía casts y filtros sobre cientos de millones de filas; como `table` se reconstruiría el histórico completo en cada corrida.
2. Cada corrida procesa solo las filas nuevas y una ventana de reproceso corta (p. ej. 3 días por `created_at`), porque una transacción puede pasar de `pending` a `completed` o `failed` después de creada.
3. Se particiona (o clusteriza) por `created_at` para que el filtro incremental lea solo las particiones recientes.
4. **`mart_user_activity` → `incremental`**, con `unique_key = user_month_currency_key` y recalculando solo los meses que tuvieron filas nuevas o modificadas; el agregado resultante es órdenes de magnitud más chico que la fuente.
5. Costo: se escanean ~50M filas por mes de datos nuevos en lugar de ~600M al año con cada ejecución completa.
6. Frecuencia: una corrida diaria alcanza para un mart mensual de actividad; si negocio pide datos intradía, solo se acorta el schedule del incremental, sin rediseñar los modelos.
7. Se programa un `--full-refresh` periódico (mensual o ante cambios de lógica) para corregir cualquier deriva acumulada.
8. Si el volumen fuera bajo o la actualización poco frecuente, `view` en staging y `table` en el mart serían más simples; a 50M por mes ese ahorro de complejidad no compensa el costo de cómputo.
