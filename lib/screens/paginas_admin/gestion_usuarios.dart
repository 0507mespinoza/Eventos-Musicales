import 'package:flutter/material.dart';
import 'package:michaelespinozac1/services/LogicaUsuario.dart';
import 'package:michaelespinozac1/model/usuario.dart';
import 'package:michaelespinozac1/l10n/app_localizations.dart';

class GestionUsuarios extends StatefulWidget {
  const GestionUsuarios({super.key});

  @override
  State<GestionUsuarios> createState() => _GestionUsuariosState();
}

class _GestionUsuariosState extends State<GestionUsuarios> {
  @override
  Widget build(BuildContext context) {
    final usuarios = LogicaUsuarios.obtenerUsuariosParaGestion();
    final localization = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localization.userManagement),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(8.0),
        itemCount: usuarios.length,
        itemBuilder: (context, index) {
          final usuario = usuarios[index];

          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue,
                child: Text(
                  usuario.nombre[0].toUpperCase(),
                  style: TextStyle(color: Colors.white),
                ),
              ),
              title: Text(usuario.nombre),
              subtitle: Text('${localization.email}: ${usuario.lugarNacimiento}'),
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') {
                    _editarUsuario(context, usuario);
                  } else if (value == 'delete') {
                    _eliminarUsuario(usuario.id);
                  } else if (value == 'block') {
                    if (usuario.estaBloqueado) {
                      LogicaUsuarios.desbloquearUsuario(usuario.id);
                    } else {
                      LogicaUsuarios.bloquearUsuario(usuario.id);
                    }
                    setState(() {});
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: 'edit',
                    child: Text(localization.edit),
                  ),
                  PopupMenuItem<String>(
                    value: 'delete',
                    child: Text(localization.delete),
                  ),
                  PopupMenuItem<String>(
                    value: 'block',
                    child: Text(
                      usuario.estaBloqueado ? localization.unblock : localization.block,
                    ),
                  ),
                ],
              ),
              isThreeLine: usuario.estaBloqueado,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _crearUsuario(context),
        backgroundColor: Colors.blue,
        child: Icon(Icons.add),
      ),
    );
  }

  void _editarUsuario(BuildContext context, Usuario usuario) {
    final nombreController = TextEditingController(text: usuario.nombre);
    final contraseniaController = TextEditingController(text: usuario.contrasena);
    final edadController = TextEditingController(text: usuario.edad.toString());
    final lugarController = TextEditingController(text: usuario.lugarNacimiento);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editar Usuario'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nombreController,
                  decoration: InputDecoration(labelText: 'Nombre'),
                ),
                TextField(
                  controller: contraseniaController,
                  decoration: InputDecoration(labelText: 'Contraseña'),
                ),
                TextField(
                  controller: edadController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Edad'),
                ),
                TextField(
                  controller: lugarController,
                  decoration: InputDecoration(labelText: 'Lugar de Nacimiento'),
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
                LogicaUsuarios.editarUsuario(
                  usuario.id,
                  nombreController.text,
                  contraseniaController.text,
                  int.tryParse(edadController.text) ?? usuario.edad,
                  lugarController.text,
                  usuario.trato,
                  usuario.imagen,
                );
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

  void _eliminarUsuario(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar Usuario'),
          content: const Text('¿Estás seguro de que deseas eliminar este usuario?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                LogicaUsuarios.eliminarUsuario(id);
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

  void _crearUsuario(BuildContext context) {
    final nombreController = TextEditingController();
    final contraseniaController = TextEditingController();
    final edadController = TextEditingController();
    final lugarController = TextEditingController();
    String tipoUsuario = 'cliente';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Crear Usuario'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nombreController,
                      decoration: InputDecoration(labelText: 'Nombre'),
                    ),
                    TextField(
                      controller: contraseniaController,
                      decoration: InputDecoration(labelText: 'Contraseña'),
                    ),
                    TextField(
                      controller: edadController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Edad'),
                    ),
                    TextField(
                      controller: lugarController,
                      decoration: InputDecoration(labelText: 'Lugar de Nacimiento'),
                    ),
                    SizedBox(height: 12),
                    DropdownButton<String>(
                      value: tipoUsuario,
                      onChanged: (value) {
                        setState(() {
                          tipoUsuario = value ?? 'cliente';
                        });
                      },
                      items: ['cliente', 'admin']
                          .map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          })
                          .toList(),
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
                    if (tipoUsuario == 'admin') {
                      LogicaUsuarios.crearUsuarioAdmin(
                        nombreController.text,
                        contraseniaController.text,
                        int.tryParse(edadController.text) ?? 0,
                        lugarController.text,
                        'Sr.',
                        '',
                      );
                    } else {
                      LogicaUsuarios.crearUsuarioCliente(
                        nombreController.text,
                        contraseniaController.text,
                        int.tryParse(edadController.text) ?? 0,
                        lugarController.text,
                        'Sr.',
                        '',
                      );
                    }
                    Navigator.pop(context);
                    setState(() {});
                  },
                  child: const Text('Crear'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
