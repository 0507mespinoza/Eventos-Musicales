// widgets/carrito.dart
import 'package:flutter/material.dart';
import 'package:michaelespinozac1/services/servicio_autentificacion.dart';
import 'package:michaelespinozac1/services/sevicios_pedidos.dart';


class CarritoWidget extends StatefulWidget {
  final Function(String, int) onCantidadCambiada;

  const CarritoWidget({super.key, required this.onCantidadCambiada});

  @override
  State<CarritoWidget> createState() => _CarritoWidgetState();
}

class _CarritoWidgetState extends State<CarritoWidget> {
  final ServicioPedidos _servicioPedidos = ServicioPedidos();
  final ServicioAutenticacion _servicioAutenticacion = ServicioAutenticacion();

  @override
  Widget build(BuildContext context) {
    final itemsCarrito = _servicioPedidos.itemsCarrito;
    final total = _servicioPedidos.totalCarrito;
    final cantidadTotal = _servicioPedidos.cantidadTotalCarrito;

    if (cantidadTotal == 0) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          border: Border(top: BorderSide(color: Colors.grey[300]!)),
        ),
        child: Center(
          child: Text(
            'El carrito está vacío',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Resumen del carrito
          Text(
            'Carrito ($cantidadTotal ${cantidadTotal == 1 ? 'producto' : 'productos'})',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          // Lista de productos en el carrito
          ...itemsCarrito.map((item) {
            final producto = item['producto'];
            final cantidad = item['cantidad'] as int;
            final subtotal = item['subtotal'] as double;

            return ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Icon(Icons.shopping_bag, size: 20, color: Colors.grey[500]),
              ),
              title: Text(
                producto.nombre,
                style: const TextStyle(fontSize: 14),
              ),
              subtitle: Text(
                '€${producto.precio.toStringAsFixed(2)} x $cantidad',
                style: const TextStyle(fontSize: 12),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '€${subtotal.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red, size: 18),
                    onPressed: () {
                      _eliminarDelCarrito(producto.id);
                    },
                  ),
                ],
              ),
            );
          }),

          const Divider(),

          // Total y botón de comprar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '€${total.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Botón de realizar pedido
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _realizarPedido(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Realizar Pedido',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _eliminarDelCarrito(String productoId) {
    _servicioPedidos.eliminarDelCarrito(productoId);
    setState(() {});
    widget.onCantidadCambiada(productoId, 0);
  }

  void _realizarPedido(BuildContext context) {
    final usuario = _servicioAutenticacion.usuarioActual;
    if (usuario == null) return;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Pedido'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('¿Estás seguro de que quieres realizar este pedido?'),
              const SizedBox(height: 16),
              Text(
                'Total: €${_servicioPedidos.totalCarrito.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                // USAR EL MÉTODO CORRECTO: crearPedidoConCarrito
                final pedido = _servicioPedidos.crearPedidoConCarrito(usuario.id, usuario.nombre);
                Navigator.of(context).pop();
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('¡Pedido realizado con éxito! Nº ${pedido.id.substring(0, 8)}'),
                    backgroundColor: Colors.green,
                    duration: const Duration(seconds: 3),
                  ),
                );
                
                // Forzar actualización
                setState(() {});
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }
}