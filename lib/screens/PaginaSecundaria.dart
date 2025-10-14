import 'package:flutter/material.dart';
import 'package:michaelespinozac1/services/LogicaUsuario.dart';
import 'package:michaelespinozac1/widgets/DrawerGeneral.dart';

class PaginaSecundaria extends StatefulWidget {
  const PaginaSecundaria({super.key});

  @override
  State<PaginaSecundaria> createState() => _PaginaSecundariaState();
}

class _PaginaSecundariaState extends State<PaginaSecundaria> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerGeneral(),
      appBar:AppBar(
        title: Text("Bienbenido "+Logicausuarios.getListaUsuarios().last.getNombre()),
      ),
    );
  }
}