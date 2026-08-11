# Reglas de rendimiento

## PERF-01 — SELECT *

IF a `SELECT` projection contains bare `*` or `table_alias.*` THEN severity = `MEDIUM`.

La proyección implícita aumenta transferencia y acopla consumidores a cambios de esquema. No requiere conocer el motor para comprobarse.

## PERF-02 — Consulta masiva sin LIMIT efectivo

IF top-level statement = `SELECT` AND has no `WHERE` AND has no effective `LIMIT`/`FETCH FIRST`/`TOP` THEN severity = `MEDIUM`.

Una lectura sin filtro ni límite puede devolver toda la fuente. Se limita a SELECT superior para no inventar cardinalidades de subconsultas.

## PERF-03 — LIMIT inefectivo

IF top-level `SELECT` has no `WHERE` AND (its numeric LIMIT is greater than 10,000 OR, when a declared table row count is available, LIMIT equals/exceeds one tenth of that count) THEN severity = `MEDIUM`.

Un límite enorme no es una protección real. El umbral combina un máximo absoluto con proporcionalidad cuando se aporta volumen: elegir 9,999 no evade la regla si sigue alcanzando al menos 10% de la tabla. Si no hay conteo de filas, aplicar solo el límite absoluto; no adivinar el volumen.

## PERF-04 — Predicado no sargable

IF WHERE or JOIN predicate applies `LOWER`, `UPPER`, `DATE`, `CAST`, or arithmetic to a column on its left or right side of a comparison THEN severity = `MEDIUM`.

Transformar la columna puede impedir utilizar un índice convencional. No afirma que el plan sea lento ni que no exista un índice funcional.

## PERF-05 — JOIN cartesiano explícito

IF statement contains `CROSS JOIN` OR `JOIN` followed by `ON 1=1` THEN severity = `HIGH`.

El producto cartesiano multiplica filas y suele ser costoso. Se marca por construcción explícita, sin estimar cantidades.

## PERF-06 — Índice potencialmente faltante

IF a column is used in WHERE/JOIN/ORDER BY AND schema metadata does not state whether it is indexed THEN emit `INSUFFICIENT_INFO`: “índices de <columna> no proporcionados”; IF metadata states it is unindexed THEN severity = `INFO`.

El SQL no revela índices. INFO señala una oportunidad de verificación, no afirma que deba crearse uno sin selectividad, carga de escritura y plan.
