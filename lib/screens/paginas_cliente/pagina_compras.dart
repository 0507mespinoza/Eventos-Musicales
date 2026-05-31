import 'package:flutter/material.dart';
import 'package:michaelespinozac1/services/logica_productos.dart';
import 'package:michaelespinozac1/services/evento_localizado_helper.dart';
import 'package:michaelespinozac1/services/sevicios_pedidos.dart';
import 'package:michaelespinozac1/services/servicio_autentificacion.dart';
import 'package:michaelespinozac1/model/pedido.dart';
import 'package:michaelespinozac1/model/productos.dart';
import 'package:michaelespinozac1/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class PaginaCompras extends StatefulWidget {
  final ValueChanged<EntradaConcierto>? onEventoSeleccionado;

  const PaginaCompras({super.key, this.onEventoSeleccionado});

  @override
  State<PaginaCompras> createState() => _PaginaComprasState();
}

class _PaginaComprasState extends State<PaginaCompras> {
  final ServicioPedidos _servicioPedidos = ServicioPedidos.instance;
  final ServicioAutenticacion _servicioAuth = ServicioAutenticacion();
  
  Map<String, int> cantidadesSeleccionadas = {};

  @override
  void initState() {
    super.initState();
    _inicializarCantidades();
  }

  void _inicializarCantidades() {
    final productos = LogicaProductos.instance.getProductos();
    for (var producto in productos) {
      cantidadesSeleccionadas[producto.id] = 0;
    }
  }

  void _mostrarMensaje(String mensaje, {bool esError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: esError ? Colors.red : Colors.green,
      ),
    );
  }

  void _comprar() {
    final localization = AppLocalizations.of(context);
    
    // Validar que se haya seleccionado al menos un producto
    final tieneProductos = cantidadesSeleccionadas.values.any((cantidad) => cantidad > 0);
    if (!tieneProductos) {
      _mostrarMensaje(localization.noProductsSelected, esError: true);
      return;
    }

    // Crear items del pedido
    List<ItemPedido> items = [];
    double total = 0.0;

    cantidadesSeleccionadas.forEach((productoId, cantidad) {
      if (cantidad > 0) {
        final producto = LogicaProductos.instance.obtenerProducto(productoId);
        if (producto != null) {
          final productoLocalizado = EventoLocalizadoHelper.localizeProducto(producto, localization);
          // Validar stock
          if (cantidad > producto.stock) {
            _mostrarMensaje(
              '${productoLocalizado.nombre}: ${localization.quantityExceedsStock}',
              esError: true,
            );
            return;
          }

          items.add(ItemPedido(
            productoId: producto.id,
            nombreProducto: productoLocalizado.nombre,
            cantidad: cantidad,
            precio: producto.precio,
          ));
          
          total += producto.precio * cantidad;

          // Actualizar stock
          LogicaProductos.instance.actualizarStock(productoId, cantidad);
        }
      }
    });

    if (items.isEmpty) {
      _mostrarMensaje(localization.noProductsSelected, esError: true);
      return;
    }

    // Crear pedido
    final usuario = _servicioAuth.usuarioActual;
    if (usuario == null) {
      _mostrarMensaje(localization.unauthenticatedUserError, esError: true);
      return;
    }

    final pedido = Pedido(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      numeroReserva: _servicioPedidos.generarNumeroReserva(),
      usuarioId: usuario.id,
      nombreUsuario: usuario.nombre,
      items: items,
      total: total,
      fecha: DateTime.now(),
      estado: 'Reservada',
    );

    _servicioPedidos.crearPedido(pedido);

    // Limpiar cantidades
    setState(() {
      _inicializarCantidades();
    });

    _mostrarMensaje(localization.purchaseSuccessful);
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);

    return Consumer<LogicaProductos>(
      builder: (context, logicaProductos, child) {
        final productos = logicaProductos.getProductos();

        return Column(
          children: [
            Expanded(
              child: productos.isEmpty
                  ? Center(
                      child: Text(localization.noProductsSelected),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.all(8.0),
                      itemCount: productos.length,
                      itemBuilder: (context, index) {
                        final producto = productos[index];
                        final productoLocalizado = EventoLocalizadoHelper.localizeProducto(producto, localization);
                        final cantidad = cantidadesSeleccionadas[producto.id] ?? 0;

                        return Card(
                          margin: EdgeInsets.all(8.0),
                          child: Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                              // Imagen del producto
                              Container(
                                width: double.infinity,
                                height: 200,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: productoLocalizado.imagen.isNotEmpty
                                    ? (productoLocalizado.imagen.startsWith('assets/')
                                        ? Image.asset(
                                            productoLocalizado.imagen,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) {
                                              return Center(
                                                child: Icon(Icons.image_not_supported),
                                              );
                                            },
                                          )
                                        : Image.network(
                                            productoLocalizado.imagen,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) {
                                              return Center(
                                                child: Icon(Icons.image_not_supported),
                                              );
                                            },
                                          ))
                                    : Center(
                                        child: Icon(Icons.image),
                                      ),
                              ),
                              SizedBox(height: 12),
                              // Nombre
                              Text(
                                productoLocalizado.nombre,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              // Artista solo para eventos que no sean Rocanrola (id != '2')
                              if (productoLocalizado.id != '2')
                                Text(
                                  '${localization.artist}: ${productoLocalizado.artista}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.blue[700],
                                  ),
                                ),
                              // Fecha y Lugar
                              Text(
                                '${localization.date}: ${productoLocalizado.fecha} - ${localization.place}: ${productoLocalizado.lugar}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              // Tipo
                              Text(
                                '${localization.type}: ${productoLocalizado.tipo}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              // Descripción
                              Text(
                                productoLocalizado.descripcion,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton.icon(
                                  onPressed: () {
                                    widget.onEventoSeleccionado?.call(producto);
                                  },
                                  icon: const Icon(Icons.info_outline),
                                  label: Text(localization.translate('view_information')),
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Stock y Precio
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                  Text(
                                    '${localization.stock}: ${producto.stock}',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    '€${producto.precio.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),
                              // Selector de cantidad y botón comprar
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Row(
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.remove),
                                          onPressed: () {
                                            setState(() {
                                              if (cantidad > 0) {
                                                cantidadesSeleccionadas[producto.id] = cantidad - 1;
                                              }
                                            });
                                          },
                                          constraints: BoxConstraints(minWidth: 30),
                                          padding: EdgeInsets.zero,
                                        ),
                                        Text(
                                          cantidad.toString(),
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.add),
                                          onPressed: () {
                                            setState(() {
                                              if (cantidad < producto.stock) {
                                                cantidadesSeleccionadas[producto.id] = cantidad + 1;
                                              }
                                            });
                                          },
                                          constraints: BoxConstraints(minWidth: 30),
                                          padding: EdgeInsets.zero,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            // Botón de compra final
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey[300]!)),
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _comprar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    localization.buy,
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
