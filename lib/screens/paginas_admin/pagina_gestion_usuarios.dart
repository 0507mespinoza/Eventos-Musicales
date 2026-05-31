import 'package:flutter/material.dart';
import 'package:michaelespinozac1/model/usuario.dart';
import 'package:michaelespinozac1/l10n/app_localizations.dart';
import 'package:michaelespinozac1/services/servicio_autentificacion.dart';
import 'package:provider/provider.dart';
import 'package:michaelespinozac1/services/app_state.dart';

class PaginaGestionUsuarios extends StatefulWidget {
  const PaginaGestionUsuarios({super.key});

  @override
  State<PaginaGestionUsuarios> createState() => _PaginaGestionUsuariosState();
}

class _PaginaGestionUsuariosState extends State<PaginaGestionUsuarios> {
  final ServicioAutenticacion _servicioAuth = ServicioAutenticacion();
  List<Usuario> _usuarios = [];

  String? get _usuarioActualId => _servicioAuth.usuarioActual?.id;

  bool _esUsuarioProtegido(Usuario usuario) {
    final esPropio = usuario.id == _usuarioActualId;
    final esAdmin = usuario.esAdministrador || usuario.nombre.toLowerCase() == 'admin';
    return esPropio || esAdmin;
  }

  @override
  void initState() {
    super.initState();
    _cargarUsuarios();
  }

  void _cargarUsuarios() {
    setState(() {
      _usuarios = _servicioAuth.usuarios;
    });
  }

