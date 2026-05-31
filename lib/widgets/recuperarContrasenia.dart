import 'package:flutter/material.dart';
import 'package:michaelespinozac1/services/servicio_autentificacion.dart';

class RecuperarContrasenia extends StatefulWidget {
  const RecuperarContrasenia({super.key});

  @override
  State<RecuperarContrasenia> createState() => _RecuperarContraseniaState();
}

class _RecuperarContraseniaState extends State<RecuperarContrasenia> {
  final _controladorUsuario = TextEditingController();
  final _servicioAutenticacion = ServicioAutenticacion();
  bool _cargando = false;
  String _mensaje = '';

  @override
  void dispose() {
    _controladorUsuario.dispose();
    super.dispose();
  }

  void _buscarContrasena() async {
    if (_controladorUsuario.text.isEmpty) {
      setState(() {
        _mensaje = 'Por favor ingresa tu nombre de usuario';
      });
      return;
    }

    setState(() {
      _cargando = true;
      _mensaje = '';
    });

    await Future.delayed(Duration(milliseconds: 500));

    final usuario = _servicioAutenticacion.buscarUsuarioPorNombre(_controladorUsuario.text.trim());

    setState(() {
      _cargando = false;
    });

    if (usuario != null) {
      setState(() {
        _mensaje = 'Usuario: ${usuario.nombre}\nContraseña: ${usuario.contrasena}';
      });
    } else {
      setState(() {
        _mensaje = 'No se encontró un usuario con ese nombre';
      });
    }
  }

  void _limpiarFormulario() {
    _controladorUsuario.clear();
    setState(() {
      _mensaje = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Recuperar Contraseña'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Ingresa tu nombre de usuario para recuperar tu contraseña:'),
            SizedBox(height: 16),
            TextFormField(
              controller: _controladorUsuario,
              decoration: InputDecoration(
                labelText: 'Nombre de usuario',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            if (_mensaje.isNotEmpty) ...[
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _mensaje.contains('No se encontró') ? Colors.red[50] : Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _mensaje.contains('No se encontró') ? Colors.red : Colors.green,
                  ),
                ),
                child: Text(
                  _mensaje,
                  style: TextStyle(
                    color: _mensaje.contains('No se encontró') ? Colors.red[800] : Colors.green[800],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _limpiarFormulario,
          child: Text('Limpiar'),
        ),
        ElevatedButton(
          onPressed: _cargando ? null : _buscarContrasena,
          child: _cargando
              ? SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text('Buscar'),
        ),
      ],
    );
  }
}