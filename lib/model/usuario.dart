class Usuario {
  final String id;
  String nombre;
  String contrasena;
  int edad;
  String lugarNacimiento;
  String trato; // Sr. / Sra.
  String imagen;
  bool esAdministrador;
  bool estaBloqueado;

  Usuario({
    required this.id,
    required this.nombre,
    required this.contrasena,
    required this.edad,
    required this.lugarNacimiento,
    this.trato = 'Sr.',
    this.imagen = '',
    this.esAdministrador = false,
    this.estaBloqueado = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'contrasena': contrasena,
      'edad': edad,
      'lugarNacimiento': lugarNacimiento,
      'trato': trato,
      'imagen': imagen,
      'esAdministrador': esAdministrador,
      'estaBloqueado': estaBloqueado,
    };
  }

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'],
      nombre: map['nombre'],
      contrasena: map['contrasena'],
      edad: map['edad'],
      lugarNacimiento: map['lugarNacimiento'],
      trato: map['trato'] ?? 'Sr.',
      imagen: map['imagen'] ?? '',
      esAdministrador: map['esAdministrador'] ?? false,
      estaBloqueado: map['estaBloqueado'] ?? false,
    );
  }
}