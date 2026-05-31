import 'package:flutter/material.dart';
import 'package:michaelespinozac1/services/evento_localizado_helper.dart';
import 'package:michaelespinozac1/services/logica_productos.dart';
import 'package:michaelespinozac1/services/sevicios_pedidos.dart';
import 'package:michaelespinozac1/services/servicio_autentificacion.dart';
import 'package:michaelespinozac1/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class PaginaPedidosCliente extends StatefulWidget {
  const PaginaPedidosCliente({super.key});

  @override
  State<PaginaPedidosCliente> createState() => _PaginaPedidosClienteState();
}

class _PaginaPedidosClienteState extends State<PaginaPedidosCliente> {
  final ServicioAutenticacion _servicioAuth = ServicioAutenticacion();

  @override
  Widget build(BuildContext context) {
    final usuario = _servicioAuth.usuarioActual;
    final localization = AppLocalizations.of(context);

    if (usuario == null) {
      return Center(child: Text(localization.error));
    }

    return Consumer<ServicioPedidos>(
      builder: (context, servicioPedidos, child) {
        // Obtener pedidos del usuario actual
        final pedidosDelUsuario = servicioPedidos.obtenerPedidosPorUsuario(usuario.id);

        return pedidosDelUsuario.isEmpty
            ? Center(
                child: Text(localization.noReservationsMade),
              )
            : ListView.builder(
                padding: EdgeInsets.all(8.0),
                itemCount: pedidosDelUsuario.length,
                itemBuilder: (context, index) {
                  final pedido = pedidosDelUsuario[index];

                    return Card(
                      margin: EdgeInsets.all(8.0),
                      child: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Número de pedido y fecha
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${localization.reservationPrefix}${pedido.numeroReserva}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '${pedido.fecha.day}/${pedido.fecha.month}/${pedido.fecha.year}',
                                      style: TextStyle(fontSize: 12, color: Colors.grey),
                                    ),
                                  ],
                                ),
                                // Estado del pedido con color
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: _obtenerColorEstado(pedido.estado),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    pedido.estado,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            // Items del pedido
                            Text(
                                        localization.reservedTickets,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                                      ...pedido.items.map((item) => Text(
                                        '- ${_nombreProductoLocalizado(item.productoId, item.nombreProducto, localization)} (${item.cantidad}x €${item.precio.toStringAsFixed(2)})',
                                        style: TextStyle(fontSize: 12),
                                      )),
                            SizedBox(height: 8),
                            // Total
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${localization.total}:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '€${pedido.total.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
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
      },
    );
  }

  Color _obtenerColorEstado(String estado) {
    switch (estado) {
      case 'Reservada':
        return Colors.orange;
      case 'Pagada':
        return Colors.blue;
      case 'Cancelada':
        return Colors.red;
      case 'Asistida':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _nombreProductoLocalizado(
    String productoId,
    String fallback,
    AppLocalizations localization,
  ) {
    final producto = LogicaProductos.instance.obtenerProducto(productoId);
    if (producto != null) {
      return EventoLocalizadoHelper.localizeProducto(producto, localization).nombre;
    }

    return EventoLocalizadoHelper.localizedNameFromId(productoId, localization, fallback);
  }
}
