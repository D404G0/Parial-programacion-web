import os
import json
import time
from datetime import datetime
from flask import Flask, request, jsonify
from flask_cors import CORS
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

app = Flask(__name__)
CORS(app)  # Enable CORS for Flutter app integration

# In-memory database for recipes
historial_db = {}
id_counter = 1

# Predefined list of suggested ingredients
SUGGESTED_INGREDIENTS = [
    "Tomate", "Cebolla", "Huevo", "Arroz", "Pollo", "Queso", "Papa",
    "Zanahoria", "Leche", "Ajo", "Pimiento", "Espinaca", "Pan",
    "Atún", "Palta", "Limón", "Manzana", "Aceite", "Mantequilla", "Fideos"
]

# Initialize Gemini AI if key is available
GEMINI_API_KEY = os.getenv("GEMINI_API_KEY", "")
genai_client = None

if GEMINI_API_KEY:
    try:
        import google.generativeai as genai
        genai.configure(api_key=GEMINI_API_KEY)
        genai_client = genai.GenerativeModel("gemini-1.5-flash")
        print("Gemini AI successfully initialized!")
    except Exception as e:
        print(f"Warning: Failed to initialize Gemini client: {e}")


def fallback_recipe_generator(ingredientes):
    """
    Algorithmic anti-waste recipe generator used when Gemini API is unavailable or unconfigured.
    Guarantees robust, realistic recipe responses.
    """
    ings_clean = [i.strip().capitalize() for i in ingredientes if i.strip()]
    main_ing = ings_clean[0] if ings_clean else "Ingredientes varios"
    ings_str = ", ".join(ings_clean)
    
    return {
        "titulo": f"Salteado de Aprovechamiento con {main_ing}",
        "tiempo": "20 min",
        "dificultad": "Fácil",
        "porciones": 2,
        "ingredientes": [f"1 taza de {ing}" for ing in ings_clean] + ["1 cda de aceite de oliva", "Sal, pimienta y especias al gusto"],
        "pasos": [
            f"Lavar bien y picar en trozos uniformes: {ings_str}.",
            "Calentar una sartén a fuego medio con la cucharada de aceite de oliva.",
            f"Añadir los ingredientes ({ings_str}) en orden de dureza, comenzando por los más firmes.",
            "Sazonar con sal, pimienta y tus especias favoritas.",
            "Cocinar durante 10-12 minutos revolviendo ocasionalmente hasta que estén tiernos y dorados.",
            "Servir caliente y disfrutar de una comida nutritiva sin desperdiciar nada."
        ],
        "tip_antidesperdicio": f"Si te sobran porciones de {main_ing}, guárdalas en un recipiente hermético en el refrigerador. Puedes usarlas mañana como relleno para una tortilla o empanadas."
    }


def call_gemini_ai(ingredientes):
    """
    Calls Gemini API with prompt engineering to return structured JSON.
    """
    ings_str = ", ".join(ingredientes)
    prompt = f"""
Eres EcoEat, un Chef Virtual experto en cocina sustentable y aprovechamiento de alimentos.
El usuario tiene disponibles los siguientes ingredientes en su hogar: {ings_str}.

Genera una receta de aprovechamiento deliciosa, creativa y práctica para evitar desperdiciar estos alimentos.
DEBES responder únicamente con un objeto JSON sin formato markdown, sin comillas triples ```json, sin texto explicativo.

El formato del JSON debe ser exactamente:
{{
  "titulo": "Título atractivo de la receta",
  "tiempo": "tiempo estimado (ej: 20 min)",
  "dificultad": "Fácil | Media | Avanzada",
  "porciones": 2,
  "ingredientes": ["ingrediente 1 con cantidad", "ingrediente 2 con cantidad"],
  "pasos": ["Paso 1...", "Paso 2...", "Paso 3..."],
  "tip_antidesperdicio": "Un consejo práctico para conservar o aprovechar los restos de comida."
}}
"""
    try:
        response = genai_client.generate_content(prompt)
        text_content = response.text.strip()
        
        # Clean potential markdown formatting
        if text_content.startswith("```"):
            lines = text_content.splitlines()
            if lines[0].startswith("```"):
                lines = lines[1:]
            if lines and lines[-1].startswith("```"):
                lines = lines[:-1]
            text_content = "\n".join(lines).strip()
            
        recipe_data = json.loads(text_content)
        return recipe_data
    except Exception as e:
        print(f"Error calling Gemini API: {e}. Falling back to algorithm generator.")
        return fallback_recipe_generator(ingredientes)


