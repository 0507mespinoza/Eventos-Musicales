import 'package:flutter/material.dart';
import 'package:michaelespinozac1/model/pedido.dart';
import 'package:michaelespinozac1/screens/PaginaPerfil.dart';
import 'package:michaelespinozac1/services/servicio_autentificacion.dart';
import 'package:michaelespinozac1/screens/PaginaSecundaria.dart';
import 'package:michaelespinozac1/services/sevicios_pedidos.dart';

class PaginaPedidos extends StatefulWidget {
  const PaginaPedidos({super.key});

  @override
  State<PaginaPedidos> createState() => _PaginaPedidosState();
}

class _PaginaPedidosState extends State<PaginaPedidos> {
  final ServicioPedidos _servicioPedidos = ServicioPedidos.instance;
  final ServicioAutenticacion _servicioAuth = ServicioAutenticacion();
  List<Pedido> _pedidos = [];
  bool _mostrarTodosLosPedidos = false;

  @override
  void initState() {
    super.initState();
    _cargarPedidos();
    // Escuchar cambios en ServicioPedidos
    _servicioPedidos.addListener(_cargarPedidos);
  }

  @override
  void dispose() {
    _servicioPedidos.removeListener(_cargarPedidos);
    super.dispose();
  }

  void _cargarPedidos() {
    final usuarioActual = _servicioAuth.usuarioActual;
    if (usuarioActual != null) {
      setState(() {
        if (_mostrarTodosLosPedidos && _servicioAuth.esAdministradorActual) {
          // Admin ve todos los pedidos
          _pedidos = _servicioPedidos.obtenerTodosLosPedidos();
        } else {
          // Usuario normal ve solo sus pedidos
          _pedidos = _servicioPedidos.obtenerPedidosPorUsuario(usuarioActual.id);
        }
      });
    }
  }

  void _alternarVista() {
    setState(() {
      _mostrarTodosLosPedidos = !_mostrarTodosLosPedidos;
    });
    _cargarPedidos();
  }

  Color _obtenerColorEstado(String estado) {
    switch (estado) {
      case 'Reservada':
        return Colors.orange;
      case 'Pagada':
        return Colors.blue;
      case 'Asistida':
        return Colors.green;
      case 'Cancelada':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _obtenerTextoEstado(String estado) {
    switch (estado) {
      case 'Reservada':
        return 'Reservada';
      case 'Pagada':
        return 'Pagada';
      case 'Asistida':
        return 'Asistida';
      case 'Cancelada':
        return 'Cancelada';
      default:
        return estado;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_mostrarTodosLosPedidos ? 'Todos los Pedidos' : 'Mis Pedidos'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          if (_servicioAuth.esAdministradorActual)
            IconButton(
              onPressed: _alternarVista,
              icon: Icon(_mostrarTodosLosPedidos ? Icons.person : Icons.people),
              tooltip: _mostrarTodosLosPedidos ? 'Ver mis pedidos' : 'Ver todos los pedidos',
            ),
        ],
      ),
      body: Column(
        children: [
          // Información de resumen
          if (_pedidos.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.blue[50],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _estadisticaItem(Icons.shopping_bag, 'Total', _pedidos.length.toString()),
                  _estadisticaItem(Icons.pending_actions, 'Reservadas', 
                    _pedidos.where((p) => p.estado == 'Reservada').length.toString()),
                  _estadisticaItem(Icons.check_circle, 'Asistidas', 
                    _pedidos.where((p) => p.estado == 'Asistida').length.toString()),
                ],
              ),
            ),

          // Lista de pedidos
          Expanded(
            child: _pedidos.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_bag_outlined, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'No hay pedidos realizados',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _pedidos.length,
                    itemBuilder: (context, index) {
                      final pedido = _pedidos[index];
                      return _buildPedidoCard(pedido);
                    },
                  ),
          ),
        ],
      ),
      
      // FOOTER CON BOTONES DE NAVEGACIÓN
      bottomNavigationBar: _buildFooter(context),
    );
  }

  Widget _estadisticaItem(IconData icon, String titulo, String valor) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue, size: 24),
        const SizedBox(height: 4),
        Text(titulo, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Text(valor, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildPedidoCard(Pedido pedido) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pedido #${pedido.id.substring(0, 8)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (_mostrarTodosLosPedidos)
                        Text(
                          'Cliente: ${pedido.nombreUsuario}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _obtenerColorEstado(pedido.estado),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _obtenerTextoEstado(pedido.estado),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Fecha: ${_formatearFecha(pedido.fecha)}',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 12),
            const Text(
              'Productos:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            ...pedido.items.map((item) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text(
                  '• ${item.nombreProducto} - €${item.precio.toStringAsFixed(2)} x ${item.cantidad}',
                ),
              );
            }),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '€${pedido.total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            
            // Botones de acción para admin
            if (_servicioAuth.esAdministradorActual && _mostrarTodosLosPedidos)
              const SizedBox(height: 12),
            if (_servicioAuth.esAdministradorActual && _mostrarTodosLosPedidos)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _cambiarEstadoPedido(pedido.id, 'confirmado'),
                      child: const Text('Confirmar'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _cambiarEstadoPedido(pedido.id, 'entregado'),
                      child: const Text('Entregado'),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  void _cambiarEstadoPedido(String pedidoId, String nuevoEstado) {
    _servicioPedidos.actualizarEstadoPedido(pedidoId, nuevoEstado);
    _cargarPedidos();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Pedido actualizado a: $nuevoEstado'),
        backgroundColor: Colors.green,
      ),
    );
  }

  String _formatearFecha(DateTime fecha) {
    return '${fecha.day}/${fecha.month}/${fecha.year} ${fecha.hour}:${fecha.minute.toString().padLeft(2, '0')}';
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
            offset: Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Botón HOME
          _footerButton(
            icon: Icons.home,
            label: 'Home',
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => PaginaSecundaria()),
                (route) => false,
              );
            },
          ),
          
          // Botón PEDIDOS (activo)
          _footerButton(
            icon: Icons.shopping_bag,
            label: 'Pedidos',
            onPressed: () {
              // Ya estamos en pedidos, no hacer nada
            },
            isActive: true,
          ),
          
          // Botón PERFIL
          _footerButton(
            icon: Icons.person,
            label: 'Yo',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PaginaPerfil()),
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
}