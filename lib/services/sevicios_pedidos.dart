import 'package:flutter/foundation.dart';
import 'dart:math';
import 'package:michaelespinozac1/model/pedido.dart';
import 'package:michaelespinozac1/model/productos.dart';
import 'logica_productos.dart';

class ServicioPedidos extends ChangeNotifier {
  static final ServicioPedidos _instancia = ServicioPedidos._internal();
  factory ServicioPedidos() => _instancia;
  ServicioPedidos._internal();

  final List<Pedido> _pedidos = [];
  final Map<String, int> _carrito = {};
  final Random _random = Random();

  static const List<String> estadosReserva = [
    'Reservada',
    'Pagada',
    'Cancelada',
    'Asistida',
  ];

  static ServicioPedidos get instance => _instancia;

  // Métodos del carrito
  void agregarAlCarrito(String productoId, int cantidad) {
    if (cantidad > 0) {
      _carrito[productoId] = (_carrito[productoId] ?? 0) + cantidad;
      notifyListeners();
    }
  }

  void actualizarCantidadCarrito(String productoId, int cantidad) {
    if (cantidad <= 0) {
      _carrito.remove(productoId);
    } else {
      _carrito[productoId] = cantidad;
    }
    notifyListeners();
  }

  void eliminarDelCarrito(String productoId) {
    _carrito.remove(productoId);
    notifyListeners();
  }

  void limpiarCarrito() {
    _carrito.clear();
    notifyListeners();
  }

  Map<String, int> get carrito => Map.from(_carrito);

  int get cantidadTotalCarrito {
    return _carrito.values.fold(0, (sum, cantidad) => sum + cantidad);
  }

  double get totalCarrito {
    double total = 0;
    _carrito.forEach((productoId, cantidad) {
      final producto = LogicaProductos.instance.obtenerProducto(productoId);
      if (producto != null) {
        total += producto.precio * cantidad;
      }
    });
    return total;
  }

  List<Map<String, dynamic>> get itemsCarrito {
    List<Map<String, dynamic>> items = [];
    _carrito.forEach((productoId, cantidad) {
      final producto = LogicaProductos.instance.obtenerProducto(productoId);
      if (producto != null) {
        items.add({
          'producto': producto,
          'cantidad': cantidad,
          'subtotal': producto.precio * cantidad,
        });
      }
    });
    return items;
  }

  // MÉTODO MODIFICADO: Ahora acepta un objeto Pedido
  void crearPedido(Pedido pedido) {
    _pedidos.add(pedido);
    notifyListeners();
    // También puedes limpiar el carrito interno si es necesario
    // limpiarCarrito();
  }

  // Método original mantenido por si lo necesitas
  Pedido crearPedidoConCarrito(String usuarioId, String usuarioNombre) {
    final items = itemsCarrito.map((item) {
      final producto = item['producto'] as EntradaConcierto;
      return ItemPedido(
        productoId: producto.id,
        nombreProducto: producto.nombre,
        cantidad: item['cantidad'] as int,
        precio: producto.precio,
      );
    }).toList();

    final pedido = Pedido(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      numeroReserva: _generarNumeroReserva(),
      usuarioId: usuarioId,
      nombreUsuario: usuarioNombre,
      items: items,
      total: totalCarrito,
      fecha: DateTime.now(),
      estado: 'Reservada',
    );

    _pedidos.add(pedido);
    limpiarCarrito();
    notifyListeners();
    
    return pedido;
  }

  List<Pedido> obtenerPedidosPorUsuario(String usuarioId) {
    return _pedidos.where((pedido) => pedido.usuarioId == usuarioId).toList();
  }

  List<Pedido> obtenerTodosLosPedidos() {
    return List.from(_pedidos);
  }

  void actualizarEstadoPedido(String pedidoId, String nuevoEstado) {
    if (!estadosReserva.contains(nuevoEstado)) {
      return;
    }

    final index = _pedidos.indexWhere((p) => p.id == pedidoId);
    if (index != -1) {
      final pedidoActual = _pedidos[index];
      _pedidos[index] = Pedido(
        id: pedidoActual.id,
        numeroReserva: pedidoActual.numeroReserva,
        usuarioId: pedidoActual.usuarioId,
        nombreUsuario: pedidoActual.nombreUsuario,
        items: pedidoActual.items,
        total: pedidoActual.total,
        fecha: pedidoActual.fecha,
        estado: nuevoEstado,
      );
      notifyListeners();
    }
  }

  int generarNumeroReserva() => _generarNumeroReserva();

  int _generarNumeroReserva() {
    return 100000 + _random.nextInt(900000);
  }

  bool verificarStockSuficiente() {
    for (var entry in _carrito.entries) {
      final producto = LogicaProductos.instance.obtenerProducto(entry.key);
      if (producto == null || producto.stock < entry.value) {
        return false;
      }
    }
    return true;
  }
}