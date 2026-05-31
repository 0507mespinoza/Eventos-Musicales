

import 'package:michaelespinozac1/model/usuario.dart';

class LogicaUsuarios {
  // Declaramos la lista con tu estructura simplificada de Usuario
  static final List<Usuario> _listaUsuarios = [
    Usuario(
      id: '1',
      nombre: "admin",
      contrasena: 'admin',
      edad: 30,
      lugarNacimiento: 'Valencia',
      esAdministrador: true,
      trato: 'Sr.',
      imagen: '',
    ),
    Usuario(
      id: '2',
      nombre: "Michael",
      contrasena: "Michael",
      edad: 32,
      lugarNacimiento: 'Ecuador',
      esAdministrador: false,
      trato: 'Sr.',
      imagen: '',
    ),
  ];

  // Método para añadir usuarios
  static void anadirUsuario(Usuario usuario) {
    _listaUsuarios.add(usuario);
  }

  // Método para verificar si un usuario existe
  static bool verificarUsuario(String nombre, String contrasena) {
    try {
      _listaUsuarios.firstWhere(
        (u) => u.nombre == nombre && u.contrasena == contrasena,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  // Método para obtener un usuario por nombre
  static Usuario? obtenerUsuario(String nombre) {
    try {
      return _listaUsuarios.firstWhere((user) => user.nombre == nombre);
    } catch (e) {
      return null;
    }
  }

  // Método para obtener usuario con validación de credenciales
  static Usuario? obtenerUsuarioConCredenciales(String nombre, String contrasena) {
    try {
      return _listaUsuarios.firstWhere(
        (user) => user.nombre == nombre && user.contrasena == contrasena,
      );
    } catch (e) {
      return null;
    }
  }

  // Método para verificar si el usuario ya existe
  static bool usuarioExiste(String nombre) {
    return _listaUsuarios.any((user) => user.nombre == nombre);
  }

  // Método para obtener todos los usuarios (excepto admin para gestión)
  static List<Usuario> obtenerTodosLosUsuarios() {
    return _listaUsuarios.where((user) => user.nombre != 'admin').toList();
  }

  // Método para obtener todos los usuarios (incluyendo admin)
  static List<Usuario> obtenerTodosLosUsuariosCompleto() {
    return List.from(_listaUsuarios);
  }

  // Método para eliminar usuario
  static void eliminarUsuario(String id) {
    _listaUsuarios.removeWhere((user) => user.id == id);
  }

  // Método para actualizar usuario
  static void actualizarUsuario(Usuario usuarioActualizado) {
    final index = _listaUsuarios.indexWhere((user) => user.id == usuarioActualizado.id);
    if (index != -1) {
      _listaUsuarios[index] = usuarioActualizado;
    }
  }

  // Método para recuperar contraseña
  static String? recuperarContrasenia(String nombre) {
    try {
      final user = _listaUsuarios.firstWhere((user) => user.nombre == nombre);
      return user.contrasena;
    } catch (e) {
      return null;
    }
  }

  // Método para generar ID único
  static String generarId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  // Método para verificar si es administrador
  static bool esAdministrador(String nombre) {
    try {
      final user = _listaUsuarios.firstWhere((user) => user.nombre == nombre);
      return user.nombre == 'admin';
    } catch (e) {
      return false;
    }
  }

  // Método para obtener usuario por ID
  static Usuario? obtenerUsuarioPorId(String id) {
    try {
      return _listaUsuarios.firstWhere((user) => user.id == id);
    } catch (e) {
      return null;
    }
  }

  // Método para bloquear usuario
  static void bloquearUsuario(String id) {
    final usuario = obtenerUsuarioPorId(id);
    if (usuario != null && usuario.nombre != 'admin') {
      usuario.estaBloqueado = true;
    }
  }

  // Método para desbloquear usuario
  static void desbloquearUsuario(String id) {
    final usuario = obtenerUsuarioPorId(id);
    if (usuario != null) {
      usuario.estaBloqueado = false;
    }
  }

  // Método para editar usuario
  static void editarUsuario(String id, String nombre, String contrasena, int edad, 
      String lugarNacimiento, String trato, String imagen) {
    final usuario = obtenerUsuarioPorId(id);
    if (usuario != null) {
      usuario.nombre = nombre;
      usuario.contrasena = contrasena;
      usuario.edad = edad;
      usuario.lugarNacimiento = lugarNacimiento;
      usuario.trato = trato;
      usuario.imagen = imagen;
    }
  }

  // Método para crear usuario administrador
  static void crearUsuarioAdmin(String nombre, String contrasena, int edad, String lugarNacimiento,
      String trato, String imagen) {
    final nuevoId = generarId();
    final nuevoUsuario = Usuario(
      id: nuevoId,
      nombre: nombre,
      contrasena: contrasena,
      edad: edad,
      lugarNacimiento: lugarNacimiento,
      trato: trato,
      imagen: imagen,
      esAdministrador: true,
      estaBloqueado: false,
    );
    _listaUsuarios.add(nuevoUsuario);
  }

  // Método para crear usuario cliente
  static void crearUsuarioCliente(String nombre, String contrasena, int edad, String lugarNacimiento,
      String trato, String imagen) {
    final nuevoId = generarId();
    final nuevoUsuario = Usuario(
      id: nuevoId,
      nombre: nombre,
      contrasena: contrasena,
      edad: edad,
      lugarNacimiento: lugarNacimiento,
      trato: trato,
      imagen: imagen,
      esAdministrador: false,
      estaBloqueado: false,
    );
    _listaUsuarios.add(nuevoUsuario);
  }

  // Método para obtener todos los usuarios excepto admin (para gestión)
  static List<Usuario> obtenerUsuariosParaGestion() {
    return _listaUsuarios.where((user) => user.nombre != 'admin').toList();
  }
}