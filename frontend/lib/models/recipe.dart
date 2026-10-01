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
    this.favorito = false,
    required this.fechaCreacion,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      titulo: json['titulo'] ?? 'Receta de Aprovechamiento',
      tiempo: json['tiempo'] ?? '15 min',
      dificultad: json['dificultad'] ?? 'Fácil',
      porciones: json['porciones'] is int
          ? json['porciones']
          : int.tryParse(json['porciones'].toString()) ?? 2,
      ingredientes: json['ingredientes'] != null
          ? List<String>.from(json['ingredientes'].map((e) => e.toString()))
          : [],
      pasos: json['pasos'] != null
          ? List<String>.from(json['pasos'].map((e) => e.toString()))
          : [],
      tipAntidesperdicio: json['tip_antidesperdicio'] ??
          json['tipAntidesperdicio'] ??
          'Conserva los sobrantes en contenedores cerrados.',
      favorito: json['favorito'] == true,
      fechaCreacion: json['fecha_creacion'] ?? DateTime.now().toIso8601String(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'tiempo': tiempo,
      'dificultad': dificultad,
      'porciones': porciones,
      'ingredientes': ingredientes,
      'pasos': pasos,
      'tip_antidesperdicio': tipAntidesperdicio,
      'favorito': favorito,
      'fecha_creacion': fechaCreacion,
    };
  }
}
