# Test 03
## Input

`DELETE FROM TA_USERS WHERE 1 = 1;`.

## Expected behavior

Emitir SEC-01 `CRITICAL` y no recomendar ejecución.

## Actual behavior

La primera versión comprobaba solo ausencia sintáctica de WHERE y habría permitido el caso. Se añadió normalización de tautologías (`1=1`, `TRUE`, `a=a`) y el resultado final es SEC-01 `CRITICAL`.

## Pass / Fail

Pass tras corrección.

## Problem detected

Presencia de WHERE no equivalía a filtro efectivo.

## Modification made to the skill

SEC-01 y SEC-02 exigen un predicado no tautológico ni `LIKE '%'`/`'%%'`.
