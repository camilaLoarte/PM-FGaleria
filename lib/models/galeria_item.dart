class GaleriaItem {
  final int id;
  final String titulo;
  final String imageUrl;
  final String autor;

  GaleriaItem({
    required this.id,
    required this.titulo,
    required this.imageUrl,
    required this.autor,
  });

  factory GaleriaItem.fromMap(Map<String, dynamic> map) {
    return GaleriaItem(
      id: map['id'],
      titulo: map['titulo'],
      imageUrl: map['imageUrl'],
      autor: map['autor'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'imageUrl': imageUrl,
      'autor': autor,
    };
  }
}
