# Practica2U5_Ociel - Centro Deportivo (MySQL)

Base de datos relacional de ejemplo para un **centro deportivo**, desarrollada en **MySQL 8.x**.

## Contenido del repositorio

- `centro_deportivo_mysql.sql`: script completo con la creación de la base de datos, tablas, relaciones, datos de ejemplo y una vista de consulta.

## Estructura de la base de datos

| Tabla | Registros | Relaciones |
|---|---:|---|
| `socios` | 10 | - |
| `entrenadores` | 10 | - |
| `instalaciones` | 10 | - |
| `actividades` | 12 | `entrenador_id` -> `entrenadores`, `instalacion_id` -> `instalaciones` |
| `inscripciones` | 12 | `socio_id` -> `socios`, `actividad_id` -> `actividades` |
| `pagos` | 12 | `socio_id` -> `socios` |

```
entrenadores ---< actividades >--- instalaciones
                       |
socios ---< inscripciones >--- actividades
   \---< pagos
```

## Características

- Claves primarias autoincrementales.
- Claves foráneas con `ON DELETE` / `ON UPDATE`.
- Restricciones `CHECK` y `ENUM` para validar datos.
- Índices sobre las claves foráneas.
- Vista `v_actividades_detalle` con actividad, entrenador, instalación e inscritos.

## Cómo importar en MySQL Workbench

1. Abre MySQL Workbench y conéctate a tu servidor local.
2. Ve a **File > Open SQL Script** y selecciona `centro_deportivo_mysql.sql`.
3. Ejecuta el script con el botón del rayo (o `Ctrl + Shift + Enter`).
4. Refresca el panel **Schemas** y abre `centro_deportivo`.
5. Consulta la vista con:

```sql
SELECT * FROM centro_deportivo.v_actividades_detalle;
```

## Autor

Ociel Paredes
