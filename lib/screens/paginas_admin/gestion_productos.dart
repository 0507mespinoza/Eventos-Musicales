import 'package:flutter/material.dart';
import 'package:michaelespinozac1/model/productos.dart';
import 'package:michaelespinozac1/services/logica_productos.dart';
import 'package:michaelespinozac1/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class GestionProductos extends StatefulWidget {
  const GestionProductos({super.key});

  @override
  State<GestionProductos> createState() => _GestionProductosState();
}

class _GestionProductosState extends State<GestionProductos> {
  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);

    return Consumer<LogicaProductos>(
      builder: (context, logicaProductos, child) {
        final productos = logicaProductos.getAllProductos();

        return Scaffold(
      appBar: AppBar(
        title: Text(localization.productManagement),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(8.0),
        itemCount: productos.length,
        itemBuilder: (context, index) {
          final producto = productos[index];

          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              leading: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: producto.imagen.isNotEmpty
                    ? Image.network(
                        producto.imagen,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.image_not_supported);
                        },
                      )
                    : Icon(Icons.image),
              ),
              title: Text(producto.nombre),
              subtitle: Text(
                '€${producto.precio.toStringAsFixed(2)} - ${localization.stock}: ${producto.stock}',
              ),
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') {
                    _editarProducto(context, producto);
                  } else if (value == 'stock') {
                    _modificarStock(context, producto);
                  } else if (value == 'delete') {
                    _eliminarProducto(producto.id);
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: 'edit',
                    child: Text(localization.edit),
                  ),
                  PopupMenuItem<String>(
                    value: 'stock',
                    child: Text('Modificar Stock'),
                  ),
                  PopupMenuItem<String>(
                    value: 'delete',
                    child: Text(localization.delete),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _crearProducto(context),
        backgroundColor: Colors.blue,
        child: Icon(Icons.add),
      ),
        );
      },
    );
  }

  void _editarProducto(BuildContext context, EntradaConcierto producto) {
    final nombreController = TextEditingController(text: producto.nombre);
    final descripcionController = TextEditingController(text: producto.descripcion);
    final precioController = TextEditingController(text: producto.precio.toString());
    final stockController = TextEditingController(text: producto.stock.toString());
    final imagenController = TextEditingController(text: producto.imagen);
    final artistaController = TextEditingController(text: producto.artista);
    final fechaController = TextEditingController(text: producto.fecha);
    final lugarController = TextEditingController(text: producto.lugar);
    String tipoSeleccionado = producto.tipo;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editar Evento'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nombreController,
                  decoration: InputDecoration(labelText: 'Nombre del Evento'),
                ),
                TextField(
                  controller: descripcionController,
                  decoration: InputDecoration(labelText: 'Descripción'),
                  maxLines: 3,
                ),
                TextField(
                  controller: artistaController,
                  decoration: InputDecoration(labelText: 'Artista'),
                ),
                TextField(
                  controller: fechaController,
                  decoration: InputDecoration(labelText: 'Fecha (YYYY-MM-DD)'),
                ),
                TextField(
                  controller: lugarController,
                  decoration: InputDecoration(labelText: 'Lugar'),
                ),
                DropdownButtonFormField<String>(
                  value: tipoSeleccionado,
                  decoration: InputDecoration(labelText: 'Tipo'),
                  items: ['concierto', 'festival', 'album'].map((tipo) => DropdownMenuItem(
                    value: tipo,
                    child: Text(tipo),
                  )).toList(),
                  onChanged: (value) => tipoSeleccionado = value!,
                ),
                TextField(
                  controller: precioController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Precio'),
                ),
                TextField(
                  controller: stockController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Stock'),
                ),
                TextField(
                  controller: imagenController,
                  decoration: InputDecoration(labelText: 'URL de Imagen'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                final productoActualizado = EntradaConcierto(
                  id: producto.id,
                  nombre: nombreController.text,
                  descripcion: descripcionController.text,
                  precio: double.tryParse(precioController.text) ?? producto.precio,
                  stock: int.tryParse(stockController.text) ?? producto.stock,
                  imagen: imagenController.text,
                  estaActivo: producto.estaActivo,
                  artista: artistaController.text,
                  fecha: fechaController.text,
                  lugar: lugarController.text,
                  tipo: tipoSeleccionado,
                );

                LogicaProductos.instance.actualizarProducto(productoActualizado);
                Navigator.pop(context);
                setState(() {});
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  void _eliminarProducto(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar Evento'),
          content: const Text('¿Estás seguro de que deseas eliminar este evento?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                LogicaProductos.instance.eliminarProducto(id);
                Navigator.pop(context);
                setState(() {});
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  void _modificarStock(BuildContext context, EntradaConcierto producto) {
    final stockController = TextEditingController(text: producto.stock.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Modificar Stock - ${producto.nombre}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Stock actual: ${producto.stock}'),
              SizedBox(height: 16),
              TextField(
                controller: stockController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Nuevo Stock',
                  hintText: 'Ingrese la cantidad',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                final nuevoStock = int.tryParse(stockController.text) ?? producto.stock;
                LogicaProductos.instance.setStock(producto.id, nuevoStock);
                Navigator.pop(context);
                setState(() {});
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Stock actualizado a $nuevoStock')),
                );
              },
              child: const Text('Actualizar'),
            ),
          ],
        );
      },
    );
  }

  void _crearProducto(BuildContext context) {
    final nombreController = TextEditingController();
    final descripcionController = TextEditingController();
    final precioController = TextEditingController();
    final stockController = TextEditingController();
    final imagenController = TextEditingController();
    final artistaController = TextEditingController();
    final fechaController = TextEditingController();
    final lugarController = TextEditingController();
    String tipoSeleccionado = 'concierto';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Crear Evento'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nombreController,
                  decoration: InputDecoration(labelText: 'Nombre del Evento'),
                ),
                TextField(
                  controller: descripcionController,
                  decoration: InputDecoration(labelText: 'Descripción'),
                  maxLines: 3,
                ),
                TextField(
                  controller: artistaController,
                  decoration: InputDecoration(labelText: 'Artista'),
                ),
                TextField(
                  controller: fechaController,
                  decoration: InputDecoration(labelText: 'Fecha (YYYY-MM-DD)'),
                ),
                TextField(
                  controller: lugarController,
                  decoration: InputDecoration(labelText: 'Lugar'),
                ),
                DropdownButtonFormField<String>(
                  value: tipoSeleccionado,
                  decoration: InputDecoration(labelText: 'Tipo'),
                  items: ['concierto', 'festival', 'album'].map((tipo) => DropdownMenuItem(
                    value: tipo,
                    child: Text(tipo),
                  )).toList(),
                  onChanged: (value) => tipoSeleccionado = value!,
                ),
                TextField(
                  controller: precioController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(labelText: 'Precio'),
                ),
                TextField(
                  controller: stockController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Stock'),
                ),
                TextField(
                  controller: imagenController,
                  decoration: InputDecoration(labelText: 'URL de Imagen'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                final nuevoProducto = EntradaConcierto(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  nombre: nombreController.text,
                  descripcion: descripcionController.text,
                  precio: double.tryParse(precioController.text) ?? 0.0,
                  stock: int.tryParse(stockController.text) ?? 0,
                  imagen: imagenController.text,
                  artista: artistaController.text,
                  fecha: fechaController.text,
                  lugar: lugarController.text,
                  tipo: tipoSeleccionado,
                );

                LogicaProductos.instance.agregarProducto(nuevoProducto);
                Navigator.pop(context);
                setState(() {});
              },
              child: const Text('Crear'),
            ),
          ],
        );
      },
    );
  }
}
