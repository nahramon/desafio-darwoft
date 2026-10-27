# Darwoft · Take-Home Analytics Engineer

## Estructura

| Carpeta   | Contenido                                                                                                                                |
| --------- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| `parte1/` | `q1.sql` a `q5.sql` (MySQL 9, probadas en DB Fiddle)                                                                                     |
| `parte2/` | Proyecto dbt: `models/staging`, `models/marts`, `schema.yml`, `respuesta_2d.md`                                                          |
| `parte3/` | `analisis_parte3.html`: notebook exportado con los hallazgos, las queries y los supuestos; `tablero_parte3.pdf`: tablero de Power BI |

## Decisiones y supuestos principales

- **Monedas mixtas (ARS y USD, sin tipo de cambio):** nunca se suman entre sí. Q1 filtra ARS porque lo pide la consigna; Q2, Q3, el mart de dbt y el tablero informan por moneda; Q4 y Q5 cuentan eventos y no filtran moneda.
- **Estados:** Q1 a Q3 usan solo `completed`. En dbt, staging excluye solo `failed` (como pide la consigna) y el mart filtra `completed`. En Q4 el denominador incluye todos los estados.
- **Usuarios sin transacciones:** Q2 los conserva (saldo 0). El mart dbt es disperso: no genera filas para meses sin actividad.
- **Q5:** "los 2 meses siguientes" se interpreta como los dos meses calendario posteriores al de registro (febrero y marzo de 2024). Con ventanas móviles desde la fecha exacta de registro el resultado sería 20 usuarios en lugar de 19.
- **dbt:** se agregó `stg_accounts` porque `transactions` no trae `user_id`. El grano del mart es usuario × mes × moneda.
- **Parte 3:** las cifras del tablero coinciden con las queries del notebook. Las causas de la caída de mayo y de los fallos de retiro son hipótesis: los datos muestran qué pasó, no por qué.
- **Calidad de datos:** el 22,6% de las transacciones es anterior a la creación de su cuenta; se reporta y no se filtra.
