import 'package:flutter/material.dart';
import 'package:michaelespinozac1/l10n/app_localizations.dart';
import 'package:michaelespinozac1/screens/PaginaPedidos.dart';
import 'package:michaelespinozac1/screens/PaginaPerfil.dart';
// import eliminado por duplicado
import 'package:michaelespinozac1/services/servicio_autentificacion.dart';
import 'package:michaelespinozac1/services/evento_localizado_helper.dart';
import 'package:michaelespinozac1/model/pedido.dart';
import 'package:michaelespinozac1/services/sevicios_pedidos.dart';
import 'package:michaelespinozac1/model/productos.dart';
import 'package:michaelespinozac1/screens/paginas_cliente/pagina_detalle_evento.dart';

class PaginaSecundaria extends StatefulWidget {
  const PaginaSecundaria({super.key});

  @override
  State<PaginaSecundaria> createState() => _PaginaSecundariaState();
}

class _PaginaSecundariaState extends State<PaginaSecundaria> {
  final ServicioAutenticacion _servicioAuth = ServicioAutenticacion();
  final ServicioPedidos _servicioPedidos = ServicioPedidos();
  
  // Lista de eventos de música disponibles
  final List<Map<String, dynamic>> _productos = [
    {
      'id': '1',
      'nombre': 'Rocanrola 2026',
      'precio': 75.00,
      'descripcion': 'El festival de rap y hip-hop más esperado del año con los mejores artistas del género.',
      'imagen': 'assets/images/rocanrola.png',
      'categoria': 'Festival',
      'tipo': 'Festival',
      'stock': 800,
      'artista': 'Varios Artistas',
      'fecha': '2026-07-20',
      'lugar': 'Recinto Ferial IFEMA, Madrid'
    },
    {
      'id': '2',
      'nombre': 'Festival Coachella 2024',
      'precio': 299.99,
      'descripcion': 'Festival de música más importante del mundo con artistas internacionales.',
      'imagen': 'assets/images/coachella.jpg',
      'categoria': 'Festival',
      'tipo': 'Festival',
      'stock': 1000,
      'artista': 'Varios Artistas',
      'fecha': '2024-04-12',
      'lugar': 'Empire Polo Club, Indio, California'
    },
    {
      'id': '3',
      'nombre': 'Concierto Taylor Swift - Eras Tour',
      'precio': 129.99,
      'descripcion': 'Show internacional con los éxitos más importantes de Taylor Swift.',
      'imagen': 'assets/images/taylor.jpg',
      'categoria': 'Concierto',
      'tipo': 'Concierto',
      'stock': 250,
      'artista': 'Taylor Swift',
      'fecha': '2024-09-10',
      'lugar': 'Wembley Stadium, Londres'
    },
  ];

  // Carrito de compras
  final List<Map<String, dynamic>> _carrito = [];
  double _totalCarrito = 0.0;

  // Controladores para búsqueda
  final TextEditingController _busquedaController = TextEditingController();
  String _filtroCategoria = 'Todos';
  String _terminoBusqueda = '';

  @override
  void initState() {
    super.initState();
    _actualizarTotal();
  }

  // Filtrar productos según búsqueda y categoría
  List<Map<String, dynamic>> get _productosFiltrados {
    final localization = AppLocalizations.of(context);
    return _productos.where((producto) {
      final productoLocalizado = EventoLocalizadoHelper.localizeProductoMap(producto, localization);
      final coincideBusqueda = _terminoBusqueda.isEmpty ||
          (productoLocalizado['nombre'] as String).toLowerCase().contains(_terminoBusqueda.toLowerCase()) ||
          (productoLocalizado['descripcion'] as String).toLowerCase().contains(_terminoBusqueda.toLowerCase());
      
      final coincideCategoria = _filtroCategoria == 'Todos' || 
          productoLocalizado['categoria'] == _filtroCategoria;
      
      return coincideBusqueda && coincideCategoria;
    }).toList();
  }

  // Obtener categorías únicas
  List<String> get _categorias {
    final localization = AppLocalizations.of(context);
    final categorias = _productos
        .map((producto) => EventoLocalizadoHelper.localizeProductoMap(producto, localization)['categoria'] as String)
        .toSet()
        .toList();
    categorias.insert(0, 'Todos');
    return categorias;
  }

