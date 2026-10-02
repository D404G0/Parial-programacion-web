# 🍽️ EcoEat – Chef Virtual Anti-Desperdicio
# EcoEat – Chef Virtual Anti-Desperdicio

Aplicación móvil desarrollada con **Flutter** que permite a los usuarios registrar los ingredientes disponibles en su hogar y generar recetas de aprovechamiento mediante **Inteligencia Artificial**.
El proyecto está compuesto por una aplicación móvil desarrollada en Flutter y un backend desarrollado en Python con Flask, encargado de procesar las solicitudes, comunicarse con la API de Inteligencia Artificial y administrar el historial de recetas.

---

## 📋 1. Información del Proyecto

| Información | Detalle |
|---|---|
| **Proyecto** | EcoEat – Chef Virtual Anti-Desperdicio |
| **Tipo** | Aplicación móvil |
| **Frontend** | Flutter / Dart |
| **Backend** | Python / Flask |
| **Inteligencia Artificial** | Google Gemini API |
| **Pruebas API** | Postman |
| **Almacenamiento** | En memoria |
| **Arquitectura** | Flutter → Flask → Gemini |
| **Comunicación** | HTTP / JSON |
| **Integrantes** | [Nombres de los integrantes] |

---

## 🎯 2. Objetivo

EcoEat tiene como objetivo reducir el desperdicio de alimentos mediante una aplicación móvil que permita a los usuarios registrar los ingredientes disponibles en su hogar y generar recetas de aprovechamiento utilizando Inteligencia Artificial.
La aplicación busca facilitar el uso de alimentos disponibles antes de que sean desperdiciados, proporcionando recetas adaptadas a los ingredientes seleccionados por el usuario.

---

## 💡 3. Problemática

Una cantidad considerable de alimentos puede terminar desperdiciándose debido a que las personas no saben qué preparar con los ingredientes que tienen disponibles.
EcoEat plantea una solución tecnológica mediante la cual el usuario puede indicar qué ingredientes tiene disponibles y recibir automáticamente una receta que aproveche dichos alimentos.
De esta manera, la aplicación busca facilitar la toma de decisiones al momento de cocinar y promover un mayor aprovechamiento de los alimentos.

---

## 🚀 4. Propuesta de Solución

EcoEat integra una aplicación móvil con un backend y un servicio de Inteligencia Artificial.
El usuario selecciona los ingredientes disponibles y la aplicación envía esta información al backend.
El backend procesa la solicitud y se comunica con Google Gemini para generar una receta.
Finalmente, la receta generada es enviada nuevamente a la aplicación móvil para ser presentada al usuario.

### Flujo general

```text
Usuario
   │
   ▼
Aplicación Flutter
   │
   │ HTTP / JSON
   ▼
Backend Flask
   │
   │ API
   ▼
Google Gemini
   │
   │ Receta generada
   ▼
Backend Flask
   │
   │ JSON
   ▼
Aplicación Flutter
   │
   ▼
Usuario
```

---

## 🏗️ 5. Arquitectura del Proyecto

El proyecto utiliza una arquitectura cliente-servidor compuesta principalmente por tres elementos:

### Frontend

Aplicación móvil desarrollada utilizando:
- Flutter
- Dart
- Material Design

### Backend

API REST desarrollada utilizando:
- Python
- Flask

### Inteligencia Artificial

Servicio utilizado para la generación de recetas:
- Google Gemini API

### Arquitectura

```text
┌───────────────────────────────┐
│                               │
│       📱 FLUTTER APP          │
│                               │
│  • Ingredientes               │
│  • Generación de recetas      │
│  • Favoritos                  │
│  • Historial                  │
│  • Eliminación                │
│                               │
└───────────────┬───────────────┘
                │
                │ HTTP / JSON
                ▼
┌───────────────────────────────┐
│                               │
│        🐍 FLASK API           │
│                               │
│  • Endpoints REST             │
│  • Validaciones               │
│  • Historial                  │
│  • Favoritos                  │
│  • Integración con Gemini     │
│                               │
└───────────────┬───────────────┘
                │
                │ API
                ▼
┌───────────────────────────────┐
│                               │
│       🤖 GOOGLE GEMINI        │
│                               │
│     Generación de recetas     │
│                               │
└───────────────────────────────┘
```

