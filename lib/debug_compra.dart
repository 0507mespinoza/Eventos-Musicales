// Archivo de diagnóstico para verificar el flujo de compra
// Este archivo es solo para testing

import 'package:michaelespinozac1/services/logica_productos.dart';
import 'package:michaelespinozac1/services/sevicios_pedidos.dart';
import 'package:michaelespinozac1/services/servicio_autentificacion.dart';
import 'package:michaelespinozac1/model/pedido.dart';

void testFlujoDeLaCompra() {
  print('\n=== TEST: FLUJO DE COMPRA ===\n');
  
  // 1. Obtener servicios
  final logicaProductos = LogicaProductos.instance;
  final servicioPedidos = ServicioPedidos.instance;
  final servicioAuth = ServicioAutenticacion();
  
  // 2. Productos disponibles
  print('✓ Productos disponibles:');
  final productos = logicaProductos.getProductos();
  for (var p in productos) {
    print('  - ${p.nombre}: stock=${p.stock}, precio=${p.precio}');
  }
  
  // 3. Loguear usuario
  print('\n✓ Intentando login con usuario predefinido...');
  final loginOk = servicioAuth.iniciarSesion('Michael', 'Michael');
  print('  Login OK: $loginOk');
  
  final usuario = servicioAuth.usuarioActual;
  print('  Usuario: ${usuario?.nombre} (ID: ${usuario?.id})');
  
  if (usuario == null) {
    print('❌ Error: Usuario no logueado');
    return;
  }
  
  // 4. Simular compra de primer producto
  print('\n✓ Simulando compra de primer evento...');
  if (productos.isNotEmpty) {
    final producto = productos[0];
    final cantidadAComprar = 5;
    
    print('  Comprando: ${producto.nombre}');
    print('  Cantidad: $cantidadAComprar');
    print('  Stock antes: ${producto.stock}');
    
    // Descontar stock
    logicaProductos.actualizarStock(producto.id, cantidadAComprar);
    
    final productoActualizado = logicaProductos.obtenerProducto(producto.id);
    print('  Stock después: ${productoActualizado?.stock}');
    
    // Crear pedido
    final pedido = Pedido(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      numeroReserva: servicioPedidos.generarNumeroReserva(),
      usuarioId: usuario.id,
      nombreUsuario: usuario.nombre,
      items: [
        ItemPedido(
          productoId: producto.id,
          nombreProducto: producto.nombre,
          cantidad: cantidadAComprar,
          precio: producto.precio,
        ),
      ],
      total: producto.precio * cantidadAComprar,
      fecha: DateTime.now(),
      estado: 'Reservada',
    );
    
    servicioPedidos.crearPedido(pedido);
    print('  Pedido creado: #${pedido.numeroReserva}');
  }
  
  // 5. Verificar pedidos del usuario
  print('\n✓ Pedidos del usuario:');
  final pedidosDelUsuario = servicioPedidos.obtenerPedidosPorUsuario(usuario.id);
  print('  Total de pedidos: ${pedidosDelUsuario.length}');
  for (var ped in pedidosDelUsuario) {
    print('  - Reserva #${ped.numeroReserva}: ${ped.estado} (Total: €${ped.total})');
    for (var item in ped.items) {
      print('    * ${item.nombreProducto} x${item.cantidad} @ €${item.precio}');
    }
  }
  
  // 6. Resumen
  print('\n✓ Stock después de la compra:');
  final productosActualizados = logicaProductos.getProductos();
  for (var p in productosActualizados) {
    print('  - ${p.nombre}: stock=${p.stock}');
  }
  
  print('\n=== FIN DEL TEST ===\n');
}
