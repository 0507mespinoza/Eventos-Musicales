import 'package:flutter/material.dart';
import 'package:michaelespinozac1/services/sevicios_pedidos.dart';
import 'package:michaelespinozac1/l10n/app_localizations.dart';

class GestionPedidos extends StatefulWidget {
  const GestionPedidos({super.key});

  @override
  State<GestionPedidos> createState() => _GestionPedidosState();
}

class _GestionPedidosState extends State<GestionPedidos> {
  final ServicioPedidos _servicioPedidos = ServicioPedidos();

  @override
  Widget build(BuildContext context) {
    final pedidos = _servicioPedidos.obtenerTodosLosPedidos();
    final localization = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localization.orderManagement),
        backgroundColor: Colors.blue,
      ),
      body: pedidos.isEmpty
          ? Center(
              child: Text('No hay pedidos'),
            )
          : ListView.builder(
              padding: EdgeInsets.all(8.0),
              itemCount: pedidos.length,
              itemBuilder: (context, index) {
                final pedido = pedidos[index];

                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Encabezado
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Pedido #${pedido.id}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  'Usuario: ${pedido.nombreUsuario}',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () => _cambiarEstado(context, pedido.id, pedido.estado),
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: _obtenerColorEstado(pedido.estado),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  _obtenerEstadoTraducido(pedido.estado, localization),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        // Items
                        Text(
                          '${localization.shopping}:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        ...pedido.items.map((item) => Text(
                          '- ${item.nombreProducto} (${item.cantidad}x €${item.precio.toStringAsFixed(2)})',
                          style: TextStyle(fontSize: 11),
                        )),
                        SizedBox(height: 8),
                        // Total y Fecha
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${localization.total}: €${pedido.total.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                            Text(
                              '${pedido.fecha.day}/${pedido.fecha.month}/${pedido.fecha.year}',
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _cambiarEstado(BuildContext context, String pedidoId, String estadoActual) {
    final estados = ['Pedido', 'En Producción', 'En Reparto', 'Entregado'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cambiar Estado del Pedido'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: estados
                .map((estado) => RadioListTile<String>(
                  title: Text(estado),
                  value: estado,
                  groupValue: estadoActual,
                  onChanged: (value) {
                    if (value != null) {
                      _servicioPedidos.actualizarEstadoPedido(pedidoId, value);
                      Navigator.pop(context);
                      setState(() {});
                    }
                  },
                ))
                .toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  Color _obtenerColorEstado(String estado) {
    switch (estado) {
      case 'Pedido':
        return Colors.orange;
      case 'En Producción':
        return Colors.blue;
      case 'En Reparto':
        return Colors.purple;
      case 'Entregado':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _obtenerEstadoTraducido(String estado, AppLocalizations localization) {
    switch (estado) {
      case 'Reservada':
        return localization.pending;
      case 'Pagada':
        return localization.inProduction;
      case 'Cancelada':
        return localization.inDelivery;
      case 'Asistida':
        return localization.delivered;
      default:
        return estado;
    }
  }
}