---

## 📱 6. Funcionalidades Principales

EcoEat permite realizar las siguientes acciones:

- Registrar ingredientes disponibles.
- Seleccionar ingredientes sugeridos.
- Generar recetas mediante Inteligencia Artificial.
- Visualizar recetas generadas.
- Consultar el historial de recetas.
- Marcar recetas como favoritas.
- Desmarcar recetas favoritas.
- Eliminar recetas.
- Recibir consejos para reducir el desperdicio de alimentos.
- Utilizar un mecanismo alternativo para generación de recetas cuando Gemini no esté disponible.

---

## 🥕 7. Ingredientes Sugeridos

La aplicación cuenta con una lista inicial de ingredientes sugeridos:

1. Tomate
2. Cebolla
3. Huevo
4. Arroz
5. Pollo
6. Queso
7. Papa
8. Zanahoria
9. Leche
10. Ajo
11. Pimiento
12. Espinaca
13. Pan
14. Atún
15. Palta
16. Limón
17. Manzana
18. Aceite
19. Mantequilla
20. Fideos

Estos ingredientes facilitan al usuario la selección de los alimentos disponibles.

---

## 🔌 8. API REST

El backend expone los siguientes endpoints:

| Método | Endpoint | Descripción |
|---|---|---|
| `GET` | `/api/ingredientes/sugeridos` | Obtiene ingredientes sugeridos |
| `POST` | `/api/receta/generar` | Genera una receta |
| `PUT` | `/api/historial/favorito` | Marca o desmarca una receta como favorita |
| `DELETE` | `/api/historial/<id>` | Elimina una receta |
| `GET` | `/api/historial` | Obtiene el historial de recetas |

---

## 🥕 9. Endpoint de Ingredientes Sugeridos

### GET `/api/ingredientes/sugeridos`

Permite obtener la lista de ingredientes sugeridos disponibles en el sistema.

### Ejemplo de respuesta

```json
{
  "ingredientes": [
    "Tomate",
    "Cebolla",
    "Huevo",
    "Arroz",
    "Pollo",
    "Queso",
    "Papa",
    "Zanahoria",
    "Leche",
    "Ajo",
    "Pimiento",
    "Espinaca",
    "Pan",
    "Atún",
    "Palta",
    "Limón",
    "Manzana",
    "Aceite",
    "Mantequilla",
    "Fideos"
  ]
}
```

---

## 👨‍🍳 10. Endpoint de Generación de Recetas

### POST `/api/receta/generar`

Permite generar una receta utilizando los ingredientes enviados por el usuario.

### Request

```json
{
  "ingredientes": [
    "Tomate",
    "Huevo",
    "Cebolla"
  ]
}
```

### Ejemplo de respuesta

```json
{
  "id": 1,
  "titulo": "Tortilla de tomate y cebolla",
  "tiempo": "20 minutos",
  "dificultad": "Fácil",
  "porciones": 2,
  "ingredientes": [
    "2 huevos",
    "1 tomate",
    "1/2 cebolla",
    "Sal al gusto",
    "Aceite"
  ],
  "pasos": [
    "Cortar el tomate y la cebolla.",
    "Batir los huevos.",
    "Agregar los vegetales.",
    "Cocinar la mezcla en una sartén.",
    "Servir caliente."
  ],
  "tipAntidesperdicio": "Utiliza los vegetales maduros antes de que pierdan su calidad.",
  "favorito": false,
  "fechaCreacion": "2026-01-01T12:00:00"
}
```

---

## ❤️ 11. Endpoint de Favoritos

### PUT `/api/historial/favorito`

Permite marcar o desmarcar una receta como favorita.

### Request

```json
{
  "id": 1,
  "favorito": true
}
```

El campo `favorito` puede tomar los siguientes valores:

```text
true
false
```

### Ejemplo

Para marcar una receta:

```json
{
  "id": 1,
  "favorito": true
}
```

Para quitarla de favoritos:

```json
{
  "id": 1,
  "favorito": false
}
```

---

## 🗑️ 12. Endpoint para Eliminar Recetas

### DELETE `/api/historial/<id>`

Permite eliminar una receta específica utilizando su identificador.

### Ejemplo

```http
DELETE /api/historial/1
```

