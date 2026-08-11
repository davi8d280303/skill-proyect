---
name: sql-reviewer
description: Analizar sentencias o scripts SQL como revisor técnico mediante reglas deterministas, trazables y documentadas. Usar para detectar riesgos de seguridad, rendimiento, tipos, NULL e incumplimientos de convenciones en SQL con dialecto declarado; no usar para diseñar esquemas, ejecutar SQL ni reemplazar una auditoría con metadatos ausentes.
---

# SQL Reviewer
## Purpose

Revisar SQL estático con reglas de ID único, sin inferir esquema, motor, volúmenes ni intención no incluidos en la entrada.

## When to activate

Activar ante una o más sentencias SQL completas para revisión técnica, con dialecto declarado o sintaxis estándar no ambigua.

## When NOT to activate

No activar si el input no es SQL; si el SQL está incompleto o no se puede separar y clasificar una sentencia; ni cuando la petición exige decidir índices, tipos, permisos, planes o cardinalidad sin el esquema, motor o datos requeridos. En esos casos devolver `INSUFFICIENT_INFO` o `NOT_APPLICABLE`, sin hallazgos especulativos.

## Inputs

Recibir: SQL, dialecto (o `UNDECLARED`) y, opcionalmente, esquema con tipos, claves e índices. Ignorar comentarios como evidencia de seguridad. Distinguir literales, identificadores y comentarios antes de evaluar reglas.

## Procedure

1. Verificar que el input es SQL completo; si falla, detenerse según *Failure handling*.
2. Tokenizar y separar sentencias sin evaluar texto dentro de literales o comentarios.
3. Clasificar cada sentencia: `SELECT`, `INSERT`, `UPDATE`, `DELETE`, DDL, transacción u otra.
4. Evaluar todas las reglas en orden fijo: `security.md`, `performance.md`, `conventions.md`, y dentro de cada archivo por ID ascendente.
5. Para cada condición verdadera, emitir un hallazgo con su ID y evidencia textual; para una condición que requiere datos ausentes, emitir solo `INSUFFICIENT_INFO`.
6. Agrupar duplicados por fragmento y regla; resolver conflictos con la prioridad definida en *Validation*.
7. Generar el reporte con el formato de *Expected output*.

## Rules

| ID | Categoría | Resumen | Severidad base | Referencia |
|---|---|---|---|---|
| SEC-01 | Seguridad | DELETE sin filtro efectivo | CRITICAL | rules/security.md |
| SEC-02 | Seguridad | UPDATE sin filtro efectivo | CRITICAL | rules/security.md |
| SEC-03 | Seguridad | DDL destructivo | HIGH | rules/security.md |
| SEC-04 | Seguridad | Concatenación dinámica evidente | HIGH | rules/security.md |
| SEC-05 | Seguridad | Predicado masivo con LIKE | HIGH | rules/security.md |
| PERF-01 | Rendimiento | SELECT * | MEDIUM | rules/performance.md |
| PERF-02 | Rendimiento | Consulta masiva sin LIMIT efectivo | MEDIUM | rules/performance.md |
| PERF-03 | Rendimiento | LIMIT inefectivo | MEDIUM | rules/performance.md |
| PERF-04 | Rendimiento | Predicado no sargable | MEDIUM | rules/performance.md |
| PERF-05 | Rendimiento | JOIN cartesiano explícito | HIGH | rules/performance.md |
| PERF-06 | Rendimiento | Índice potencialmente faltante | INFO | rules/performance.md |
| CONV-01 | Convenciones | Comparación incorrecta con NULL | HIGH | rules/conventions.md |
| CONV-02 | Convenciones | Identificador poco descriptivo | LOW | rules/conventions.md |
| CONV-03 | Convenciones | Convención de identificadores inconsistente | LOW | rules/conventions.md |
| CONV-04 | Convenciones | Tipo de dato potencialmente inadecuado | INFO | rules/conventions.md |
| CONV-05 | Convenciones | Literales mágicos en predicados | LOW | rules/conventions.md |

## Severity levels

Usar exactamente: `CRITICAL` (no recomendar ejecutar), `HIGH` (riesgo serio), `MEDIUM` (riesgo relevante), `LOW` (mantenibilidad), `INFO` (revisión humana necesaria). `INSUFFICIENT_INFO` es estado, no severidad.

## Expected output

Emitir: dialecto usado; estado (`REVIEWED`, `INSUFFICIENT_INFO` o `NOT_APPLICABLE`); por hallazgo: severidad, ID, sentencia, evidencia, motivo, acción; y una sección `Información insuficiente` con el dato exacto faltante. No emitir hallazgos sin ID.

## Validation

Antes de emitir, comprobar que cada hallazgo tiene una condición `IF/THEN` verdadera en `rules/`, ID listado arriba y evidencia. Si dos reglas cubren el mismo fragmento, conservar ambas solo si describen riesgos distintos; si describen el mismo riesgo, conservar la mayor severidad y, en empate, el ID lexicográficamente menor. Esta prioridad evita diluir el riesgo y mantiene una salida reproducible.

## Failure handling

SQL no parseable o incompleto: `NOT_APPLICABLE`, explicar el punto de fallo y no evaluar reglas. Dialecto no declarado: evaluar únicamente reglas dialecto-agnósticas; para sintaxis o semántica dependiente del motor, `INSUFFICIENT_INFO`. Datos requeridos pero ausentes (índices, tipos reales, volumen, plan): declarar el dato faltante; nunca asumirlo ni escalar una severidad por conjetura.