# ==========================================
# REQ-1: ENDPOINTS HTTP REQUERIDOS
# ==========================================

@app.route("/api/receta/generar", methods=["POST"])
def generar_receta():
    """
    POST /api/receta/generar
    Recibe un JSON con la lista de ingredientes, consulta la API de IA (Gemini/ChatGPT)
    con prompt engineering y devuelve la receta en formato JSON.
    """
    global id_counter
    data = request.get_json() or {}
    ingredientes = data.get("ingredientes", [])

    if not ingredientes or not isinstance(ingredientes, list) or len(ingredientes) == 0:
        return jsonify({
            "error": "Petición inválida",
            "mensaje": "Debes enviar una lista con al menos un ingrediente."
        }), 400

    # Process AI recipe generation
    if genai_client:
        receta_data = call_gemini_ai(ingredientes)
    else:
        receta_data = fallback_recipe_generator(ingredientes)

    # Add metadata & ID
    receta_id = id_counter
    id_counter += 1

    nueva_receta = {
        "id": receta_id,
        "titulo": receta_data.get("titulo", "Receta EcoEat"),
        "tiempo": receta_data.get("tiempo", "15-20 min"),
        "dificultad": receta_data.get("dificultad", "Fácil"),
        "porciones": receta_data.get("porciones", 2),
        "ingredientes": receta_data.get("ingredientes", ingredientes),
        "pasos": receta_data.get("pasos", []),
        "tip_antidesperdicio": receta_data.get("tip_antidesperdicio", "Conserva los tallos de verduras para hacer caldos."),
        "favorito": False,
        "fecha_creacion": datetime.now().isoformat()
    }

    # Store in memory DB
    historial_db[receta_id] = nueva_receta

    return jsonify(nueva_receta), 201


@app.route("/api/ingredientes/sugeridos", methods=["GET"])
def obtener_ingredientes_sugeridos():
    """
    GET /api/ingredientes/sugeridos
    Retorna una lista predeterminada de ingredientes comunes para autocompletar en la app móvil.
    """
    return jsonify({
        "ingredientes": SUGGESTED_INGREDIENTS,
        "total": len(SUGGESTED_INGREDIENTS)
    }), 200


@app.route("/api/historial/favorito", methods=["PUT"])
@app.route("/api/historial/favorito/<int:receta_id>", methods=["PUT"])
def actualizar_favorito(receta_id=None):
    """
    PUT /api/historial/favorito
    Permite actualizar el estado de una receta guardada marcándola o desmarcándola como favorita.
    Acepta ID vía JSON body `{"id": 1, "favorito": true}` o vía URL.
    """
    data = request.get_json() or {}
    
    target_id = receta_id if receta_id is not None else data.get("id")
    if target_id is None:
        return jsonify({"error": "Debes especificar el 'id' de la receta."}), 400

    try:
        target_id = int(target_id)
    except ValueError:
        return jsonify({"error": "El 'id' debe ser un número entero."}), 400

    if target_id not in historial_db:
        return jsonify({"error": f"Receta con ID {target_id} no encontrada en el historial."}), 404

    # Determine favorite status
    if "favorito" in data:
        nuevo_favorito = bool(data["favorito"])
    else:
        # Toggle if omitted
        nuevo_favorito = not historial_db[target_id].get("favorito", False)

    historial_db[target_id]["favorito"] = nuevo_favorito

    return jsonify({
        "mensaje": "Estado de favorito actualizado con éxito",
        "receta": historial_db[target_id]
    }), 200


@app.route("/api/historial/<int:receta_id>", methods=["DELETE"])
def eliminar_receta_historial(receta_id):
    """
    DELETE /api/historial/<id>
    Elimina una receta del historial en memoria del servidor.
    """
    if receta_id not in historial_db:
        return jsonify({"error": f"Receta con ID {receta_id} no encontrada en el historial."}), 404

    receta_eliminada = historial_db.pop(receta_id)

    return jsonify({
        "mensaje": f"Receta '{receta_eliminada.get('titulo')}' eliminada correctamente del historial.",
        "id": receta_id
    }), 200


@app.route("/api/historial", methods=["GET"])
def obtener_historial():
    """
    GET /api/historial
    Endpoint auxiliar para listar todas las recetas guardadas en memoria.
    """
    recetas_list = list(historial_db.values())
    return jsonify({
        "total": len(recetas_list),
        "recetas": recetas_list
    }), 200


if __name__ == "__main__":
    print("Iniciando EcoEat Backend Server en http://127.0.0.1:5000...")
    app.run(host="0.0.0.0", port=5000, debug=True)