### Respuesta

```json
{
  "mensaje": "Receta eliminada correctamente"
}
```

---

## 📚 13. Endpoint del Historial

### GET `/api/historial`

Permite consultar las recetas generadas durante la ejecución del backend.

### Ejemplo de respuesta

```json
{
  "historial": [
    {
      "id": 1,
      "titulo": "Tortilla de tomate y cebolla",
      "tiempo": "20 minutos",
      "dificultad": "Fácil",
      "porciones": 2,
      "favorito": false
    }
  ]
}
```

---

## 🤖 14. Integración con Google Gemini

EcoEat utiliza Google Gemini para generar recetas a partir de los ingredientes proporcionados por el usuario.

El backend recibe los ingredientes, construye una solicitud para el modelo de Inteligencia Artificial y procesa la respuesta recibida.

La receta generada contiene información estructurada como:

- Título.
- Tiempo de preparación.
- Dificultad.
- Número de porciones.
- Ingredientes.
- Pasos.
- Consejo antidesperdicio.
- Estado de favorito.
- Fecha de creación.

### Modelo utilizado

```text
gemini-1.5-flash
```

---

## 🔐 15. Configuración de la API Key

La API Key de Gemini debe almacenarse mediante una variable de entorno.

### Variable

```env
GEMINI_API_KEY=TU_API_KEY
```

### Linux

```bash
export GEMINI_API_KEY="TU_API_KEY"
```

### Windows PowerShell

```powershell
$env:GEMINI_API_KEY="TU_API_KEY"
```

> **Importante:** nunca se recomienda subir una API Key directamente al repositorio.

---

## 🔄 16. Mecanismo Alternativo de Generación

El backend cuenta con una lógica alternativa para generar recetas cuando no es posible utilizar correctamente la API de Gemini.

Esto permite mantener disponible la funcionalidad principal ante situaciones como:

- Falta de API Key.
- Error de comunicación con Gemini.
- Problemas temporales de conexión.
- Respuesta inválida.
- Indisponibilidad temporal del servicio.

El mecanismo alternativo permite que el sistema continúe funcionando sin depender exclusivamente del servicio externo.

---

## 💾 17. Almacenamiento

Actualmente las recetas se almacenan **en memoria**.

El backend utiliza estructuras similares a:

```python
historial_db = {}
id_counter = 1
```

Esto significa que:

- Las recetas permanecen disponibles mientras el servidor está ejecutándose.
- Los identificadores se generan durante la ejecución.
- El historial se mantiene en memoria.
- La información se pierde cuando el backend se reinicia.
- Actualmente no existe una base de datos persistente.

### Mejora futura

Una versión futura podría implementar una base de datos utilizando:

- PostgreSQL.
- MySQL.
- SQL Server.
- SQLite.

---

## 📱 18. Aplicación Flutter

La aplicación móvil está desarrollada utilizando Flutter y Dart.

Flutter se encarga de:

- Mostrar la interfaz.
- Capturar los ingredientes.
- Realizar las solicitudes al backend.
- Procesar las respuestas JSON.
- Mostrar las recetas.
- Administrar favoritos.
- Consultar el historial.
- Eliminar recetas.

---

## 🧱 19. Modelo `Recipe`

El modelo principal de la aplicación representa una receta.

```dart
class Recipe {
  final int id;
  final String titulo;
  final String tiempo;
  final String dificultad;
  final int porciones;
  final List<String> ingredientes;
  final List<String> pasos;
  final String tipAntidesperdicio;
  bool favorito;
  final String fechaCreacion;

  Recipe({
    required this.id,
    required this.titulo,
    required this.tiempo,
    required this.dificultad,
    required this.porciones,
    required this.ingredientes,
    required this.pasos,
    required this.tipAntidesperdicio,
    required this.favorito,
    required this.fechaCreacion,
  });
}
```

### Campos

| Campo | Tipo | Descripción |
|---|---|---|
| `id` | `int` | Identificador de la receta |
| `titulo` | `String` | Nombre de la receta |
| `tiempo` | `String` | Tiempo de preparación |
| `dificultad` | `String` | Nivel de dificultad |
| `porciones` | `int` | Cantidad de porciones |
| `ingredientes` | `List<String>` | Ingredientes utilizados |
| `pasos` | `List<String>` | Pasos de preparación |
| `tipAntidesperdicio` | `String` | Consejo para evitar desperdicio |
| `favorito` | `bool` | Estado de favorito |
| `fechaCreacion` | `String` | Fecha de generación |

