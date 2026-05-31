import 'package:flutter/material.dart';
import 'package:michaelespinozac1/screens/PaginaSecundaria.dart';
import 'package:michaelespinozac1/screens/PantallaPrincipal.dart';

class DrawerGeneral extends StatefulWidget {
  const DrawerGeneral({super.key});

  @override
  State<DrawerGeneral> createState() => _DrawerGeneralState();
}

class _DrawerGeneralState extends State<DrawerGeneral> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          SizedBox(
            height: 65,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              child:Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const[
                  Icon(
                    Icons.apps,
                    size: 36,
                    color: Colors.white,
                  ),
                  SizedBox( width: 12),
                  Text("Pagina Secundaria",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              )
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text("Pantalla Principal"),
            onTap: (){
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => PaginaSecundaria())
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Mi Perfil"),
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text("Salir"),
            onTap: (){
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => PantallaPrincipal())
              );
            },
          )
        ],
      ),
    );
  }
}