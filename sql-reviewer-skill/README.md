# sql-reviewer

## Uso

Entregar SQL completo, dialecto y cualquier metadato disponible (esquema, índices, tipos y conteo de filas). La skill sigue el orden fijo de `SKILL.md`, aplica las reglas identificadas y devuelve evidencia y estado. No ejecuta sentencias.

## Por qué no es un prompt largo

Su procedimiento es fijo; cada hallazgo necesita una condición `IF/THEN` y un ID trazable; el contrato `INSUFFICIENT_INFO` impide inventar metadatos; define cuándo no activarse; y conserva cinco pruebas versionadas. Las reglas están separadas por categoría y se resuelven conflictos por una prioridad explícita.

## Historial de iteración

La prueba 02 reveló que SEC-04 solo detectaba una forma estrecha de concatenación y se extendió a construcción observable con literal y entrada. La prueba 03 mostró que comprobar la presencia de WHERE permitía `WHERE 1 = 1`; SEC-01/02 ahora evalúan tautologías y comodines universales. La prueba 05 llevó a combinar límite absoluto y proporcional, evitando la evasión con 9,999 cuando hay conteo de filas.

## Limitaciones conocidas

No interpreta SQL no parseable, no ejecuta planes, no conoce permisos ni respaldos, y no puede concluir sobre índices, selectividad, volumen o tipos reales sin metadatos. Para dialecto no declarado, solo revisa reglas agnósticas. Su detección de concatenación cubre patrones evidentes en el texto, no el flujo completo de una aplicación.
