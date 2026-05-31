// widgets/productos.dart
import 'package:flutter/material.dart';
import 'package:michaelespinozac1/services/logica_productos.dart';
import 'package:michaelespinozac1/services/sevicios_pedidos.dart';

class ProductosWidget extends StatefulWidget {
  final Function(String, int) onCantidadCambiada;

  const ProductosWidget({super.key, required this.onCantidadCambiada});

  @override
  State<ProductosWidget> createState() => _ProductosWidgetState();
}

class _ProductosWidgetState extends State<ProductosWidget> {
  final ServicioPedidos _servicioPedidos = ServicioPedidos();
  final Map<String, int> _cantidades = {};

  @override
  Widget build(BuildContext context) {
    final productos = LogicaProductos.instance.getProductos();

    return ListView.builder(
      itemCount: productos.length,
      itemBuilder: (context, index) {
        final producto = productos[index];
        final cantidad = _cantidades[producto.id] ?? 0;

        return Card(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Información del producto
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.shopping_bag, color: Colors.blue),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            producto.nombre,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            producto.descripcion,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                '€${producto.precio.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[700],
                                ),
                              ),
                              SizedBox(width: 16),
                              Text(
                                'Stock: ${producto.stock}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),

                // Controles de cantidad
                Row(
                  children: [
                    // Selector de cantidad
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove, size: 18),
                            onPressed: cantidad > 0
                                ? () {
                                    _actualizarCantidad(producto.id, cantidad - 1);
                                  }
                                : null,
                          ),
                          Container(
                            width: 30,
                            alignment: Alignment.center,
                            child: Text(
                              cantidad.toString(),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.add, size: 18),
                            onPressed: cantidad < producto.stock
                                ? () {
                                    _actualizarCantidad(producto.id, cantidad + 1);
                                  }
                                : null,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 12),

                    // Botón de agregar al carrito
                    Expanded(
                      child: ElevatedButton(
                        onPressed: cantidad > 0
                            ? () {
                                _agregarAlCarrito(producto.id, cantidad);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('$cantidad ${producto.nombre} agregado al carrito'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                        child: Text('Agregar al Carrito'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _actualizarCantidad(String productoId, int nuevaCantidad) {
    setState(() {
      _cantidades[productoId] = nuevaCantidad;
    });
    widget.onCantidadCambiada(productoId, nuevaCantidad);
  }

  void _agregarAlCarrito(String productoId, int cantidad) {
    _servicioPedidos.agregarAlCarrito(productoId, cantidad);
    setState(() {
      _cantidades[productoId] = 0;
    });
    widget.onCantidadCambiada(productoId, 0);
  }
}