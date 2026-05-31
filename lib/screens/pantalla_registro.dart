import 'package:flutter/material.dart';
import 'package:michaelespinozac1/screens/pantalla_login.dart';
import 'package:michaelespinozac1/services/servicio_autentificacion.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io' show File;
import 'package:flutter/foundation.dart' show kIsWeb;

class PantallaRegistro extends StatefulWidget {
  const PantallaRegistro({super.key});

  @override
  State<PantallaRegistro> createState() => _PantallaRegistroState();
}

class _PantallaRegistroState extends State<PantallaRegistro> {
  final _claveFormulario = GlobalKey<FormState>();
  final _controladorUsuario = TextEditingController();
  final _controladorContrasena = TextEditingController();
  final _controladorConfirmarContrasena = TextEditingController();
  final _controladorEdad = TextEditingController();
  final _controladorLugarNacimiento = TextEditingController();
  final _servicioAutenticacion = ServicioAutenticacion();
  final ImagePicker _picker = ImagePicker();
  
  String _trato = "Sr.";
  bool _cargando = false;
  bool _terminosAceptados = false;
  String _mensajeError = '';
  XFile? _imagenPerfil;

  @override
  void dispose() {
    _controladorUsuario.dispose();
    _controladorContrasena.dispose();
    _controladorConfirmarContrasena.dispose();
    _controladorEdad.dispose();
    _controladorLugarNacimiento.dispose();
    super.dispose();
  }

