# Reglas de convenciones y semántica observable

## CONV-01 — Comparación incorrecta con NULL

IF a predicate contains `= NULL` or `<> NULL` or `!= NULL` THEN severity = `HIGH`.

NULL no se compara con igualdad SQL; el resultado es desconocido. Debe usarse `IS NULL` o `IS NOT NULL`, por lo que la consulta puede devolver o modificar filas inesperadamente.

## CONV-02 — Identificador poco descriptivo

IF a user-defined table, column, alias, or constraint identifier is one character long AND is not one of `i`, `j`, `k` used solely as a local numeric loop/index alias THEN severity = `LOW`.

Nombres de un carácter reducen la legibilidad. La excepción es formal y estrecha; no se juzga intención ni idioma.

## CONV-03 — Convención de identificadores inconsistente

IF two user-defined identifiers of the same kind in one statement use both snake_case and camelCase/PascalCase THEN severity = `LOW`.

Mezclar convenciones hace el SQL menos predecible. La condición compara formas léxicas, no impone una convención particular.

## CONV-04 — Tipo de dato potencialmente inadecuado

IF DDL declares `FLOAT`/`REAL` for an identifier whose normalized name contains `amount`, `price`, `money`, `saldo`, or `importe` THEN severity = `INFO`.

Valores monetarios en punto flotante pueden introducir redondeo binario. INFO permite revisar la intención y precisión requerida sin asumir que todo campo con ese nombre sea moneda.

## CONV-05 — Literales mágicos en predicados

IF WHERE/HAVING contains the same numeric or string literal three or more times in a single statement, excluding `0`, `1`, and NULL THEN severity = `LOW`.

La repetición dificulta mantenimiento. Se usa un conteo fijo y exclusiones explícitas para evitar señalar constantes estructurales comunes.
