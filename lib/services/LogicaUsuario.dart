
import 'package:michaelespinozac1/model/user.dart';

class Logicausuarios {
  //declaramos la lista
  static final List <User> _listaUsuarios = [
    User(
      nombre: "admin", contrasenia: '', edad: 0, lugarNcimiento: '',
    ),
  ];


  //Metodo para añadir ususarios
  static void anadirUsuarios(User usuarios){
   _listaUsuarios.add(usuarios);
  }

  //Metodo para obtener la lista de ususarios
  static List<User> getListaUsuarios(){
    return _listaUsuarios;
  }
}