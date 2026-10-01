# 📄 Documentación Técnica del Proyecto: EcoEat – Chef Virtual Anti-Desperdicio

---

## 👥 1. Distribución de Roles y Responsabilidades

| Rol | Integrante | Responsabilidades Claves Implementadas |
|---|---|---|
| **Integrante 1** | *Backend Lead (Flask & IA)* | Desarrollo del servidor en Python (Flask), configuración de CORS, integración con API de IA (Google Gemini) mediante prompt engineering y generador de respaldo resiliente. Exposición de los 4 métodos HTTP. |
| **Integrante 2** | *Flutter Lead (Mobile UI)* | Diseño de la interfaz de usuario en Flutter con estética moderna verde/ecológica: pantalla de ingreso de ingredientes, tarjetas con scroll para resultados de receta y diálogo de configuración de servidor. |
| **Integrante 3** | *Integration & State Lead* | Modelado de clases de datos en Dart (`Recipe`), serialización/deserialización JSON (`fromJson`/`toJson`), conexión HTTP con los endpoints del backend, control visual de carga (`CircularProgressIndicator`) y manejo de excepciones (`SnackBar`). |
| **Integrante 4** | *QA & Documentation Lead* | Diseño de la colección de pruebas en Postman v2.1.0 cubriendo los 4 endpoints HTTP, validación de códigos de estado (200/201 OK) y redacción de la presente documentación técnica. |

---

## 🏗️ 2. Arquitectura General del Sistema

El sistema sigue una arquitectura cliente-servidor desacoplada basada en microservicios ligeros:

```
┌──────────────────────────────┐
│   Aplicación Móvil Flutter   │
│   (Mobile UI / Dart Models)  │
└──────────────┬───────────────┘
               │
               │ Peticiones HTTP REST (JSON)
               ▼
┌──────────────────────────────┐       API Key / Prompt       ┌──────────────────────────────┐
│    Backend Servidor Flask    ├─────────────────────────────►│    Google Gemini AI API      │
│     (Python 3.11 / REST)     │◄─────────────────────────────┤ (Model: gemini-1.5-flash)    │
└──────────────┬───────────────┘    Respuesta JSON Receta     └──────────────────────────────┘
               │
               ▼
┌──────────────────────────────┐
│ Base de Datos en Memoria DB  │
│    (Dict In-Memory Python)   │
└──────────────────────────────┘
```

1. **Capa Frontend (Flutter)**: Interfaz responsiva desarrollada en Dart que captura los ingredientes del usuario, consulta sugerencias, envía peticiones `POST` para generar recetas y gestiona la visualización del resultado.
2. **Capa Backend (Flask)**: Servidor RESTful escrito en Python que actúa como orquestador, procesa los prompts de IA y gestiona el estado en memoria de las recetas.
3. **Capa de Inteligencia Artificial (Google Gemini)**: Modelo LLM consultado mediante prompt engineering para estructurar la receta y consejos anti-desperdicio en formato JSON estricto.

---

## 📡 3. Tabla de Especificación de Endpoints HTTP

| Endpoint / Ruta | Método HTTP | Payload de Entrada (JSON) | Respuesta Exitosa (Status / JSON Output) | Descripción y Propósito |
|---|---|---|---|---|
| `/api/ingredientes/sugeridos` | **GET** | *Sin Body* | `200 OK`<br>`{ "ingredientes": ["Tomate", "Cebolla", ...], "total": 20 }` | Retorna la lista predeterminada de ingredientes comunes para el autocompletado en Flutter. |
| `/api/receta/generar` | **POST** | `{ "ingredientes": ["Tomate", "Huevo", "Cebolla"] }` | `201 Created`<br>`{ "id": 1, "titulo": "...", "tiempo": "20 min", "dificultad": "Fácil", "porciones": 2, "ingredientes": [...], "pasos": [...], "tip_antidesperdicio": "...", "favorito": false, "fecha_creacion": "..." }` | Procesa los ingredientes mediante prompt engineering con la API de IA (Gemini) y almacena la receta generada en memoria. |
| `/api/historial/favorito` | **PUT** | `{ "id": 1, "favorito": true }` | `200 OK`<br>`{ "mensaje": "Estado de favorito actualizado con éxito", "receta": { ... } }` | Marca o desmarca una receta guardada como favorita en la base de datos en memoria. |
| `/api/historial/<id>` | **DELETE** | *Sin Body* | `200 OK`<br>`{ "id": 1, "mensaje": "Receta '...' eliminada correctamente del historial." }` | Elimina la receta con el ID especificado del historial del servidor. |
| `/api/historial` *(Auxiliar)* | **GET** | *Sin Body* | `200 OK`<br>`{ "total": 1, "recetas": [...] }` | Retorna todas las recetas actualmente almacenadas en la memoria del servidor. |

---

## 🧪 4. Resumen de Pruebas de QA con Postman

La colección `EcoEat.postman_collection.json` incluye casos de prueba automáticos para validar la resiliencia del API:

1. **`GET /api/ingredientes/sugeridos`**: Valida respuesta HTTP `200 OK` y presencia de la clave `ingredientes` tipo array.
2. **`POST /api/receta/generar`**: Valida código `201 Created`, estructura del esquema JSON de la receta (ID asignado, pasos, ingredientes y tip anti-desperdicio).
3. **`PUT /api/historial/favorito`**: Valida código `200 OK` y confirmación del cambio booleano `favorito: true`.
4. **`DELETE /api/historial/<id>`**: Valida eliminación exitosa con código `200 OK` y verificación posterior `404 Not Found` en caso de reintento.

---

## 🚀 5. Guía de Instalación y Ejecución Paso a Paso

### Requisitos Previos
- **Python 3.10+**
- **Flutter SDK 3.x+**
- **Postman** (para ejecutar la colección de pruebas)

### Paso 1: Ejecutar el Backend en Flask
```bash
# 1. Ingresar a la carpeta backend
cd backend

# 2. Instalar dependencias
pip install -r requirements.txt

# 3. (Opcional) Configurar la API Key de Gemini en el archivo .env
# GEMINI_API_KEY=tu_api_key_aqui

# 4. Iniciar el servidor
python app.py
```
*El servidor Flask estará escuchando en `http://127.0.0.1:5000`.*

### Paso 2: Ejecutar las Pruebas en Postman
1. Abrir **Postman**.
2. Hacer clic en **Import** y seleccionar el archivo `EcoEat.postman_collection.json`.
3. Ejecutar las peticiones enviando las solicitudes a `http://127.0.0.1:5000`.

### Paso 3: Ejecutar la Aplicación Móvil en Flutter
```bash
# 1. Ingresar a la carpeta frontend
cd frontend

# 2. Obtener paquetes de Dart
flutter pub get

# 3. Ejecutar en Chrome / Windows / Emulador
flutter run -d chrome
```

---

## 🛡️ 6. Resiliencia y Manejo de Excepciones

- **Backend (Flask)**: Si no se proporciona una API Key de Gemini o falla la conexión externa a Google Cloud, el servidor activa un **generador dinámico de respaldo (algorithmic fallback)** que construye recetas coherentes y estructuradas sin romper el contrato JSON ni retornar un error HTTP 500.
- **Frontend (Flutter)**: Si la petición de generación falla o se interrumpe la red, la app atrapa la excepción y despliega un mensaje visual descriptivo en un `SnackBar` rojo, manteniendo la estabilidad de la interfaz sin provocar crashes.
