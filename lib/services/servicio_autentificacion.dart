// services/servicio_autentificacion.dart
import 'package:google_sign_in/google_sign_in.dart';
import 'package:michaelespinozac1/model/usuario.dart';
import 'package:michaelespinozac1/services/servicio_musica.dart';

class ServicioAutenticacion {
  static final ServicioAutenticacion _instancia = ServicioAutenticacion._internal();
  factory ServicioAutenticacion() => _instancia;
  ServicioAutenticacion._internal();

  final List<Usuario> _usuarios = [
    Usuario(
      id: '1',
      nombre: 'admin',
      contrasena: 'admin',
      edad: 30,
      lugarNacimiento: 'Valencia',
      esAdministrador: true,
      trato: 'Sr.',
      imagen: '',
    ),
    Usuario(
      id: '2',
      nombre: 'Michael',
      contrasena: 'Michael',
      edad: 25,
      lugarNacimiento: 'España',
      esAdministrador: false,
      trato: 'Sr.',
      imagen: '',
    ),
  ];

  Usuario? _usuarioActual;
  final ServicioMusica _servicioMusica = ServicioMusica();
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  // Inicializar servicio de música
  void inicializarMusica() {
    _servicioMusica.inicializar();
  }

  bool esUsuarioAdmin(String nombreUsuario) {
    return nombreUsuario.toLowerCase() == 'admin';
  }

  bool get esAdministradorActual {
    return _usuarioActual != null && _usuarioActual!.nombre.toLowerCase() == 'admin';
  }

  Usuario? buscarUsuarioPorNombre(String nombre) {
    try {
      return _usuarios.firstWhere(
        (user) => user.nombre.toLowerCase() == nombre.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  String? recuperarContrasenaPorNombre(String nombre) {
    final usuario = buscarUsuarioPorNombre(nombre);
    return usuario?.contrasena;
  }

  bool iniciarSesion(String nombre, String contrasena) {
    try {
      final usuario = _usuarios.firstWhere(
        (user) =>
            user.nombre.toLowerCase() == nombre.toLowerCase() &&
            user.contrasena == contrasena,
      );
      
      // Verificar si el usuario está bloqueado
      if (usuario.estaBloqueado) {
        return false;
      }
      
      _usuarioActual = usuario;
      
      // INICIAR MÚSICA AL LOGEARSE EXITOSAMENTE
      _servicioMusica.iniciarMusica();
      
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<String?> iniciarSesionConGoogle({required String correoEsperado}) async {
    final correoNormalizado = correoEsperado.trim().toLowerCase();
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

    if (!emailRegex.hasMatch(correoNormalizado)) {
      return 'Ingresa un correo válido';
    }

    try {
      final cuenta = await _googleSignIn.signIn();

      if (cuenta == null) {
        return 'Inicio de sesión con Google cancelado';
      }

      final correoGoogle = cuenta.email.trim().toLowerCase();
      if (correoGoogle != correoNormalizado) {
        await _googleSignIn.signOut();
        return 'El correo seleccionado en Google no coincide con el correo ingresado';
      }

      final existente = buscarUsuarioPorNombre(correoGoogle);
      if (existente != null) {
        if (existente.estaBloqueado) {
          return 'Tu usuario está bloqueado';
        }
        _usuarioActual = existente;
      } else {
        final usuarioGoogle = Usuario(
          id: 'google_${DateTime.now().millisecondsSinceEpoch}',
          nombre: correoGoogle,
          contrasena: '',
          edad: 18,
          lugarNacimiento: 'No especificado',
          trato: 'Sr.',
          imagen: cuenta.photoUrl ?? '',
          esAdministrador: false,
        );
        _usuarios.add(usuarioGoogle);
        _usuarioActual = usuarioGoogle;
      }

      // INICIAR MÚSICA AL LOGEARSE CON GOOGLE
      _servicioMusica.iniciarMusica();
      return null;
    } catch (e) {
      return 'Error al iniciar sesión con Google. Verifica configuración de Google Sign-In';
    }
  }

  void cerrarSesion() {
    // DETENER MÚSICA AL CERRAR SESIÓN
    _servicioMusica.detenerMusica();
    _googleSignIn.signOut();
    _usuarioActual = null;
  }

  bool registrarUsuario(
    String nombre,
    String contrasena,
    int edad,
    String lugarNacimiento, {
    String trato = 'Sr.',
    String imagen = '',
    bool esAdministrador = false,
  }) {
    final nombreNormalizado = nombre.trim();
    if (_usuarios.any((user) =>
        user.nombre.toLowerCase() == nombreNormalizado.toLowerCase())) {
      return false;
    }

    final nuevoUsuario = Usuario(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      nombre: nombreNormalizado,
      contrasena: contrasena,
      edad: edad,
      lugarNacimiento: lugarNacimiento,
      trato: trato,
      imagen: imagen,
      esAdministrador: esAdministrador,
    );

    _usuarios.add(nuevoUsuario);
    return true;
  }

  bool estaAutenticado() {
    return _usuarioActual != null;
  }

  Usuario? get usuarioActual => _usuarioActual;
  List<Usuario> get usuarios => List.from(_usuarios);

  Usuario? obtenerUsuarioPorId(String id) {
    try {
      return _usuarios.firstWhere((user) => user.id == id);
    } catch (e) {
      return null;
    }
  }

  void actualizarUsuario(Usuario usuarioActualizado) {
    final existeNombreDuplicado = _usuarios.any(
      (user) =>
          user.id != usuarioActualizado.id &&
          user.nombre.toLowerCase() == usuarioActualizado.nombre.toLowerCase(),
    );
    if (existeNombreDuplicado) return;

    final index = _usuarios.indexWhere((user) => user.id == usuarioActualizado.id);
    if (index != -1) {
      _usuarios[index] = usuarioActualizado;
    }
  }

  bool eliminarUsuario(String id) {
    final usuario = obtenerUsuarioPorId(id);
    if (usuario == null || usuario.nombre.toLowerCase() == 'admin') {
      return false;
    }

    final initialLength = _usuarios.length;
    _usuarios.removeWhere((user) => user.id == id);
    return _usuarios.length < initialLength;
  }

  void bloquearUsuario(String id) {
    final usuario = obtenerUsuarioPorId(id);
    if (usuario != null && usuario.nombre.toLowerCase() != 'admin') {
      usuario.estaBloqueado = true;
    }
  }

  void desbloquearUsuario(String id) {
    final usuario = obtenerUsuarioPorId(id);
    if (usuario != null) {
      usuario.estaBloqueado = false;
    }
  }

  List<Usuario> obtenerUsuariosGestion({String? excluirUsuarioId}) {
    return _usuarios.where((u) {
      if (u.nombre.toLowerCase() == 'admin') return false;
      if (excluirUsuarioId != null && u.id == excluirUsuarioId) return false;
      if (u.esAdministrador) return false;
      return true;
    }).toList();
  }

  // Métodos para control de música
  void iniciarMusica() {
    _servicioMusica.iniciarMusica();
  }

  void detenerMusica() {
    _servicioMusica.detenerMusica();
  }

  void alternarMusica() {
    _servicioMusica.alternarMusica();
  }

  void pausarMusica() {
    _servicioMusica.pausarMusica();
  }

  void reanudarMusica() {
    _servicioMusica.reanudarMusica();
  }

  bool get musicaActivada => _servicioMusica.musicaActivada;
  bool get musicaReproduciendo => _servicioMusica.estaReproduciendo;
}