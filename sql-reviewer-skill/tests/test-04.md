# Test 04
## Input

`SELECT id FROM orders WHERE customer_id = :id;` sin esquema, índices, volumen ni plan.

## Expected behavior

No afirmar que falta un índice ni que la consulta es lenta; declarar índices de `customer_id` como `INSUFFICIENT_INFO`.

## Actual behavior

Se produjo únicamente `INSUFFICIENT_INFO` para los índices y no se inventaron metadatos.

## Pass / Fail

Pass.

## Problem detected

Ninguno en la versión final.

## Modification made to the skill

No aplica.
