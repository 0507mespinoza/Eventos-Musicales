
import 'package:flutter/foundation.dart';
import 'package:michaelespinozac1/model/productos.dart';

class LogicaProductos extends ChangeNotifier {
  static final LogicaProductos _instance = LogicaProductos._internal();
  factory LogicaProductos() => _instance;
  LogicaProductos._internal();

  final List<EntradaConcierto> _productos = [
    EntradaConcierto(
      id: '1',
      nombre: 'Rocanrola 2026',
      descripcion: 'El festival de rap y hip-hop más esperado del año con los mejores artistas del género.',
      precio: 75.00,
      stock: 800,
      imagen: 'assets/images/rocanrola.png',
      artista: 'Varios Artistas',
      fecha: '2026-07-20',
      lugar: 'Recinto Ferial IFEMA, Madrid',
      tipo: 'festival',
    ),
    EntradaConcierto(
      id: '2',
      nombre: 'Festival Coachella 2024',
      descripcion: 'Festival de música más importante del mundo con artistas internacionales.',
      precio: 299.99,
      stock: 1000,
      imagen: 'assets/images/coachella.jpg',
      artista: 'Varios Artistas',
      fecha: '2024-04-12',
      lugar: 'Empire Polo Club, Indio, California',
      tipo: 'festival',
    ),
    EntradaConcierto(
      id: '3',
      nombre: 'Concierto Taylor Swift - Eras Tour',
      descripcion: 'Show internacional con los éxitos más importantes de Taylor Swift.',
      precio: 129.99,
      stock: 250,
      imagen: 'assets/images/taylor.jpg',
      artista: 'Taylor Swift',
      fecha: '2024-09-10',
      lugar: 'Wembley Stadium, Londres',
      tipo: 'concierto',
    ),
  ];

  static LogicaProductos get instance => _instance;

  List<EntradaConcierto> getProductos() {
    return _productos.where((producto) => producto.estaActivo).toList();
  }

  List<EntradaConcierto> obtenerProductos() {
    return getProductos();
  }

  List<EntradaConcierto> getAllProductos() {
    return _productos;
  }

  void agregarProducto(EntradaConcierto producto) {
    _productos.add(producto);
    notifyListeners();
  }

  void eliminarProducto(String id) {
    _productos.removeWhere((producto) => producto.id == id);
    notifyListeners();
  }

  void actualizarProducto(EntradaConcierto productoActualizado) {
    final index = _productos.indexWhere((p) => p.id == productoActualizado.id);
    if (index != -1) {
      _productos[index] = productoActualizado;
      notifyListeners();
    }
  }

  EntradaConcierto? obtenerProducto(String id) {
    try {
      return _productos.firstWhere((producto) => producto.id == id);
    } catch (e) {
      return null;
    }
  }

  void actualizarStock(String productoId, int cantidadVendida) {
    final producto = obtenerProducto(productoId);
    if (producto != null && producto.stock >= cantidadVendida) {
      producto.stock -= cantidadVendida;
      actualizarProducto(producto);
    }
  }

  void aumentarStock(String productoId, int cantidad) {
    final producto = obtenerProducto(productoId);
    if (producto != null) {
      producto.stock += cantidad;
      actualizarProducto(producto);
    }
  }

  void setStock(String productoId, int nuevoStock) {
    final producto = obtenerProducto(productoId);
    if (producto != null) {
      producto.stock = nuevoStock;
      actualizarProducto(producto);
    }
  }

  List<EntradaConcierto> buscarProductos(String query) {
    if (query.isEmpty) return getProductos();
    
    return _productos.where((producto) {
      return producto.nombre.toLowerCase().contains(query.toLowerCase()) ||
             producto.descripcion.toLowerCase().contains(query.toLowerCase()) ||
             producto.artista.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
}