import 'package:flutter/material.dart';
import 'package:michaelespinozac1/services/sevicios_pedidos.dart';

class PaginaGestionPedidos extends StatefulWidget {
  const PaginaGestionPedidos({super.key});

  @override
  State<PaginaGestionPedidos> createState() => _PaginaGestionPedidosState();
}

class _PaginaGestionPedidosState extends State<PaginaGestionPedidos> {
  List<dynamic> _pedidos = [];

  @override
  void initState() {
    super.initState();
    _cargarPedidos();
  }

  void _cargarPedidos() {
    setState(() {
      _pedidos = ServicioPedidos.instance.obtenerTodosLosPedidos();
    });
  }

  void _cambiarEstadoPedido(dynamic pedido, String nuevoEstado) {
    ServicioPedidos.instance.actualizarEstadoPedido(pedido.id, nuevoEstado);
    _cargarPedidos();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Estado de la reserva actualizado a $nuevoEstado')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _pedidos.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No hay reservas',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: _pedidos.length,
              itemBuilder: (context, index) {
                final pedido = _pedidos[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 12),
                  child: ExpansionTile(
                    title: Text(
                      'Reserva #${pedido.numeroReserva}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Cliente: ${pedido.nombreUsuario}'),
                        Text('Total: €${pedido.total.toStringAsFixed(2)}'),
                        Text('Estado: ${pedido.estado}'),
                        Text('Fecha: ${pedido.fecha.toString().split(' ')[0]}'),
                      ],
                    ),
                    children: [
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Entradas:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            ...pedido.items.map<Widget>((producto) => Padding(
                              padding: EdgeInsets.only(bottom: 4),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text('${producto.nombreProducto} x${producto.cantidad}'),
                                  ),
                                  Text('€${(producto.precio * producto.cantidad).toStringAsFixed(2)}'),
                                ],
                              ),
                            )),
                            SizedBox(height: 16),
                            Text(
                              'Cambiar estado:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              children: [
                                ElevatedButton(
                                  onPressed: pedido.estado != 'Reservada'
                                      ? () => _cambiarEstadoPedido(pedido, 'Reservada')
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: Text('Reservada'),
                                ),
                                ElevatedButton(
                                  onPressed: pedido.estado != 'Pagada'
                                      ? () => _cambiarEstadoPedido(pedido, 'Pagada')
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: Text('Pagada'),
                                ),
                                ElevatedButton(
                                  onPressed: pedido.estado != 'Cancelada'
                                      ? () => _cambiarEstadoPedido(pedido, 'Cancelada')
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: Text('Cancelada'),
                                ),
                                ElevatedButton(
                                  onPressed: pedido.estado != 'Asistida'
                                      ? () => _cambiarEstadoPedido(pedido, 'Asistida')
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: Text('Asistida'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
  }
}