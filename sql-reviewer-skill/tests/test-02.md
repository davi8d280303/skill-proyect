# Test 02
## Input

`examples/invalid.sql`.

## Expected behavior

Detectar DELETE no filtrado, DROP, SELECT *, lectura sin límite, NULL incorrecto, JOIN cartesiano, predicado no sargable, FLOAT monetario, convenciones mezcladas y concatenación dinámica.

## Actual behavior

La primera regla SEC-04 solo buscaba `+ user_input` y no detectó el ejemplo con prefijo de cadena. Se corrigió para exigir la combinación de literal, token de entrada y construcción SQL; la versión final lo detecta.

## Pass / Fail

Pass tras corrección.

## Problem detected

SEC-04 era demasiado estrecha para una concatenación de SQL observable.

## Modification made to the skill

Se formalizó SEC-04 con literal concatenado y token de entrada que construyen palabra clave, identificador o predicado.
