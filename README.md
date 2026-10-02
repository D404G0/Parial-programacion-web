<<<<<<< HEAD
# EcoEat – Chef Virtual Anti-Desperdicio

Sistema completo para la reducción del desperdicio de alimentos integrando Inteligencia Artificial (Google Gemini), un backend RESTful en Python (Flask) y una aplicación móvil desarrollada en Flutter.

---

## 🏗️ 1. Arquitectura del Sistema

```
[ App Móvil (Flutter) ] 
       │
       ├─► GET  /api/ingredientes/sugeridos ──► [ Backend Flask ]
       ├─► POST /api/receta/generar ─────────► [ Backend Flask ] ──► [ Google Gemini API ]
       ├─► PUT  /api/historial/favorito ──────► [ Backend Flask ]
       └─► DELETE /api/historial/<id> ───────► [ Backend Flask ]
```

---

## 📡 2. Especificación de Endpoints HTTP

| Ruta | Método | Payload (Request) | Respuesta (Status / Output) | Descripción |
|---|---|---|---|---|
| `/api/ingredientes/sugeridos` | **GET** | *Ninguno* | `200 OK` `{ "ingredientes": [...] }` | Retorna la lista fija de ingredientes sugeridos para autocompletar. |
| `/api/receta/generar` | **POST** | `{ "ingredientes": ["Tomate", "Huevo"] }` | `201 Created` Receta en JSON | Genera una receta de aprovechamiento procesada por IA (Gemini). |
| `/api/historial/favorito` | **PUT** | `{ "id": 1, "favorito": true }` | `200 OK` `{ "mensaje": "...", "receta": {...} }` | Actualiza el estado de favorito de una receta en memoria. |
| `/api/historial/<id>` | **DELETE** | *Ninguno* | `200 OK` `{ "mensaje": "...", "id": 1 }` | Elimina una receta almacenada en el historial por su ID. |

---

## 🚀 3. Guía de Ejecución Rápida Paso a Paso

### Backend (Python Flask)
1. Navega a la carpeta backend:
   ```bash
   cd backend
   ```
2. Instala las dependencias:
   ```bash
   pip install -r requirements.txt
   ```
3. (Opcional) Configura tu `GEMINI_API_KEY` en el archivo `.env`:
   ```env
   GEMINI_API_KEY=tu_api_key_aqui
   ```
4. Ejecuta el servidor Flask:
   ```bash
   python app.py
   ```
   *El servidor iniciará en `http://127.0.0.1:5000` (o `0.0.0.0:5000`).*

### Colección de Pruebas (Postman)
1. Abre **Postman**.
2. Importa el archivo `EcoEat.postman_collection.json` ubicado en la raíz del proyecto.
3. Ejecuta los 4 requests para validar las respuestas `200 OK` / `201 Created`.

### App Móvil (Flutter)
1. Navega a la carpeta frontend:
   ```bash
   cd frontend
   ```
2. Obtén las dependencias:
   ```bash
   flutter pub get
   ```
3. Ejecuta la aplicación:
   ```bash
   flutter run
   ```
=======
# Parial-programacion-web
>>>>>>> b4547ac64a6fad37eb81b79605063496675bd094
