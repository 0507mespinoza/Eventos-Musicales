class Pedido {
  String id;
  int numeroReserva;
  String usuarioId;
  String nombreUsuario;
  List<ItemPedido> items;
  double total;
  DateTime fecha;
  String estado; // Pedido, En Producción, En Reparto, Entregado

  Pedido({
    required this.id,
    required this.numeroReserva,
    required this.usuarioId,
    required this.nombreUsuario,
    required this.items,
    required this.total,
    required this.fecha,
    required this.estado,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'numeroReserva': numeroReserva,
      'usuarioId': usuarioId,
      'nombreUsuario': nombreUsuario,
      'items': items.map((item) => {
        'productoId': item.productoId,
        'nombreProducto': item.nombreProducto,
        'cantidad': item.cantidad,
        'precio': item.precio,
      }).toList(),
      'total': total,
      'fecha': fecha.toIso8601String(),
      'estado': estado,
    };
  }

  factory Pedido.fromMap(Map<String, dynamic> map) {
    return Pedido(
      id: map['id'],
      numeroReserva: map['numeroReserva'] ?? 100000,
      usuarioId: map['usuarioId'],
      nombreUsuario: map['nombreUsuario'],
      items: (map['items'] as List)
          .map((item) => ItemPedido(
            productoId: item['productoId'],
            nombreProducto: item['nombreProducto'],
            cantidad: item['cantidad'],
            precio: item['precio'].toDouble(),
          ))
          .toList(),
      total: map['total'].toDouble(),
      fecha: DateTime.parse(map['fecha']),
      estado: map['estado'] ?? 'Pedido',
    );
  }
}

class ItemPedido {
  String productoId;
  String nombreProducto;
  int cantidad;
  double precio;

  ItemPedido({
    required this.productoId,
    required this.nombreProducto,
    required this.cantidad,
    required this.precio,
  });
}