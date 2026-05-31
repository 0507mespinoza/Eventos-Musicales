import 'package:flutter/material.dart';
import 'package:michaelespinozac1/l10n/app_localizations.dart';
import 'package:michaelespinozac1/services/servicio_autentificacion.dart';
import 'package:michaelespinozac1/model/usuario.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io' show File;
import 'package:flutter/foundation.dart' show kIsWeb;

class EditarPerfil extends StatefulWidget {
  const EditarPerfil({super.key});

  @override
  State<EditarPerfil> createState() => _EditarPerfilState();
}

class _EditarPerfilState extends State<EditarPerfil> {
  final ServicioAutenticacion _servicioAuth = ServicioAutenticacion();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _edadController = TextEditingController();
  final TextEditingController _lugarController = TextEditingController();
  final TextEditingController _contrasenaController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  XFile? _imagenPerfil;

  bool _cargando = false;

  @override
  void initState() {
    super.initState();
    _cargarDatosUsuario();
  }

  void _cargarDatosUsuario() {
    final usuario = _servicioAuth.usuarioActual;
    if (usuario != null) {
      _nombreController.text = usuario.nombre;
      _edadController.text = usuario.edad.toString();
      _lugarController.text = usuario.lugarNacimiento;
      if (usuario.imagen.isNotEmpty) {
        _imagenPerfil = XFile(usuario.imagen);
      }
    }
  }

  // Métodos para imagen
  Future<void> _seleccionarDeGaleria() async {
    try {
      final XFile? imagen = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 75,
      );
      if (imagen != null) {
        setState(() {
          _imagenPerfil = imagen;
        });
      }
    } catch (e) {
      _mostrarError('Error al seleccionar imagen: $e');
    }
  }

  Future<void> _tomarFoto() async {
    final status = await Permission.camera.request();
    if (!status.isGranted) {
      _mostrarError('Permiso de cámara denegado');
      return;
    }
    try {
      final XFile? foto = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 75,
      );
      if (foto != null) {
        setState(() {
          _imagenPerfil = foto;
        });
      }
    } catch (e) {
      _mostrarError('Error al tomar foto: $e');
    }
  }

  Widget _mostrarImagenPerfil() {
    if (_imagenPerfil == null) {
      return Icon(
        Icons.person,
        size: 80,
        color: Colors.grey[600],
      );
    }
    if (kIsWeb) {
      return Image.network(
        _imagenPerfil!.path,
        width: 100,
        height: 100,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Icon(Icons.person, size: 80, color: Colors.grey[600]);
        },
      );
    } else {
      return Image.file(
        File(_imagenPerfil!.path),
        width: 100,
        height: 100,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Icon(Icons.person, size: 80, color: Colors.grey[600]);
        },
      );
    }
  }

  void _eliminarImagen() {
    setState(() {
      _imagenPerfil = null;
    });
  }

  void _guardarCambios() async {
    final localization = AppLocalizations.of(context);
    final usuarioActual = _servicioAuth.usuarioActual;
    if (usuarioActual == null) return;

    final edad = int.tryParse(_edadController.text);
    if (edad == null || edad < 1 || edad > 120) {
      _mostrarError(localization.validAgeRange);
      return;
    }

    if (_nombreController.text.isEmpty) {
      _mostrarError(localization.emptyNameError);
      return;
    }

    setState(() {
      _cargando = true;
    });

    await Future.delayed(const Duration(milliseconds: 1000));


    final usuarioActualizado = Usuario(
      id: usuarioActual.id,
      nombre: _nombreController.text.trim(),
      contrasena: _contrasenaController.text.isNotEmpty
          ? _contrasenaController.text.trim()
          : usuarioActual.contrasena,
      edad: edad,
      lugarNacimiento: _lugarController.text.trim(),
      trato: usuarioActual.trato,
      imagen: _imagenPerfil?.path ?? usuarioActual.imagen,
      esAdministrador: usuarioActual.esAdministrador,
      estaBloqueado: usuarioActual.estaBloqueado,
    );

    _servicioAuth.actualizarUsuario(usuarioActualizado);

    setState(() {
      _cargando = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(localization.profileUpdated),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context);
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _cancelar() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(localization.editProfile),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _cargando ? null : _guardarCambios,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Imagen de perfil
              Center(
                child: Stack(
                  children: [
                    ClipOval(
                      child: Container(
                        color: Colors.grey[200],
                        width: 100,
                        height: 100,
                        child: _mostrarImagenPerfil(),
                      ),
                    ),
                    if (_imagenPerfil != null)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: Icon(Icons.close, size: 16, color: Colors.white),
                            onPressed: _eliminarImagen,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: _seleccionarDeGaleria,
                    icon: Icon(Icons.photo_library),
                    label: Text('Galería'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[100],
                      foregroundColor: Colors.blue[800],
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    ),
                  ),
                  SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: _tomarFoto,
                    icon: Icon(Icons.camera_alt),
                    label: Text('Cámara'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[100],
                      foregroundColor: Colors.green[800],
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(
                  labelText: localization.name,
                  border: OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _edadController,
                decoration: InputDecoration(
                  labelText: localization.age,
                  border: OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.cake),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _lugarController,
                decoration: InputDecoration(
                  labelText: localization.birthplace,
                  border: OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.location_on),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contrasenaController,
                decoration: InputDecoration(
                  labelText: localization.optionalNewPassword,
                  border: OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.lock),
                  hintText: localization.keepCurrentPasswordHint,
                ),
                obscureText: true,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _cancelar,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: Text(localization.cancel),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _cargando ? null : _guardarCambios,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: _cargando
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                              : Text(localization.saveChanges),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _edadController.dispose();
    _lugarController.dispose();
    _contrasenaController.dispose();
    super.dispose();
  }
}