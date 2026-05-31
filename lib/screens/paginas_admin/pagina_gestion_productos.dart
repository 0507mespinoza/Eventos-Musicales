import 'package:flutter/material.dart';
import 'package:michaelespinozac1/services/logica_productos.dart';
import 'package:michaelespinozac1/l10n/app_localizations.dart';
import 'package:michaelespinozac1/model/productos.dart';

class PaginaGestionEventos extends StatefulWidget {
  const PaginaGestionEventos({super.key});

  @override
  State<PaginaGestionEventos> createState() => _PaginaGestionEventosState();
}

class _PaginaGestionEventosState extends State<PaginaGestionEventos> {
  List<dynamic> _productos = [];

  @override
  void initState() {
    super.initState();
    _cargarProductos();
  }

  void _cargarProductos() {
    setState(() {
      _productos = LogicaProductos.instance.obtenerProductos();
    });
  }

  void _mostrarDialogoEditar(dynamic producto) {
    final nombreController = TextEditingController(text: producto.nombre);
    final descripcionController = TextEditingController(text: producto.descripcion);
    final precioController = TextEditingController(text: producto.precio.toString());
    final imagenController = TextEditingController(text: producto.imagen ?? '');
    final artistaController = TextEditingController(text: producto.artista ?? '');
    final fechaController = TextEditingController(text: producto.fecha ?? '');
    final lugarController = TextEditingController(text: producto.lugar ?? '');
    final tipoController = TextEditingController(text: producto.tipo ?? 'concierto');
    final stockController = TextEditingController(text: producto.stock.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context).edit),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nombreController,
                decoration: InputDecoration(labelText: 'Nombre del evento'),
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
              TextField(
                controller: tipoController,
                decoration: InputDecoration(labelText: 'Tipo (concierto/festival/album)'),
              ),
              TextField(
                controller: descripcionController,
                decoration: InputDecoration(labelText: 'Descripción'),
                maxLines: 3,
              ),
              TextField(
                controller: precioController,
                decoration: InputDecoration(labelText: 'Precio'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: stockController,
                decoration: InputDecoration(labelText: 'Stock'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: imagenController,
                decoration: InputDecoration(labelText: 'URL de imagen'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context).cancel),
          ),
          ElevatedButton(
            onPressed: () {
              final productoActualizado = EntradaConcierto(
                id: producto.id,
                nombre: nombreController.text,
                descripcion: descripcionController.text,
                precio: double.tryParse(precioController.text) ?? producto.precio,
                stock: int.tryParse(stockController.text) ?? producto.stock,
                imagen: imagenController.text.isEmpty ? producto.imagen : imagenController.text,
                artista: artistaController.text,
                fecha: fechaController.text,
                lugar: lugarController.text,
                tipo: tipoController.text,
                estaActivo: producto.estaActivo,
              );
              LogicaProductos.instance.actualizarProducto(productoActualizado);
              _cargarProductos();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Entrada actualizada')),
              );
            },
            child: Text(AppLocalizations.of(context).confirm),
          ),
        ],
      ),
    );
  }

  void _mostrarDialogoEliminar(dynamic producto) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context).delete),
        content: Text('¿Eliminar producto ${producto.nombre}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context).cancel),
          ),
          ElevatedButton(
            onPressed: () {
              LogicaProductos.instance.eliminarProducto(producto.id);
              _cargarProductos();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Producto eliminado')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(AppLocalizations.of(context).delete),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);

    return Scaffold(
      body: _productos.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No hay eventos',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: _productos.length,
              itemBuilder: (context, index) {
                final producto = _productos[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: producto.imagen != null && producto.imagen.isNotEmpty
                        ? CircleAvatar(
                            backgroundImage: NetworkImage(producto.imagen),
                            onBackgroundImageError: (_, __) => Icon(Icons.inventory),
                          )
                        : CircleAvatar(
                            backgroundColor: Colors.blue,
                            child: Icon(Icons.inventory, color: Colors.white),
                          ),
                    title: Text(
                      producto.nombre,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Artista: ${producto.artista}'),
                        Text('Fecha: ${producto.fecha} - Lugar: ${producto.lugar}'),
                        Text('Tipo: ${producto.tipo} - Precio: €${producto.precio.toStringAsFixed(2)}'),
                        if (producto.descripcion.isNotEmpty)
                          Text(
                            producto.descripcion,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        switch (value) {
                          case 'edit':
                            _mostrarDialogoEditar(producto);
                            break;
                          case 'delete':
                            _mostrarDialogoEliminar(producto);
                            break;
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'edit',
                          child: ListTile(
                            leading: Icon(Icons.edit),
                            title: Text(localization.edit),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: ListTile(
                            leading: Icon(Icons.delete, color: Colors.red),
                            title: Text(localization.delete, style: TextStyle(color: Colors.red)),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _mostrarDialogoCrearProducto(),
        backgroundColor: Colors.red,
        child: Icon(Icons.add),
      ),
    );
  }

  void _mostrarDialogoCrearProducto() {
    final nombreController = TextEditingController();
    final descripcionController = TextEditingController();
    final precioController = TextEditingController();
    final imagenController = TextEditingController();
    final artistaController = TextEditingController();
    final fechaController = TextEditingController();
    final lugarController = TextEditingController();
    final tipoController = TextEditingController(text: 'concierto');
    final stockController = TextEditingController(text: '100');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context).add),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nombreController,
                decoration: InputDecoration(labelText: 'Nombre del evento'),
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
              TextField(
                controller: tipoController,
                decoration: InputDecoration(labelText: 'Tipo (concierto/festival/album)'),
              ),
              TextField(
                controller: descripcionController,
                decoration: InputDecoration(labelText: 'Descripción'),
                maxLines: 3,
              ),
              TextField(
                controller: precioController,
                decoration: InputDecoration(labelText: 'Precio'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: stockController,
                decoration: InputDecoration(labelText: 'Stock'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: imagenController,
                decoration: InputDecoration(labelText: 'URL de imagen (opcional)'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context).cancel),
          ),
          ElevatedButton(
            onPressed: () {
              final nuevoProducto = EntradaConcierto(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                nombre: nombreController.text,
                descripcion: descripcionController.text,
                precio: double.tryParse(precioController.text) ?? 0.0,
                stock: int.tryParse(stockController.text) ?? 0,
                imagen: imagenController.text.isEmpty ? '' : imagenController.text,
                artista: artistaController.text,
                fecha: fechaController.text,
                lugar: lugarController.text,
                tipo: tipoController.text,
                estaActivo: true,
              );
              LogicaProductos.instance.agregarProducto(nuevoProducto);
              _cargarProductos();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Entrada creada')),
              );
            },
            child: Text(AppLocalizations.of(context).create),
          ),
        ],
      ),
    );
  }
}