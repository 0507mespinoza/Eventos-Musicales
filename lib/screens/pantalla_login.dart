import 'package:flutter/material.dart';
import 'package:michaelespinozac1/screens/pantalla_cliente_principal.dart';
import 'package:michaelespinozac1/screens/pantalla_admin_principal.dart';
import 'package:michaelespinozac1/screens/pantalla_registro.dart';
import 'package:michaelespinozac1/services/servicio_autentificacion.dart';
import 'package:michaelespinozac1/l10n/app_localizations.dart';

class PantallaLogin extends StatefulWidget {
  const PantallaLogin({super.key});

  @override
  _EstadoPantallaLogin createState() => _EstadoPantallaLogin();
}

class _EstadoPantallaLogin extends State<PantallaLogin> {
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _contraseniaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _servicioAutenticacion = ServicioAutenticacion();
  
  bool _cargando = false;
  bool _mostrarContrasena = false;

  void _iniciarSesion() async {
    if (_formKey.currentState!.validate()) {
      String usuario = _usuarioController.text.trim();
      String contrasenia = _contraseniaController.text.trim();

      setState(() {
        _cargando = true;
      });

      final usuarioBuscado = _servicioAutenticacion.buscarUsuarioPorNombre(usuario);
      if (usuarioBuscado != null && usuarioBuscado.estaBloqueado) {
        _mostrarError("Tu usuario está bloqueado");
        setState(() {
          _cargando = false;
        });
        return;
      }

      // Simular tiempo de carga
      await Future.delayed(Duration(milliseconds: 1000));

      bool credencialesValidas = _servicioAutenticacion.iniciarSesion(usuario, contrasenia);
      
      if (credencialesValidas) {
        final usuario = _servicioAutenticacion.usuarioActual;
        
        if (usuario != null && usuario.estaBloqueado) {
          _mostrarError("Tu usuario está bloqueado");
          setState(() {
            _cargando = false;
          });
          return;
        }

        if (_servicioAutenticacion.esAdministradorActual) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => PantallaAdminPrincipal(),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => PantallaClientePrincipal(),
            ),
          );
        }
        
        _usuarioController.clear();
        _contraseniaController.clear();
      } else {
        _mostrarError("Usuario o contraseña incorrectos");
      }

      setState(() {
        _cargando = false;
      });
    }
  }

  Future<String?> _pedirCorreoGoogle() async {
    final controller = TextEditingController();

    final correo = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Acceder con Google'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Correo electrónico',
              hintText: 'ejemplo@gmail.com',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, controller.text.trim());
              },
              child: const Text('Continuar'),
            ),
          ],
        );
      },
    );

    controller.dispose();

    if (correo == null || correo.isEmpty) {
      return null;
    }

    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(correo)) {
      _mostrarError('Ingresa un correo válido');
      return null;
    }

    return correo;
  }

  Future<void> _iniciarSesionConGoogle() async {
    final correoIngresado = await _pedirCorreoGoogle();
    if (correoIngresado == null) return;

    setState(() {
      _cargando = true;
    });

    final error = await _servicioAutenticacion.iniciarSesionConGoogle(
      correoEsperado: correoIngresado,
    );

    if (!mounted) return;

    if (error == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PantallaClientePrincipal(),
        ),
      );
    } else {
      _mostrarError(error);
    }

    setState(() {
      _cargando = false;
    });
  }

  void _mostrarError(String mensaje) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(mensaje),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Aceptar"),
            ),
          ],
        );
      },
    );
  }

  void _mostrarDialogoRecuperarContrasenia() {
    final usuarioController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Recuperar Contraseña'),
          content: TextField(
            controller: usuarioController,
            decoration: InputDecoration(
              labelText: 'Ingresa tu usuario',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                final contrasenia = _servicioAutenticacion
                    .recuperarContrasenaPorNombre(usuarioController.text);
                
                if (contrasenia != null) {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Tu Contraseña'),
                        content: Text('Tu contraseña es: $contrasenia'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  Navigator.pop(context);
                  _mostrarError('Usuario no encontrado');
                }
              },
              child: const Text('Enviar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                
                // Logo
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 150, 189, 255).withOpacity(0.2),
                    shape: BoxShape.circle,
                    border: Border.all(color: Color.fromARGB(255, 150, 189, 255), width: 2),
                  ),
                  child: Icon(
                    Icons.shopping_cart,
                    size: 60,
                    color: Color.fromARGB(255, 150, 189, 255),
                  ),
                ),
                
                const SizedBox(height: 30),
                
                Text(
                  localization.welcome,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 150, 189, 255),
                  ),
                ),
                
                const SizedBox(height: 8),
                
                Text(
                  'Inicia sesión en tu cuenta',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                
                const SizedBox(height: 40),

                // Usuario
                TextFormField(
                  controller: _usuarioController,
                  decoration: InputDecoration(
                    labelText: localization.username,
                    hintText: 'Ingresa tu usuario',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El usuario es requerido';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 20),

                // Contraseña
                TextFormField(
                  controller: _contraseniaController,
                  obscureText: !_mostrarContrasena,
                  decoration: InputDecoration(
                    labelText: localization.password,
                    hintText: 'Ingresa tu contraseña',
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _mostrarContrasena ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _mostrarContrasena = !_mostrarContrasena;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'La contraseña es requerida';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 12),

                // Botón de recuperar contraseña
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _mostrarDialogoRecuperarContrasenia,
                    child: Text(localization.forgotPassword),
                  ),
                ),
                
                const SizedBox(height: 20),

                // Botón de login
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _cargando ? null : _iniciarSesion,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 150, 189, 255),
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: _cargando
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                            localization.login,
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                  ),
                ),
                
                const SizedBox(height: 20),

                // Divider
                Row(
                  children: [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text('O'),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                
                const SizedBox(height: 20),

                // Google login
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _cargando ? null : _iniciarSesionConGoogle,
                    icon: Image.asset(
                      'assets/images/google_logo.png',
                      height: 20,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.login);
                      },
                    ),
                    label: Text(localization.googleLogin),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),

                // Registro
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('¿No tienes cuenta? '),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PantallaRegistro(),
                          ),
                        );
                      },
                      child: Text(localization.register),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}