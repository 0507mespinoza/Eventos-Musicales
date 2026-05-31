import 'package:flutter/material.dart';
import 'package:michaelespinozac1/model/pedido.dart';
import 'package:michaelespinozac1/services/sevicios_pedidos.dart';
import 'package:provider/provider.dart';

class GestionReservas extends StatefulWidget {
  const GestionReservas({super.key});

  @override
  State<GestionReservas> createState() => _GestionReservasState();
}

class _GestionReservasState extends State<GestionReservas> {
  String _filtroEstado = 'Todas';

  @override
  Widget build(BuildContext context) {
    return Consumer<ServicioPedidos>(
      builder: (context, servicioPedidos, child) {
        final pedidos = servicioPedidos.obtenerTodosLosPedidos();
        final pedidosFiltrados = _filtroEstado == 'Todas'
            ? pedidos
            : pedidos.where((pedido) => pedido.estado == _filtroEstado).toList();

        return Scaffold(
          appBar: AppBar(
            title: Text('Gestión de Reservas'),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
          body: Column(
            children: [
              // Filtro por estado
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Text('Filtrar por estado:'),
                    SizedBox(width: 16),
                    DropdownButton<String>(
                      value: _filtroEstado,
                      items: ['Todas', 'Reservada', 'Confirmada', 'En Proceso', 'Completada', 'Cancelada']
                          .map((estado) => DropdownMenuItem(
                                value: estado,
                                child: Text(estado),
                              ))
                          .toList(),
                      onChanged: (value) => setState(() => _filtroEstado = value!),
                    ),
                  ],
                ),
              ),

              // Lista de reservas
              Expanded(
                child: pedidosFiltrados.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.receipt_long_outlined, size: 64, color: Colors.grey),
                            SizedBox(height: 16),
                            Text(
                              'No hay reservas ${_filtroEstado == 'Todas' ? '' : 'en estado $_filtroEstado'}',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.all(8.0),
                        itemCount: pedidosFiltrados.length,
                        itemBuilder: (context, index) {
                          final pedido = pedidosFiltrados[index];
                          return Card(
                            margin: EdgeInsets.all(8.0),
                            child: ExpansionTile(
                              title: Text('Reserva #${pedido.id.substring(0, 8)}'),
                              subtitle: Text(
                                '${pedido.nombreUsuario} - €${pedido.total.toStringAsFixed(2)} - ${pedido.estado}',
                              ),
                              leading: CircleAvatar(
                                backgroundColor: _getEstadoColor(pedido.estado),
                                child: Icon(
                                  _getEstadoIcon(pedido.estado),
                                  color: Colors.white,
                                ),
                              ),
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Información del pedido
                                      Text('Cliente: ${pedido.nombreUsuario}'),
                                      Text('Fecha: ${pedido.fecha.toString().substring(0, 19)}'),
                                      Text('Total: €${pedido.total.toStringAsFixed(2)}'),
                                      Text('Estado actual: ${pedido.estado}'),
                                      SizedBox(height: 16),

                                      // Items del pedido
                                      Text('Items:', style: TextStyle(fontWeight: FontWeight.bold)),
                                      ...pedido.items.map((item) => Padding(
                                        padding: EdgeInsets.only(left: 16.0, top: 4.0),
                                        child: Text('${item.nombreProducto} x${item.cantidad} - €${item.precio.toStringAsFixed(2)}'),
                                      )),

                                      SizedBox(height: 16),

                                      // Botones para cambiar estado
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: _getBotonesEstado(pedido),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Color _getEstadoColor(String estado) {
    switch (estado) {
      case 'Reservada':
        return Colors.orange;
      case 'Confirmada':
        return Colors.blue;
      case 'En Proceso':
        return Colors.yellow;
      case 'Completada':
        return Colors.green;
      case 'Cancelada':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getEstadoIcon(String estado) {
    switch (estado) {
      case 'Reservada':
        return Icons.schedule;
      case 'Confirmada':
        return Icons.check_circle;
      case 'En Proceso':
        return Icons.hourglass_top;
      case 'Completada':
        return Icons.done_all;
      case 'Cancelada':
        return Icons.cancel;
      default:
        return Icons.help;
    }
  }

  List<Widget> _getBotonesEstado(Pedido pedido) {
    final botones = <Widget>[];

    switch (pedido.estado) {
      case 'Reservada':
        botones.addAll([
          ElevatedButton(
            onPressed: () => _cambiarEstado(pedido, 'Confirmada'),
            child: Text('Confirmar'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          ),
          ElevatedButton(
            onPressed: () => _cambiarEstado(pedido, 'Cancelada'),
            child: Text('Cancelar'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          ),
        ]);
        break;

      case 'Confirmada':
        botones.addAll([
          ElevatedButton(
            onPressed: () => _cambiarEstado(pedido, 'En Proceso'),
            child: Text('Iniciar Proceso'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
          ),
          ElevatedButton(
            onPressed: () => _cambiarEstado(pedido, 'Cancelada'),
            child: Text('Cancelar'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          ),
        ]);
        break;

      case 'En Proceso':
        botones.add(
          ElevatedButton(
            onPressed: () => _cambiarEstado(pedido, 'Completada'),
            child: Text('Completar'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          ),
        );
        break;

      case 'Completada':
      case 'Cancelada':
        // No hay acciones disponibles para estados finales
        break;
    }

    return botones;
  }

  void _cambiarEstado(Pedido pedido, String nuevoEstado) {
    ServicioPedidos.instance.actualizarEstadoPedido(pedido.id, nuevoEstado);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Estado de la reserva actualizado a $nuevoEstado'),
        backgroundColor: Colors.green,
      ),
    );
  }
}