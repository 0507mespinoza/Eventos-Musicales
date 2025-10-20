
class User{
  final String nombre;
  final String contrasenia;
  final int edad;
  final String lugarNcimiento;

 User({
  required this.nombre,
  required this.contrasenia,
  required this.edad ,
  required this.lugarNcimiento

 });

  String getNombre (){
    return nombre;
  }
  String getcontrasenia(){
    return contrasenia;
  }

  int getedad(){
    return edad;
  }

  String getlugarNacimiento(){
    return lugarNcimiento;
  }

}