---

## 🌐 20. Servicio de API

La comunicación entre Flutter y el backend se encuentra centralizada principalmente en:

```text
lib/services/api_service.dart
```

Este servicio se encarga de realizar las solicitudes HTTP.

Entre sus responsabilidades se encuentran:

- Obtener ingredientes sugeridos.
- Generar recetas.
- Consultar el historial.
- Marcar favoritos.
- Eliminar recetas.

### Ejemplo de solicitud

```dart
final response = await http.post(
  Uri.parse('$baseUrl/api/receta/generar'),
  headers: {
    'Content-Type': 'application/json',
  },
  body: jsonEncode({
    'ingredientes': ingredientes,
  }),
);
```

---

## 🖥️ 21. Pantallas de la Aplicación

La aplicación puede organizarse en diferentes pantallas según las funcionalidades implementadas.

### 🏠 Inicio

Permite acceder a las principales funcionalidades de EcoEat.

### 🥕 Ingredientes

Permite seleccionar los ingredientes disponibles.

### 👨‍🍳 Generación de Receta

Muestra la receta generada por el sistema.

### ❤️ Favoritos

Permite consultar las recetas marcadas como favoritas.

### 📚 Historial

Permite consultar las recetas generadas previamente durante la ejecución del backend.

---

## 🔄 22. Manejo del Estado

Flutter mantiene la información necesaria para actualizar la interfaz cuando ocurren acciones como:

- Agregar ingredientes.
- Eliminar ingredientes.
- Generar una receta.
- Marcar una receta como favorita.
- Quitar una receta de favoritos.
- Eliminar una receta.
- Actualizar el historial.

Las operaciones que requieren información del servidor se realizan mediante solicitudes HTTP al backend.

---

## 🧪 23. Pruebas con Postman

El proyecto incluye una colección de Postman:

```text
EcoEat.postman_collection.json
```

La colección permite probar los endpoints del backend independientemente de la aplicación móvil.

### Pruebas principales

- Consulta de ingredientes sugeridos.
- Generación de recetas.
- Consulta del historial.
- Cambio de favoritos.
- Eliminación de recetas.
- Validación de respuestas JSON.
- Validación de códigos HTTP.

---

## 📊 24. Códigos HTTP

Los principales códigos HTTP utilizados son:

| Código | Significado |
|---|---|
| `200` | Solicitud procesada correctamente |
| `201` | Recurso creado correctamente |
| `400` | Solicitud incorrecta |
| `404` | Recurso no encontrado |
| `500` | Error interno del servidor |

---

## 📁 25. Estructura del Proyecto

Una estructura aproximada del proyecto es:

```text
EcoEat/
│
├── backend/
│   ├── app.py
│   ├── requirements.txt
│   └── ...
│
├── lib/
│   ├── models/
│   │   └── recipe.dart
│   │
│   ├── services/
│   │   └── api_service.dart
│   │
│   ├── screens/
│   │   ├── home_screen.dart
│   │   ├── ingredientes_screen.dart
│   │   ├── receta_screen.dart
│   │   ├── favoritos_screen.dart
│   │   └── historial_screen.dart
│   │
│   └── main.dart
│
├── test/
│
├── EcoEat.postman_collection.json
├── pubspec.yaml
└── README.md
```

> La estructura puede variar dependiendo de la organización final del código.

---

## ⚙️ 26. Requisitos

### Backend

Se requiere:

- Python 3.x.
- Flask.
- Dependencias definidas en `requirements.txt`.
- API Key de Google Gemini.

### Frontend

Se requiere:

- Flutter SDK.
- Dart SDK.
- Android SDK.
- ADB.
- Dispositivo Android o emulador.

### Pruebas

Se requiere:

- Postman.

---

## 🐍 27. Instalación del Backend

Ingresar a la carpeta del backend:

```bash
cd backend
```

Crear un entorno virtual:

```bash
python -m venv venv
```

### Linux

```bash
source venv/bin/activate
```

### Windows

```powershell
venv\Scripts\activate
```

