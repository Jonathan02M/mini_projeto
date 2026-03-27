import 'dart:convert';

class Habito {
  String titulo;
  String descricao;
  bool concluido;
  int streak;

  Habito({
    required this.titulo,
    required this.descricao,
    this.concluido = false,
    this.streak = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'descricao': descricao,
      'concluido': concluido,
      'streak': streak,
    };
  }

  factory Habito.fromMap(Map<String, dynamic> map) {
    return Habito(
      titulo: map['titulo'],
      descricao: map['descricao'],
      concluido: map['concluido'],
      streak: map['streak'] ?? 0,
    );
  }

  static String encode(List<Habito> habitos) =>
      json.encode(habitos.map((h) => h.toMap()).toList());

  static List<Habito> decode(String habitos) =>
      (json.decode(habitos) as List<dynamic>)
          .map<Habito>((item) => Habito.fromMap(item))
          .toList();
}