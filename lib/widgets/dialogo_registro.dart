import 'package:flutter/material.dart';
import 'package:michaelespinozac1/services/servicio_autentificacion.dart';

class DialogoRegistro extends StatefulWidget {
  const DialogoRegistro({super.key});

  @override
  State<DialogoRegistro> createState() => _DialogoRegistroState();
}

class _DialogoRegistroState extends State<DialogoRegistro> {
  final _claveFormulario = GlobalKey<FormState>();
  final _controladorUsuario = TextEditingController();
  final _controladorContrasena = TextEditingController();
  final _controladorConfirmarContrasena = TextEditingController();
  final _controladorEdad = TextEditingController();
  final _controladorLugarNacimiento = TextEditingController();
  final _servicioAutenticacion = ServicioAutenticacion();
  
  String _trato = "Sr.";
  bool _cargando = false;
  bool _terminosAceptados = false;
  String _mensajeError = '';

  @override
  void dispose() {
    _controladorUsuario.dispose();
    _controladorContrasena.dispose();
    _controladorConfirmarContrasena.dispose();
    _controladorEdad.dispose();
    _controladorLugarNacimiento.dispose();
    super.dispose();
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
      );

      setState(() {
        _cargando = false;
      });

      if (exito) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('¡Registro exitoso! Ahora puedes iniciar sesión.'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.person_add, color: Colors.blue),
          SizedBox(width: 8),
          Text('Crear Cuenta'),
        ],
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _claveFormulario,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Selección de trato
              Row(
                children: [
                  Text('Trato:', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(width: 16),
                  Radio(
                    value: "Sr.",
                    groupValue: _trato,
                    onChanged: (v) => setState(() => _trato = v!),
                  ),
                  Text("Sr."),
                  Radio(
                    value: "Sra.",
                    groupValue: _trato,
                    onChanged: (v) => setState(() => _trato = v!),
                  ),
                  Text("Sra."),
                ],
              ),
              SizedBox(height: 16),

              // Campo de nombre de usuario
              TextFormField(
                controller: _controladorUsuario,
                decoration: InputDecoration(
                  labelText: 'Nombre de usuario',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
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
              SizedBox(height: 12),

              // Campo de contraseña
              TextFormField(
                controller: _controladorContrasena,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
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
              SizedBox(height: 12),

              // Campo de confirmar contraseña
              TextFormField(
                controller: _controladorConfirmarContrasena,
                decoration: InputDecoration(
                  labelText: 'Confirmar contraseña',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock_outline),
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
              SizedBox(height: 12),

              // Campo de edad
              TextFormField(
                controller: _controladorEdad,
                decoration: InputDecoration(
                  labelText: 'Edad',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.cake),
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
              SizedBox(height: 12),

              // Campo de lugar de nacimiento
              TextFormField(
                controller: _controladorLugarNacimiento,
                decoration: InputDecoration(
                  labelText: 'Lugar de nacimiento',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on),
                ),
                validator: (valor) {
                  if (valor == null || valor.isEmpty) {
                    return 'Por favor ingresa tu lugar de nacimiento';
                  }
                  return null;
                },
              ),

              // Términos y condiciones
              SizedBox(height: 12),
              Row(
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
                        'Acepto los términos y condiciones',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),

              // Mensaje de error
              if (_mensajeError.isNotEmpty) ...[
                SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error, color: Colors.red, size: 20),
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
              ],

              // Información del usuario que se creará
              if (_controladorUsuario.text.isNotEmpty) ...[
                SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Resumen:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                        ),
                      ),
                      SizedBox(height: 4),
                      Text('Usuario: ${_controladorUsuario.text}'),
                      Text('Trato: $_trato'),
                      Text('Edad: ${_controladorEdad.text.isNotEmpty ? _controladorEdad.text : "No especificada"} años'),
                      Text('Lugar: ${_controladorLugarNacimiento.text.isNotEmpty ? _controladorLugarNacimiento.text : "No especificado"}'),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _limpiarFormulario,
          child: Text('Limpiar'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _cargando ? null : _registrar,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
          child: _cargando
              ? SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text('Registrar'),
        ),
      ],
    );
  }
}