// widgets/productos.dart
import 'package:flutter/material.dart';
import '../services/logica_productos.dart';
import 'tarjeta_producto.dart';

class ProductosWidget extends StatelessWidget {
  final Function(String, int) onCantidadCambiada;

  const ProductosWidget({super.key, required this.onCantidadCambiada});

  @override
  Widget build(BuildContext context) {
    final productos = LogicaProductos.instance.obtenerProductos();

    return ListView.builder(
      itemCount: productos.length,
      itemBuilder: (context, index) {
        final producto = productos[index];
        
        return TarjetaProducto(
          producto: producto,
          onCantidadCambiada: onCantidadCambiada,
        );
      },
    );
  }
}