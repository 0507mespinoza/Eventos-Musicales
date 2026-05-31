// widgets/tarjeta_producto.dart
import 'package:flutter/material.dart';
import 'package:michaelespinozac1/model/productos.dart';
import 'package:michaelespinozac1/services/sevicios_pedidos.dart';


class TarjetaProducto extends StatefulWidget {
  final EntradaConcierto producto;
  final Function(String, int) onCantidadCambiada;

  const TarjetaProducto({
    super.key,
    required this.producto,
    required this.onCantidadCambiada,
  });

  @override
  State<TarjetaProducto> createState() => _TarjetaProductoState();
}

class _TarjetaProductoState extends State<TarjetaProducto> {
  final ServicioPedidos _servicioPedidos = ServicioPedidos();
  int _cantidad = 0;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Encabezado con icono y nombre
            _buildEncabezadoProducto(),
            const SizedBox(height: 12),

            // Descripción del producto
            _buildDescripcionProducto(),
            const SizedBox(height: 12),

            // Precio y stock
            _buildPrecioYStock(),
            const SizedBox(height: 16),

            // Selector de cantidad
            _buildSelectorCantidad(),

            // Botón de agregar al carrito
            if (_cantidad > 0) _buildBotonAgregarCarrito(),

            // Mensajes informativos
            if (widget.producto.stock < 5 && widget.producto.stock > 0) 
              _buildMensajeStockBajo(),
            if (widget.producto.stock == 0) 
              _buildMensajeAgotado(),
          ],
        ),
      ),
    );
  }

  Widget _buildEncabezadoProducto() {
    // Mapeo de iconos por tipo de entrada
    final iconMap = {
      'concierto': Icons.music_note,
      'festival': Icons.festival,
      'album': Icons.album,
    };

    final icon = iconMap[widget.producto.tipo] ?? Icons.music_note;
    final colors = [Colors.blue, Colors.green, Colors.orange, Colors.purple, Colors.red];
    final colorIndex = int.tryParse(widget.producto.id) ?? 0 % colors.length;

    return Row(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: colors[colorIndex].withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colors[colorIndex].withOpacity(0.3)),
          ),
          child: Icon(
            icon,
            size: 30,
            color: colors[colorIndex],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.producto.nombre,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                widget.producto.artista,
                style: TextStyle(
                  fontSize: 14,
                  color: colors[colorIndex],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDescripcionProducto() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Fecha y lugar
        if (widget.producto.tipo != 'album')
          Text(
            '${widget.producto.fecha} • ${widget.producto.lugar}',
            style: TextStyle(
              color: Colors.blue[700],
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        // Descripción
        Text(
          widget.producto.descripcion,
          style: TextStyle(
            color: Colors.grey[600],
            height: 1.4,
            fontSize: 14,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildPrecioYStock() {
    return Row(
      children: [
        // Precio
        Text(
          '€${widget.producto.precio.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.green[700],
          ),
        ),
        const Spacer(),
        
        // Stock
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: widget.producto.stock > 0 ? Colors.green[50] : Colors.red[50],
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: widget.producto.stock > 0 ? Colors.green[100]! : Colors.red[100]!,
            ),
          ),
          child: Text(
            'Stock: ${widget.producto.stock}',
            style: TextStyle(
              color: widget.producto.stock > 0 ? Colors.green[700] : Colors.red[700],
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectorCantidad() {
    return Row(
      children: [
        const Text(
          'Cantidad:',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        const Spacer(),
        
        // Botón disminuir
        IconButton(
          icon: Icon(Icons.remove_circle_outline, color: Colors.blue),
          onPressed: _cantidad > 0
              ? () {
                  setState(() {
                    _cantidad--;
                  });
                  widget.onCantidadCambiada(widget.producto.id, _cantidad);
                }
              : null,
        ),
        
        // Cantidad actual
        Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            _cantidad.toString(),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ),
        
        // Botón aumentar
        IconButton(
          icon: Icon(Icons.add_circle_outline, color: Colors.blue),
          onPressed: _cantidad < widget.producto.stock
              ? () {
                  setState(() {
                    _cantidad++;
                  });
                  widget.onCantidadCambiada(widget.producto.id, _cantidad);
                }
              : null,
        ),
      ],
    );
  }

  Widget _buildBotonAgregarCarrito() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 12),
      child: ElevatedButton.icon(
        onPressed: () {
          _servicioPedidos.agregarAlCarrito(widget.producto.id, _cantidad);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$_cantidad ${widget.producto.nombre} agregado al carrito'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
          
          // Resetear cantidad después de agregar
          setState(() {
            _cantidad = 0;
          });
          widget.onCantidadCambiada(widget.producto.id, 0);
        },
        icon: const Icon(Icons.shopping_cart, size: 20),
        label: const Text(
          'Agregar al Carrito',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Widget _buildMensajeStockBajo() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.orange[100]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.warning_amber, size: 16, color: Colors.orange[700]),
          const SizedBox(width: 8),
          Text(
            '¡Últimas unidades!',
            style: TextStyle(
              color: Colors.orange[700],
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMensajeAgotado() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.red[100]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, size: 16, color: Colors.red[700]),
          const SizedBox(width: 8),
          const Text(
            'Producto agotado',
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}