  // Agregar producto al carrito con validación de stock
  void _agregarAlCarrito(Map<String, dynamic> producto) {
    final stock = producto['stock'] as int? ?? 0;
    final index = _carrito.indexWhere((item) => item['id'] == producto['id']);
    final cantidadActual = index != -1 ? (_carrito[index]['cantidad'] as int) : 0;
    
    // Validar que hay stock disponible
    if (cantidadActual >= stock) {
      _mostrarMensaje('Stock insuficiente para ${producto['nombre']}', esError: true);
      return;
    }
    
    if (index != -1) {
      // Si ya existe, aumentar cantidad
      _carrito[index]['cantidad'] = (_carrito[index]['cantidad'] as int) + 1;
    } else {
      // Si no existe, agregar nuevo
      _carrito.add({
        'id': producto['id'],
        'nombre': producto['nombre'],
        'precio': producto['precio'],
        'imagen': producto['imagen'],
        'cantidad': 1,
        'stock': stock,
      });
    }
    
    _actualizarTotal();
    _mostrarMensaje('${producto['nombre']} agregado al carrito');
  }

  // Remover producto del carrito
  void _removerDelCarrito(String productoId) {
    final index = _carrito.indexWhere((item) => item['id'] == productoId);
    
    if (index != -1) {
      if (_carrito[index]['cantidad'] > 1) {
        _carrito[index]['cantidad'] = (_carrito[index]['cantidad'] as int) - 1;
      } else {
        _carrito.removeAt(index);
      }
    }
    
    _actualizarTotal();
  }

  // Actualizar total del carrito
  void _actualizarTotal() {
    setState(() {
      _totalCarrito = _carrito.fold(0.0, (total, item) {
        return total + (item['precio'] * (item['cantidad'] as int));
      });
    });
  }

  // Realizar pedido con actualización de stock
  void _realizarPedido() {
    if (_carrito.isEmpty) {
      _mostrarMensaje('El carrito está vacío', esError: true);
      return;
    }

    final usuarioActual = _servicioAuth.usuarioActual;
    if (usuarioActual == null) {
      _mostrarMensaje('Error: Usuario no autenticado', esError: true);
      return;
    }

    // Convertir los items del carrito a ItemPedido
    List<ItemPedido> itemsPedido = _carrito.map((item) {
      return ItemPedido(
        productoId: item['id'],
        nombreProducto: item['nombre'],
        cantidad: item['cantidad'] as int,
        precio: item['precio'] as double,
      );
    }).toList();

    // Actualizar stock de cada producto
    for (var item in _carrito) {
      final productoId = item['id'];
      final cantidad = item['cantidad'] as int;
      final index = _productos.indexWhere((p) => p['id'] == productoId);
      if (index != -1) {
        _productos[index]['stock'] = (_productos[index]['stock'] as int) - cantidad;
      }
    }

    // Crear nuevo pedido
    final nuevoPedido = Pedido(
    id: DateTime.now().millisecondsSinceEpoch.toString(),
    numeroReserva: _servicioPedidos.generarNumeroReserva(),
    usuarioId: usuarioActual.id,
    nombreUsuario: usuarioActual.nombre,
    items: itemsPedido,
    total: _totalCarrito,
    fecha: DateTime.now(),
    estado: 'Reservada',
  );

    _servicioPedidos.crearPedido(nuevoPedido);
    
    // Limpiar carrito
    _carrito.clear();
    _actualizarTotal();
    setState(() {}); // Refrescar UI para mostrar stock actualizado
    
    _mostrarMensaje('¡Pedido realizado exitosamente!');
  }