Instalar las dependencias:

```bash
pip install -r requirements.txt
```

---

## ▶️ 28. Ejecución del Backend

El backend utiliza Flask y está configurado para aceptar conexiones externas al proceso local mediante:

```python
app.run(
    host="0.0.0.0",
    port=5000,
    debug=True
)
```

Para iniciar el servidor:

```bash
python app.py
```

El backend estará disponible en:

```text
http://127.0.0.1:5000
```

---

## 🧪 29. Ejecución de Pruebas con Postman

Abrir Postman e importar:

```text
EcoEat.postman_collection.json
```

Posteriormente se pueden ejecutar las solicitudes disponibles en la colección.

### Ejemplo

```http
POST http://127.0.0.1:5000/api/receta/generar
```

### Body

```json
{
  "ingredientes": [
    "Tomate",
    "Huevo",
    "Arroz"
  ]
}
```

---

## 📱 30. Ejecución de Flutter

Ingresar a la carpeta del proyecto:

```bash
cd EcoEat
```

Instalar dependencias:

```bash
flutter pub get
```

Verificar los dispositivos disponibles:

```bash
flutter devices
```

Ejecutar la aplicación:

```bash
flutter run
```

---

## 🌐 31. Configuración de Conectividad

La URL utilizada por Flutter para comunicarse con Flask depende de dónde se ejecute la aplicación.

### Navegador / PC

```text
http://127.0.0.1:5000
```

### Emulador Android

En un emulador Android estándar:

```text
http://10.0.2.2:5000
```

`10.0.2.2` representa la máquina host desde el punto de vista del emulador Android.

### Dispositivo Android físico

Cuando se utiliza un dispositivo físico, se debe utilizar la dirección IP local del computador.

Ejemplo:

```text
http://192.168.1.100:5000
```

El computador y el teléfono deben estar conectados a la misma red.

---

## 🔄 32. Flujo Completo del Sistema

El flujo principal de EcoEat es:

```text
1. Usuario abre la aplicación
              ↓
2. Usuario selecciona ingredientes
              ↓
3. Flutter prepara la solicitud
              ↓
4. Flutter envía HTTP POST
              ↓
5. Flask recibe los ingredientes
              ↓
6. Flask valida la solicitud
              ↓
7. Flask construye el prompt
              ↓
8. Flask envía la solicitud a Gemini
              ↓
9. Gemini genera la receta
              ↓
10. Flask procesa la respuesta
              ↓
11. Flask almacena la receta en memoria
              ↓
12. Flask devuelve JSON
              ↓
13. Flutter recibe la respuesta
              ↓
14. Flutter convierte el JSON en Recipe
              ↓
15. Usuario visualiza la receta
              ↓
16. Usuario puede marcarla como favorita
              ↓
17. Usuario puede consultar el historial
              ↓
18. Usuario puede eliminar la receta
```

---

## 📅 33. Cronograma de Desarrollo

| Etapa | Actividad |
|---|---|
| 1 | Análisis de requerimientos |
| 2 | Diseño de la aplicación |
| 3 | Configuración del proyecto Flutter |
| 4 | Desarrollo del backend Flask |
| 5 | Implementación de endpoints |
| 6 | Integración con Gemini |
| 7 | Desarrollo de las pantallas |
| 8 | Integración Flutter + Flask |
| 9 | Pruebas mediante Postman |
| 10 | Pruebas de la aplicación |
| 11 | Corrección de errores |
| 12 | Documentación |
| 13 | Presentación final |

---

# ✅ Checklist del Proyecto

## Backend

- [x] Crear API Flask.
- [x] Crear endpoint de ingredientes sugeridos.
- [x] Crear endpoint para generar recetas.
- [x] Integrar Google Gemini.
- [x] Crear historial de recetas.
- [x] Crear sistema de favoritos.
- [x] Crear eliminación de recetas.
- [x] Crear endpoint de consulta de historial.
- [x] Implementar mecanismo alternativo de generación.

## Flutter

- [x] Crear aplicación Flutter.
- [x] Crear modelo `Recipe`.
- [x] Crear servicio de API.
- [x] Implementar selección de ingredientes.
- [x] Implementar generación de recetas.
- [x] Implementar favoritos.
- [x] Implementar historial.
- [x] Implementar eliminación.

