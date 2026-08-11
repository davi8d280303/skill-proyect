# Reglas de seguridad

## SEC-01 — DELETE sin filtro efectivo

IF statement = `DELETE` AND (`WHERE` is absent OR its normalized predicate is a tautology (`1=1`, `TRUE`, `a=a`) OR is `LIKE '%'` / `LIKE '%%'`) THEN severity = `CRITICAL` AND do not recommend executing the statement.

Un DELETE puede eliminar toda la tabla. Un `WHERE` tautológico o un comodín que coincide con cualquier cadena no limita filas y no es una salvaguarda efectiva; por ello conserva la misma severidad que la ausencia de WHERE.

## SEC-02 — UPDATE sin filtro efectivo

IF statement = `UPDATE` AND (`WHERE` is absent OR its normalized predicate is a tautology (`1=1`, `TRUE`, `a=a`) OR is `LIKE '%'` / `LIKE '%%'`) THEN severity = `CRITICAL` AND do not recommend executing the statement.

Un UPDATE masivo puede alterar datos de forma irreversible. Los predicados formalmente presentes pero universalmente verdaderos no reducen ese riesgo.

## SEC-03 — DDL destructivo

IF statement begins with `DROP`, `TRUNCATE`, `ALTER TABLE ... DROP`, or `DELETE` targets a table and has no effective filter THEN severity = `HIGH` (or `CRITICAL` for SEC-01).

Estas operaciones destruyen estructura o datos. DROP/TRUNCATE se clasifican HIGH porque el texto por sí solo no informa si hay respaldo, entorno aislado o aprobación; no se presupone ninguno.

## SEC-04 — Concatenación dinámica evidente

IF SQL source contains a string literal concatenated with an input-like token (`user_input`, `request.`, `params.`, `@{`, `${`, `+`, `||`) to construct a SQL keyword, identifier, or predicate THEN severity = `HIGH`.

La combinación directa de entrada y sintaxis SQL permite alterar la consulta. Solo se marca la construcción observable; no se infiere inyección desde parámetros enlazados.

## SEC-05 — Predicado masivo con LIKE

IF `UPDATE` or `DELETE` WHERE predicate contains `LIKE '%'` or `LIKE '%%'` for any operand THEN severity = `HIGH` (and `CRITICAL` when SEC-01/02 applies).

El comodín no anclado coincide con cualquier valor no nulo. La regla separada conserva trazabilidad de la causa aunque la acción masiva eleve el riesgo.