  void _mostrarMensaje(String mensaje, {bool esError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: esError ? Colors.red : Colors.green,
      ),
    );
  }

  void _vaciarCarrito() {
    setState(() {
      _carrito.clear();
      _totalCarrito = 0.0;
    });
    _mostrarMensaje('Carrito vaciado');
  }

  // Obtener total de items en el carrito
  int _obtenerTotalItemsCarrito() {
    return _carrito.fold<int>(0, (sum, item) => sum + (item['cantidad'] as int));
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('🎵 Eventos de Música'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          // Botón para ver pedidos
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PaginaPedidos()),
              );
            },
            icon: const Icon(Icons.shopping_bag),
            tooltip: 'Ver mis pedidos',
          ),
          // Indicador del carrito
          Stack(
            children: [
              IconButton(
                onPressed: _carrito.isEmpty ? null : () => _mostrarDialogoCarrito(),
                icon: const Icon(Icons.shopping_cart),
                tooltip: 'Ver carrito',
              ),
              if (_carrito.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      _obtenerTotalItemsCarrito().toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Barra de búsqueda
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _busquedaController,
              decoration: InputDecoration(
              hintText: 'Buscar eventos...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                suffixIcon: _terminoBusqueda.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _busquedaController.clear();
                          setState(() {
                            _terminoBusqueda = '';
                          });
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                setState(() {
                  _terminoBusqueda = value;
                });
              },
            ),
          ),

          // Filtro por categoría
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categorias.length,
              itemBuilder: (context, index) {
                final categoria = _categorias[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ChoiceChip(
                    label: Text(categoria),
                    selected: _filtroCategoria == categoria,
                    onSelected: (selected) {
                      setState(() {
                        _filtroCategoria = categoria;
                      });
                    },
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 8),

          // Lista de productos
          Expanded(
            child: _productosFiltrados.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'No se encontraron eventos',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: _productosFiltrados.length,
                    itemBuilder: (context, index) {
                      final productoOriginal = _productosFiltrados[index];
                      final productoLocalizado = EventoLocalizadoHelper.localizeProductoMap(
                        productoOriginal,
                        localization,
                      );
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PaginaDetalleEvento(
                                producto: EntradaConcierto.fromMap(productoOriginal),
                              ),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Imagen del evento
                                Center(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(
                                      productoLocalizado['imagen'],
                                      height: 100,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) =>
                                          const Icon(Icons.music_note, size: 60, color: Colors.blue),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // Nombre del producto
                                Text(
                                  productoLocalizado['nombre'],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                // Descripción
                                Text(
                                  productoLocalizado['descripcion'],
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                // Stock
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: (productoLocalizado['stock'] as int) > 0 ? Colors.green[50] : Colors.red[50],
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'Stock: ${productoLocalizado['stock']}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: (productoLocalizado['stock'] as int) > 0 ? Colors.green : Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // Precio y botón
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '€${productoLocalizado['precio']}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: (productoLocalizado['stock'] as int) > 0 ? () => _agregarAlCarrito(productoOriginal) : null,
                                      icon: const Icon(Icons.add_shopping_cart),
                                      color: (productoLocalizado['stock'] as int) > 0 ? Colors.blue : Colors.grey,
                                      tooltip: (productoLocalizado['stock'] as int) > 0 ? 'Agregar al carrito' : 'Sin stock',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      
      // FOOTER CON BOTONES DE NAVEGACIÓN
      bottomNavigationBar: _buildFooter(context),
      
      // Botón flotante para realizar compra de entradas
      floatingActionButton: _carrito.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: _realizarPedido,
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.shopping_bag),
              label: Text('€${_totalCarrito.toStringAsFixed(2)}'),
            )
          : null,
    );
  }

  // FOOTER CON BOTONES DE NAVEGACIÓN
  Widget _buildFooter(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Botón HOME (activo)
          _footerButton(
            icon: Icons.home,
            label: 'Home',
            onPressed: () {
              // Ya estamos en home, no hacer nada
            },
            isActive: true,
          ),
          
          // Botón PEDIDOS
          _footerButton(
            icon: Icons.shopping_bag,
            label: 'Pedidos',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PaginaPedidos()),
              );
            },
          ),
          
          // Botón PERFIL
          _footerButton(
            icon: Icons.person,
            label: 'Yo',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PaginaPerfil()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _footerButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    bool isActive = false,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: onPressed,
          icon: Icon(
            icon,
            color: isActive ? Colors.blue : Colors.grey,
            size: 28,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isActive ? Colors.blue : Colors.grey,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  // Diálogo para ver el carrito
  void _mostrarDialogoCarrito() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.shopping_cart),
            SizedBox(width: 8),
            Text('Mi Carrito de Entradas'),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: _carrito.isEmpty
              ? const Center(
                  child: Text('El carrito está vacío'),
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ..._carrito.map((item) => ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.asset(
                              item['imagen'],
                              width: 48,
                              height: 48,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.music_note, size: 32, color: Colors.blue),
                            ),
                          ),
                          title: Text(item['nombre']),
                          subtitle: Text('€${item['precio']} x ${item['cantidad']}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () => _removerDelCarrito(item['id']),
                                icon: const Icon(Icons.remove, size: 20),
                                tooltip: 'Quitar uno',
                              ),
                              Text('${item['cantidad']}'),
                              IconButton(
                                onPressed: () => _agregarAlCarrito(item),
                                icon: const Icon(Icons.add, size: 20),
                                tooltip: 'Agregar uno más',
                              ),
                            ],
                          ),
                        )),
                    const Divider(),
                    ListTile(
                      title: const Text(
                        'Total:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      trailing: Text(
                        '€${_totalCarrito.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Seguir explorando'),
          ),
          if (_carrito.isNotEmpty) ...[
            TextButton(
              onPressed: _vaciarCarrito,
              child: const Text('Vaciar carrito', style: TextStyle(color: Colors.red)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _realizarPedido();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text('Comprar Entradas', style: TextStyle(color: Colors.white)),
            ),
          ],
        ],
      ),
    );
  }

  @override
  void dispose() {
    _busquedaController.dispose();
    super.dispose();
  }
}