## QA

- [x] Crear colección de Postman.
- [x] Probar endpoints.
- [x] Validar respuestas JSON.
- [x] Validar códigos HTTP.
- [x] Probar integración frontend/backend.

## Documentación

- [x] README.
- [x] Arquitectura.
- [x] Endpoints.
- [x] Instalación.
- [x] Configuración.
- [x] Ejecución.
- [x] Pruebas.

---

# 🛠️ Tecnologías Utilizadas

| Tecnología | Uso |
|---|---|
| **Flutter** | Desarrollo de aplicación móvil |
| **Dart** | Lenguaje del frontend |
| **Python** | Lenguaje del backend |
| **Flask** | Framework para API REST |
| **Google Gemini** | Inteligencia Artificial |
| **HTTP** | Comunicación entre aplicaciones |
| **JSON** | Intercambio de información |
| **Postman** | Pruebas de API |
| **Git** | Control de versiones |
| **GitHub** | Repositorio del proyecto |

---

# 👥 Integrantes

| Integrante | Rol |
|---|---|
| [Nombre] | Desarrollo Flutter |
| [Nombre] | Desarrollo Backend |
| [Nombre] | Integración IA |
| [Nombre] | QA / Pruebas |
| [Nombre] | Documentación |

> Reemplazar los nombres y roles según la distribución real del equipo.

---

# 📦 Entregables

El proyecto contempla los siguientes entregables:

- Aplicación móvil desarrollada en Flutter.
- Backend desarrollado en Python/Flask.
- Integración con Google Gemini.
- API REST.
- Colección de pruebas de Postman.
- Documentación técnica.
- README del proyecto.
- Código fuente.
- Evidencias de funcionamiento.

---

# 🔐 Seguridad y Buenas Prácticas

## API Key

No almacenar directamente la API Key de Gemini dentro del código fuente.

Utilizar variables de entorno:

```env
GEMINI_API_KEY=TU_API_KEY
```

## Validación

El backend debe validar:

- Solicitudes recibidas.
- Ingredientes.
- Identificadores.
- Datos enviados desde Flutter.

## Comunicación

La comunicación entre Flutter y Flask utiliza JSON mediante HTTP.

Para un entorno de producción se recomienda utilizar HTTPS.

## Control de versiones

Se recomienda evitar subir archivos sensibles al repositorio.

Ejemplo de `.gitignore`:

```gitignore
.env
venv/
__pycache__/
*.pyc
.dart_tool/
build/
```

---

# 🔮 Consideraciones y Mejoras Futuras

Actualmente el sistema utiliza almacenamiento en memoria.

Por esta razón, el historial se pierde cuando el backend se reinicia.

Algunas mejoras que podrían implementarse posteriormente son:

- Base de datos persistente.
- Autenticación de usuarios.
- Cuentas personales.
- Sincronización de recetas.
- Categorías de recetas.
- Filtros nutricionales.
- Información nutricional.
- Generación de imágenes de recetas.
- Recomendaciones personalizadas.
- Notificaciones.
- Sistema avanzado de reducción de desperdicio.
- Historial persistente por usuario.
- Gestión de inventario de ingredientes.
- Fechas de vencimiento de alimentos.

---

# 🗄️ Evolución hacia una Base de Datos

Una futura versión podría reemplazar el almacenamiento en memoria por una base de datos.

Una posible arquitectura sería:

```text
Flutter
   │
   ▼
Flask API
   │
   ├──────────────► Google Gemini
   │
   ▼
Base de Datos
   │
   ├── Usuarios
   ├── Recetas
   ├── Ingredientes
   └── Favoritos
```

Esto permitiría conservar la información incluso después de reiniciar el servidor.

---

# 📄 Licencia

Este proyecto fue desarrollado con fines **académicos**.

Su utilización, distribución y modificación están sujetas a las condiciones definidas por los integrantes del proyecto y la institución académica correspondiente.

---

# 🍽️ EcoEat

> **"Convierte tus ingredientes disponibles en nuevas posibilidades."**

EcoEat combina **tecnología, Inteligencia Artificial y aprovechamiento de alimentos** para ayudar a los usuarios a descubrir nuevas recetas utilizando los ingredientes que ya tienen disponibles en casa.

