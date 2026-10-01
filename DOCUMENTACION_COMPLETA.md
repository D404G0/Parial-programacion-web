# 🌿 EcoEat – Chef Virtual Anti-Desperdicio
> **Examen Parcial / Proyecto Integrador**
> **Backend:** Python (Flask & IA Google Gemini) | **Frontend:** Flutter (Dart) | **QA:** Postman Collection | **DevOps:** Docker & Docker Compose

---

## 📋 1. Información General y Caso de Estudio

**EcoEat** es una solución tecnológica desarrollada para combatir el desperdicio de alimentos en los hogares. Permite a los usuarios registrar los ingredientes disponibles en su cocina para generar recetas de aprovechamiento personalizadas y nutritivas mediante **Inteligencia Artificial (Google Gemini API / OpenAI)**.

---

## 👥 2. Distribución de Roles del Equipo

| Rol | Integrante | Responsabilidades Claves |
|---|---|---|
| **Backend Lead (Flask & IA)** | Integrante 1 | Desarrolla el servidor Flask, implementa la integración con la API de IA (Gemini/ChatGPT), diseña los prompts y expone los 4 métodos HTTP. |
| **Flutter Lead (Mobile UI)** | Integrante 2 | Diseña e implementa la interfaz gráfica en Flutter (pantalla de captura de ingredientes, pantalla de resultado de receta y diálogo de configuración). |
| **Integration & State Lead** | Integrante 3 | Conecta Flutter con el Backend consumiendo los endpoints HTTP. Modela las clases de datos (`Recipe`), parsea el JSON y maneja estados (Loading/Error). |
| **QA & Documentation Lead** | Integrante 4 | Diseña la colección de pruebas en Postman para los 4 endpoints, verifica la calidad de respuesta y redacta la Documentación Técnica del proyecto. |

---

## 🏗️ 3. Arquitectura del Sistema

```
┌────────────────────────────────────────────────────────┐
│               APLICACIÓN MÓVIL (FLUTTER)               │
│  [IngredientScreen] ──► [RecipeResultScreen] ──► UI   │
└───────────────────────────┬────────────────────────────┘
                            │
                            │ Peticiones HTTP REST (JSON)
                            ▼
┌────────────────────────────────────────────────────────┐
│                 BACKEND SERVER (FLASK)                 │
│  [GET /sugeridos]  [POST /generar]  [PUT]  [DELETE]    │
└─────────────┬──────────────────────────┬───────────────┘
              │                          │
   Prompt JSON│                          │ Dict In-Memory
              ▼                          ▼
┌──────────────────────────┐    ┌─────────────────────────┐
│   GOOGLE GEMINI AI API   │    │   HISTORIAL DB (MEM)    │
│  (gemini-1.5-flash)      │    │ { id: 1, receta: ... }  │
└──────────────────────────┘    └─────────────────────────┘
```

---

## 📡 4. Especificación Completa de Endpoints HTTP

| Endpoint / Ruta | Método HTTP | Payload de Entrada (Request JSON) | Respuesta Exitosa (Status / Output JSON) | Descripción y Propósito |
|---|---|---|---|---|
| `/api/ingredientes/sugeridos` | `GET` | *Sin Body* | **200 OK**<br>```json\n{\n  "ingredientes": ["Tomate", "Cebolla", "Huevo", "Arroz", ...],\n  "total": 20\n}\n``` | Retorna una lista predeterminada de 20 ingredientes comunes para el autocompletado en Flutter. |
| `/api/receta/generar` | `POST` | ```json\n{\n  "ingredientes": ["Tomate", "Huevo", "Cebolla"]\n}\n``` | **201 Created**<br>```json\n{\n  "id": 1,\n  "titulo": "Salteado de Aprovechamiento con Tomate",\n  "tiempo": "20 min",\n  "dificultad": "Fácil",\n  "porciones": 2,\n  "ingredientes": ["1 taza de Tomate", "1 taza de Huevo", ...],\n  "pasos": ["Lavar bien...", "Calentar sartén..."],\n  "tip_antidesperdicio": "Conserva sobrantes en el refrigerador.",\n  "favorito": false,\n  "fecha_creacion": "2026-10-01T18:44:46"\n}\n``` | Procesa los ingredientes mediante prompt engineering con la API de IA (Gemini) y almacena la receta en memoria. |
| `/api/historial/favorito` | `PUT` | ```json\n{\n  "id": 1,\n  "favorito": true\n}\n``` | **200 OK**<br>```json\n{\n  "mensaje": "Estado de favorito actualizado con éxito",\n  "receta": { "id": 1, "favorito": true, ... }\n}\n``` | Actualiza el estado de favorito de una receta almacenada marcándola o desmarcándola. |
| `/api/historial/<id>` | `DELETE` | *Sin Body* | **200 OK**<br>```json\n{\n  "id": 1,\n  "mensaje": "Receta '...' eliminada correctamente del historial."\n}\n``` | Elimina una receta del historial en memoria del servidor según su ID. |

---

## 🐳 5. Despliegue con Docker & Docker Compose

El proyecto incluye contenedores optimizados para backend y frontend con un archivo `docker-compose.yml` unificado.

### Estructura Docker:
- **`backend/Dockerfile`**: Imagen ligera basada en Python 3.11-slim, expuesta en el puerto `5000`.
- **`frontend/Dockerfile`**: Build en 2 etapas (*Multi-Stage Build*). Etapa 1 compila Flutter Web y Etapa 2 lo sirve a través de un servidor ligero Nginx en el puerto `8080`.
- **`docker-compose.yml`**: Orquesta ambos servicios en la misma red puente (`ecoeat_network`).

### Comandos de Ejecución con Docker:
```bash
# 1. Levantar todo el sistema (Backend + Frontend)
docker compose up --build

# 2. Detener los contenedores
docker compose down
```

- **Frontend App Web**: `http://localhost:8080`
- **Backend API Flask**: `http://localhost:5000`

---

## 🚀 6. Guía de Ejecución Local (Sin Docker)

1. **Iniciar Backend:**
   ```powershell
   cd backend
   python app.py
   ```
2. **Ejecutar Pruebas Postman:**
   - Importar el archivo `EcoEat.postman_collection.json` en Postman y ejecutar las peticiones.
3. **Ejecutar App Móvil (Flutter):**
   ```powershell
   cd frontend
   flutter run -d chrome
   ```