  void _mostrarDialogoEditar(Usuario usuario) {
    final localization = AppLocalizations.of(context);
    if (_esUsuarioProtegido(usuario)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(localization.cannotEditProtectedUser)),
      );
      return;
    }

    final nombreController = TextEditingController(text: usuario.nombre);
    final contrasenaController = TextEditingController(text: usuario.contrasena);
    final edadController = TextEditingController(text: usuario.edad.toString());
    final lugarController = TextEditingController(text: usuario.lugarNacimiento);
    final imagenController = TextEditingController(text: usuario.imagen);
    String tratoSeleccionado = usuario.trato;
    bool esAdmin = usuario.esAdministrador;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(AppLocalizations.of(context).edit),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nombreController,
                  decoration: InputDecoration(labelText: AppLocalizations.of(context).username),
                ),
                TextField(
                  controller: contrasenaController,
                  decoration: InputDecoration(labelText: AppLocalizations.of(context).password),
                  obscureText: true,
                ),
                TextField(
                  controller: edadController,
                  decoration: InputDecoration(labelText: AppLocalizations.of(context).age),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: lugarController,
                  decoration: InputDecoration(labelText: AppLocalizations.of(context).birthplace),
                ),
                TextField(
                  controller: imagenController,
                  decoration: InputDecoration(labelText: localization.imageUrlOrAsset),
                ),
                DropdownButtonFormField<String>(
                  initialValue: tratoSeleccionado,
                  decoration: InputDecoration(labelText: AppLocalizations.of(context).treatment),
                  items: [
                    DropdownMenuItem(
                      value: 'Sr.',
                      child: Text(localization.treatmentMr),
                    ),
                    DropdownMenuItem(
                      value: 'Sra.',
                      child: Text(localization.treatmentMrs),
                    ),
                  ],
                  onChanged: (value) => setState(() => tratoSeleccionado = value!),
                ),
                SwitchListTile(
                  title: Text(AppLocalizations.of(context).administrator),
                  value: esAdmin,
                  onChanged: (value) => setState(() => esAdmin = value),
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
                usuario.nombre = nombreController.text.trim();
                usuario.contrasena = contrasenaController.text.trim();
                usuario.edad = int.tryParse(edadController.text) ?? usuario.edad;
                usuario.lugarNacimiento = lugarController.text.trim();
                usuario.imagen = imagenController.text.trim();
                usuario.trato = tratoSeleccionado;
                // Actualizar esAdministrador si cambió
                if (esAdmin != usuario.esAdministrador) {
                  usuario.esAdministrador = esAdmin;
                }

                _servicioAuth.actualizarUsuario(usuario);
                _cargarUsuarios();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(localization.userUpdated)),
                );
              },
              child: Text(AppLocalizations.of(context).confirm),
            ),
          ],
        ),
      ),
    );
  }

  void _mostrarDialogoEliminar(Usuario usuario) {
    final localization = AppLocalizations.of(context);
    if (_esUsuarioProtegido(usuario)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(localization.cannotDeleteProtectedUser)),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context).delete),
        content: Text('${localization.deleteUserQuestion} ${usuario.nombre}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context).cancel),
          ),
          ElevatedButton(
            onPressed: () {
              _servicioAuth.eliminarUsuario(usuario.id);
              _cargarUsuarios();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(localization.userDeleted)),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(AppLocalizations.of(context).delete),
          ),
        ],
      ),
    );
  }

  void _cambiarEstadoBloqueo(Usuario usuario) {
    final localization = AppLocalizations.of(context);
    if (_esUsuarioProtegido(usuario)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(localization.cannotBlockProtectedUser)),
      );
      return;
    }

    if (usuario.estaBloqueado) {
      _servicioAuth.desbloquearUsuario(usuario.id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${usuario.nombre} ${localization.unblockedState.toLowerCase()}')),
      );
    } else {
      _servicioAuth.bloquearUsuario(usuario.id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${usuario.nombre} ${localization.blockedState.toLowerCase()}')),
      );
    }
    _cargarUsuarios();
  }

  @override
  Widget build(BuildContext context) {
    // Escuchar cambios de idioma
    Provider.of<AppState>(context);
    final localization = AppLocalizations.of(context);

    return Scaffold(
      body: _usuarios.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_outline, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    localization.noUsers,
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: _usuarios.length,
              itemBuilder: (context, index) {
                final usuario = _usuarios[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: usuario.estaBloqueado ? Colors.red : Colors.blue,
                      child: Icon(
                        usuario.esAdministrador ? Icons.admin_panel_settings : Icons.person,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      usuario.nombre,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: usuario.estaBloqueado ? Colors.red : Colors.black,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${localization.age}: ${usuario.edad}'),
                        Text('${localization.birthplace}: ${usuario.lugarNacimiento}'),
                        Text('${localization.role}: ${usuario.esAdministrador ? localization.administrator : localization.client}'),
                        if (_usuarioActualId == usuario.id)
                          Text(
                            localization.currentUser,
                            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                          ),
                        if (usuario.estaBloqueado)
                          Text(
                            localization.blockedState,
                            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                      ],
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        switch (value) {
                          case 'edit':
                            _mostrarDialogoEditar(usuario);
                            break;
                          case 'delete':
                            _mostrarDialogoEliminar(usuario);
                            break;
                          case 'block':
                            _cambiarEstadoBloqueo(usuario);
                            break;
                        }
                      },
                      itemBuilder: (context) => [
                        if (!_esUsuarioProtegido(usuario)) ...[
                          PopupMenuItem(
                            value: 'edit',
                            child: ListTile(
                              leading: Icon(Icons.edit),
                              title: Text(localization.edit),
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                          PopupMenuItem(
                            value: 'block',
                            child: ListTile(
                              leading: Icon(usuario.estaBloqueado ? Icons.lock_open : Icons.lock),
                              title: Text(usuario.estaBloqueado ? localization.unblock : localization.block),
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
                        ] else
                          PopupMenuItem(
                            enabled: false,
                            child: ListTile(
                              leading: Icon(Icons.lock, color: Colors.grey),
                              title: Text(localization.noActionsAvailable),
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
        onPressed: () => _mostrarDialogoCrearUsuario(),
        backgroundColor: Colors.red,
        child: Icon(Icons.add),
      ),
    );
  }

  void _mostrarDialogoCrearUsuario() {
    final localization = AppLocalizations.of(context);
    final nombreController = TextEditingController();
    final contrasenaController = TextEditingController();
    final edadController = TextEditingController();
    final lugarController = TextEditingController();
    final imagenController = TextEditingController();
    String tratoSeleccionado = 'Sr.';
    bool esAdmin = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(AppLocalizations.of(context).add),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nombreController,
                  decoration: InputDecoration(labelText: AppLocalizations.of(context).username),
                ),
                TextField(
                  controller: contrasenaController,
                  decoration: InputDecoration(labelText: AppLocalizations.of(context).password),
                  obscureText: true,
                ),
                TextField(
                  controller: edadController,
                  decoration: InputDecoration(labelText: AppLocalizations.of(context).age),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: lugarController,
                  decoration: InputDecoration(labelText: AppLocalizations.of(context).birthplace),
                ),
                TextField(
                  controller: imagenController,
                  decoration: InputDecoration(labelText: localization.imageUrlOrAsset),
                ),
                DropdownButtonFormField<String>(
                  initialValue: tratoSeleccionado,
                  decoration: InputDecoration(labelText: AppLocalizations.of(context).treatment),
                  items: [
                    DropdownMenuItem(
                      value: 'Sr.',
                      child: Text(localization.treatmentMr),
                    ),
                    DropdownMenuItem(
                      value: 'Sra.',
                      child: Text(localization.treatmentMrs),
                    ),
                  ],
                  onChanged: (value) => setState(() => tratoSeleccionado = value!),
                ),
                SwitchListTile(
                  title: Text(AppLocalizations.of(context).administrator),
                  value: esAdmin,
                  onChanged: (value) => setState(() => esAdmin = value),
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
                if (esAdmin) {
                  _servicioAuth.registrarUsuario(
                    nombreController.text.trim(),
                    contrasenaController.text.trim(),
                    int.tryParse(edadController.text) ?? 18,
                    lugarController.text.trim(),
                    trato: tratoSeleccionado,
                    imagen: imagenController.text.trim(),
                    esAdministrador: true,
                  );
                } else {
                  _servicioAuth.registrarUsuario(
                    nombreController.text.trim(),
                    contrasenaController.text.trim(),
                    int.tryParse(edadController.text) ?? 18,
                    lugarController.text.trim(),
                    trato: tratoSeleccionado,
                    imagen: imagenController.text.trim(),
                  );
                }
                _cargarUsuarios();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(localization.userCreated)),
                );
              },
              child: Text(AppLocalizations.of(context).create),
            ),
          ],
        ),
      ),
    );
  }
}