  // Método para seleccionar imagen desde galería
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
      setState(() {
        _mensajeError = 'Error al seleccionar imagen: $e';
      });
    }
  }

  // Método para tomar foto con cámara
  Future<void> _tomarFoto() async {
    final status = await Permission.camera.request();
    if (!status.isGranted) {
      setState(() {
        _mensajeError = 'Permiso de cámara denegado';
      });
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
      setState(() {
        _mensajeError = 'Error al tomar foto: $e';
      });
    }
  }

  // Método para mostrar imagen de perfil
  Widget _mostrarImagenPerfil() {
    if (_imagenPerfil == null) {
      return Icon(
        Icons.person,
        size: 50,
        color: Colors.grey[600],
      );
    }

    if (kIsWeb) {
      // Para web, usar Image.network con la URL del archivo
      return Image.network(
        _imagenPerfil!.path,
        width: 100,
        height: 100,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Icon(
            Icons.person,
            size: 50,
            color: Colors.grey[600],
          );
        },
      );
    } else {
      // Para plataformas nativas, convertir XFile a File
      return Image.file(
        File(_imagenPerfil!.path),
        width: 100,
        height: 100,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Icon(
            Icons.person,
            size: 50,
            color: Colors.grey[600],
          );
        },
      );
    }
  }

  // Método para eliminar imagen
  void _eliminarImagen() {
    setState(() {
      _imagenPerfil = null;
    });
  }

  void _registrar() async {
    if (_claveFormulario.currentState!.validate()) {
      if (!_terminosAceptados) {
        setState(() {
          _mensajeError = 'Debes aceptar los términos y condiciones';
        });
        return;
      }

      if (_controladorContrasena.text != _controladorConfirmarContrasena.text) {
        setState(() {
          _mensajeError = 'Las contraseñas no coinciden';
        });
        return;
      }

      final edad = int.tryParse(_controladorEdad.text);
      if (edad == null || edad < 1 || edad > 120) {
        setState(() {
          _mensajeError = 'Ingresa una edad válida (1-120)';
        });
        return;
      }

      setState(() {
        _cargando = true;
        _mensajeError = '';
      });

      await Future.delayed(Duration(milliseconds: 1000));

      // Usar el método actualizado sin correo
      final exito = _servicioAutenticacion.registrarUsuario(
        _controladorUsuario.text.trim(), // Solo nombre de usuario
        _controladorContrasena.text.trim(),
        edad,
        _controladorLugarNacimiento.text.trim(),
        trato: _trato,
        imagen: _imagenPerfil?.path ?? '',
      );

      setState(() {
        _cargando = false;
      });

      if (exito) {
        // Mostrar mensaje de éxito y regresar al login
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('¡Registro exitoso! Ahora puedes iniciar sesión.'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
        
        // Regresar a la pantalla de login después de un breve delay
        await Future.delayed(Duration(milliseconds: 1500));
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => PantallaLogin()),
          );
        }
      } else {
        setState(() {
          _mensajeError = 'El nombre de usuario ya está registrado';
        });
      }
    }
  }

  void _limpiarFormulario() {
    _claveFormulario.currentState?.reset();
    _controladorUsuario.clear();
    _controladorContrasena.clear();
    _controladorConfirmarContrasena.clear();
    _controladorEdad.clear();
    _controladorLugarNacimiento.clear();
    setState(() {
      _trato = "Sr.";
      _terminosAceptados = false;
      _mensajeError = '';
      _imagenPerfil = null;
    });
  }

  void _irALogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => PantallaLogin()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: Text('Crear Cuenta'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: _irALogin,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Form(
            key: _claveFormulario,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título
                Center(
                  child: Column(
                    children: [
                      // Avatar/Imagen de perfil
                      Stack(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey[300],
                              border: Border.all(color: Colors.blue, width: 2),
                            ),
                            child: _imagenPerfil != null
                                ? ClipOval(
                                    child: _mostrarImagenPerfil(),
                                  )
                                : Icon(
                                    Icons.person,
                                    size: 50,
                                    color: Colors.grey[600],
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
                      SizedBox(height: 10),
                      Text(
                        'Crear Nueva Cuenta',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Completa tus datos para registrarte',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),

                // Botones para imagen de perfil
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Foto de perfil (opcional)',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: _seleccionarDeGaleria,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue[100],
                                  foregroundColor: Colors.blue[800],
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                ),
                                icon: Icon(Icons.photo_library),
                                label: Text('Galería'),
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: _tomarFoto,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green[100],
                                  foregroundColor: Colors.green[800],
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                ),
                                icon: Icon(Icons.camera_alt),
                                label: Text('Cámara'),
                              ),
                            ),
                          ],
                        ),
                        if (_imagenPerfil != null)
                          Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Text(
                              'Imagen seleccionada ✓',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Selección de trato
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Trato',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Radio(
                              value: "Sr.",
                              groupValue: _trato,
                              onChanged: (v) => setState(() => _trato = v!),
                            ),
                            Text("Sr."),
                            SizedBox(width: 20),
                            Radio(
                              value: "Sra.",
                              groupValue: _trato,
                              onChanged: (v) => setState(() => _trato = v!),
                            ),
                            Text("Sra."),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Campo de nombre de usuario
                TextFormField(
                  controller: _controladorUsuario,
                  decoration: InputDecoration(
                    labelText: 'Nombre de usuario',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Ej: michael123',
                  ),
                  validator: (valor) {
                    if (valor == null || valor.isEmpty) {
                      return 'Por favor ingresa un nombre de usuario';
                    }
                    if (valor.length < 3) {
                      return 'El usuario debe tener al menos 3 caracteres';
                    }
                    if (valor.contains(' ')) {
                      return 'El usuario no puede contener espacios';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // Campo de contraseña
                TextFormField(
                  controller: _controladorContrasena,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  obscureText: true,
                  validator: (valor) {
                    if (valor == null || valor.isEmpty) {
                      return 'Por favor ingresa una contraseña';
                    }
                    if (valor.length < 6) {
                      return 'La contraseña debe tener al menos 6 caracteres';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // Campo de confirmar contraseña
                TextFormField(
                  controller: _controladorConfirmarContrasena,
                  decoration: InputDecoration(
                    labelText: 'Confirmar contraseña',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock_outline),
                    filled: true,
                    fillColor: Colors.white,
                    errorText: _controladorContrasena.text != _controladorConfirmarContrasena.text && 
                              _controladorConfirmarContrasena.text.isNotEmpty
                        ? 'Las contraseñas no coinciden'
                        : null,
                  ),
                  obscureText: true,
                  validator: (valor) {
                    if (valor == null || valor.isEmpty) {
                      return 'Por favor confirma tu contraseña';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // Campo de edad
                TextFormField(
                  controller: _controladorEdad,
                  decoration: InputDecoration(
                    labelText: 'Edad',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.cake),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  keyboardType: TextInputType.number,
                  validator: (valor) {
                    if (valor == null || valor.isEmpty) {
                      return 'Por favor ingresa tu edad';
                    }
                    final edad = int.tryParse(valor);
                    if (edad == null || edad < 1 || edad > 120) {
                      return 'Ingresa una edad válida (1-120)';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // Campo de lugar de nacimiento
                TextFormField(
                  controller: _controladorLugarNacimiento,
                  decoration: InputDecoration(
                    labelText: 'Lugar de nacimiento',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.location_on),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (valor) {
                    if (valor == null || valor.isEmpty) {
                      return 'Por favor ingresa tu lugar de nacimiento';
                    }
                    return null;
                  },
                ),

                // Términos y condiciones
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Checkbox(
                          value: _terminosAceptados,
                          onChanged: (v) {
                            setState(() {
                              _terminosAceptados = v ?? false;
                            });
                          },
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _terminosAceptados = !_terminosAceptados;
                              });
                            },
                            child: Text(
                              'Acepto los términos y condiciones del servicio',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Información del usuario que se creará
                if (_controladorUsuario.text.isNotEmpty) ...[
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Resumen de tu cuenta:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[800],
                            ),
                          ),
                          SizedBox(height: 8),
                          Text('Usuario: ${_controladorUsuario.text}'),
                          Text('Trato: $_trato'),
                          Text('Edad: ${_controladorEdad.text.isNotEmpty ? _controladorEdad.text : "No especificada"} años'),
                          Text('Lugar: ${_controladorLugarNacimiento.text.isNotEmpty ? _controladorLugarNacimiento.text : "No especificado"}'),
                          if (_imagenPerfil != null)
                            Text('Foto: Sí ✓', style: TextStyle(color: Colors.green)),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                ],

                // Mensaje de error
                if (_mensajeError.isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12),
                    margin: EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error, color: Colors.red),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _mensajeError,
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Botones de acción
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _limpiarFormulario,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.clear, size: 18),
                            SizedBox(width: 8),
                            Text('Limpiar'),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _cargando ? null : _registrar,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: _cargando
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.person_add, size: 18),
                                  SizedBox(width: 8),
                                  Text('Registrar'),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20),

                // Enlace para volver al login
                Center(
                  child: TextButton(
                    onPressed: _irALogin,
                    child: Text(
                      '¿Ya tienes cuenta? Inicia sesión aquí',
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}