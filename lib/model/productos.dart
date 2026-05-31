
class EntradaConcierto {
  String id;
  String nombre;
  String descripcion;
  double precio;
  int stock;
  String imagen;
  bool estaActivo;
  String artista;
  String fecha;
  String lugar;
  String tipo; // 'concierto', 'album', 'festival'

  EntradaConcierto({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.stock,
    required this.imagen,
    required this.artista,
    required this.fecha,
    required this.lugar,
    required this.tipo,
    this.estaActivo = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'precio': precio,
      'stock': stock,
      'imagen': imagen,
      'estaActivo': estaActivo,
      'artista': artista,
      'fecha': fecha,
      'lugar': lugar,
      'tipo': tipo,
    };
  }

  static EntradaConcierto fromMap(Map<String, dynamic> map) {
    return EntradaConcierto(
      id: map['id'].toString(),
      nombre: map['nombre'],
      descripcion: map['descripcion'],
      precio: map['precio'].toDouble(),
      stock: map['stock'],
      imagen: map['imagen'],
      artista: map['artista'],
      fecha: map['fecha'],
      lugar: map['lugar'],
      tipo: map['tipo'],
      estaActivo: map['estaActivo'] ?? true,
    );
  }
}