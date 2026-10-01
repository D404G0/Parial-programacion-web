import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/recipe.dart';
import 'recipe_result_screen.dart';
import 'history_screen.dart';

class IngredientScreen extends StatefulWidget {
  const IngredientScreen({super.key});

  @override
  State<IngredientScreen> createState() => _IngredientScreenState();
}

class _IngredientScreenState extends State<IngredientScreen> {
  final TextEditingController _ingredientController = TextEditingController();
  final List<String> _selectedIngredients = [];
  List<String> _suggestedIngredients = [];
  bool _isLoadingSuggestions = true;
  bool _isGeneratingRecipe = false;

  @override
  void initState() {
    super.initState();
    _fetchSuggestions();
  }

  Future<void> _fetchSuggestions() async {
    setState(() => _isLoadingSuggestions = true);
    try {
      final suggestions = await ApiService.getSuggestedIngredients();
      setState(() {
        _suggestedIngredients = suggestions;
        _isLoadingSuggestions = false;
      });
    } catch (e) {
      setState(() => _isLoadingSuggestions = false);
    }
  }

  void _addIngredient(String name) {
    final clean = name.trim();
    if (clean.isEmpty) return;
    if (_selectedIngredients.any((i) => i.toLowerCase() == clean.toLowerCase())) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('"$clean" ya está en tu lista.'),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }
    setState(() {
      _selectedIngredients.add(clean);
      _ingredientController.clear();
    });
  }

  void _removeIngredient(String name) {
    setState(() {
      _selectedIngredients.remove(name);
    });
  }

  Future<void> _generateRecipe() async {
    if (_selectedIngredients.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.orange.shade800,
          content: const Text('⚠️ Agrega al menos un ingrediente para generar una receta.'),
          duration: const Duration(seconds: 3),
        ),
      );
      return;
    }

    setState(() => _isGeneratingRecipe = true);

    try {
      final Recipe recipe = await ApiService.generateRecipe(_selectedIngredients);
      if (!mounted) return;
      setState(() => _isGeneratingRecipe = false);

      // Navigate to RecipeResultScreen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RecipeResultScreen(recipe: recipe),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isGeneratingRecipe = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent,
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(
                child: Text('Error al conectar con el servidor: $e'),
              ),
            ],
          ),
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  void _showConfigDialog() {
    final TextEditingController urlController =
        TextEditingController(text: ApiService.baseUrl);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.settings, color: Color(0xFF10B981)),
            SizedBox(width: 8),
            Text('Configurar Backend'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Dirección URL base del Backend Flask:'),
            const SizedBox(height: 10),
            TextField(
              controller: urlController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                hintText: 'ej: http://127.0.0.1:5000',
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Usar 127.0.0.1 (Desktop/Web) o 10.0.2.2 (Android Emulator)',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              setState(() {
                ApiService.baseUrl = urlController.text.trim();
              });
              Navigator.pop(context);
              _fetchSuggestions();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Backend configurado a: ${ApiService.baseUrl}'),
                ),
              );
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.eco, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'EcoEat',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF0F766E),
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: Colors.white),
            tooltip: 'Historial de Recetas',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HistoryScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            tooltip: 'Configurar URL',
            onPressed: _showConfigDialog,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0F766E), Color(0xFF10B981)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromRGBO(16, 185, 129, 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '🍳 Chef Virtual Anti-Desperdicio',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Ingresa los alimentos que tienes en casa y generaremos una receta rápida y deliciosa.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Add Ingredient Input Card
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Agregar ingrediente',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _ingredientController,
                              decoration: InputDecoration(
                                hintText: 'Ej: Tomate, Palta, Huevo...',
                                prefixIcon: const Icon(Icons.search,
                                    color: Color(0xFF10B981)),
                                filled: true,
                                fillColor: const Color(0xFFF9FAFB),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 16),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              onSubmitted: (val) => _addIngredient(val),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF10B981),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.all(16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () =>
                                _addIngredient(_ingredientController.text),
                            child: const Icon(Icons.add),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Suggestions chips
              const Text(
                'Sugerencias rápidas (GET /api/ingredientes/sugeridos):',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF4B5563),
                ),
              ),
              const SizedBox(height: 10),

              _isLoadingSuggestions
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: CircularProgressIndicator(
                            color: Color(0xFF10B981)),
                      ),
                    )
                  : Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _suggestedIngredients.map((ing) {
                        final isSelected = _selectedIngredients.contains(ing);
                        return ActionChip(
                          avatar: Icon(
                            isSelected ? Icons.check : Icons.add_circle_outline,
                            size: 18,
                            color: isSelected ? Colors.white : const Color(0xFF0F766E),
                          ),
                          label: Text(ing),
                          backgroundColor:
                              isSelected ? const Color(0xFF0F766E) : Colors.white,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : const Color(0xFF1F2937),
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                          elevation: 1,
                          onPressed: () {
                            if (isSelected) {
                              _removeIngredient(ing);
                            } else {
                              _addIngredient(ing);
                            }
                          },
                        );
                      }).toList(),
                    ),

              const SizedBox(height: 24),

              // Selected Ingredients Chips
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Ingredientes agregados (${_selectedIngredients.length}):',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  if (_selectedIngredients.isNotEmpty)
                    TextButton(
                      onPressed: () => setState(() => _selectedIngredients.clear()),
                      child: const Text(
                        'Limpiar todo',
                        style: TextStyle(color: Colors.redAccent),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),

              _selectedIngredients.isEmpty
                  ? Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: const Column(
                        children: [
                          Icon(Icons.kitchen_outlined,
                              size: 40, color: Colors.grey),
                          SizedBox(height: 8),
                          Text(
                            'Aún no has agregado ingredientes.',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _selectedIngredients.map((ing) {
                        return Chip(
                          label: Text(ing),
                          backgroundColor: const Color(0xFFE0F2FE),
                          deleteIcon:
                              const Icon(Icons.cancel, size: 18, color: Colors.redAccent),
                          onDeleted: () => _removeIngredient(ing),
                          labelStyle: const TextStyle(
                            color: Color(0xFF0369A1),
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      }).toList(),
                    ),

              const SizedBox(height: 32),

              // Generate Recipe Button
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F766E),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 4,
                  ),
                  onPressed: _isGeneratingRecipe ? null : _generateRecipe,
                  child: _isGeneratingRecipe
                      ? const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            ),
                            SizedBox(width: 12),
                            Text(
                              'Consultando IA de EcoEat...',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.auto_awesome, size: 22),
                            SizedBox(width: 10),
                            Text(
                              'Generar Receta con IA',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
