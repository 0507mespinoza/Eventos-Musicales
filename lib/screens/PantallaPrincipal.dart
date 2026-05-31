import 'package:flutter/material.dart';
import 'package:michaelespinozac1/config/resources/utils/Button_styles.dart';
import 'package:michaelespinozac1/screens/PaginaSecundaria.dart';
import 'package:michaelespinozac1/screens/pantalla_registro.dart';

void main() {
  runApp(const PantallaPrincipal());
}

class PantallaPrincipal extends StatefulWidget {
  const PantallaPrincipal({super.key});

  @override
  State<PantallaPrincipal> createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal> {
  final _formkey = GlobalKey<FormState>();

  void _paginasecundaria() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PaginaSecundaria()),
    );
  }

  void _registro() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PantallaRegistro()),
    );
  }

  @override  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 109, 182, 241),
        title: Row(children: [Text("Pantalla Principal")]),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(100.0),
          child: Column(
            children: [
              SizedBox(height: 10),
              Image.asset("assets/images/logo.jpg"),
              SizedBox(height: 10),
              Form(
                key: _formkey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Nombre",
                        border: OutlineInputBorder(),                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Contraseña",
                        border: OutlineInputBorder(),                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),
              ElevatedButton(
                style: CustomButtonsStyle.botonesDefecto,
                onPressed: _paginasecundaria,
                child: Row(children: [Text("Iniciar Sesión")]),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                style: CustomButtonsStyle.botonesDefecto,
                onPressed: _registro,
                child: Row(children: [Text("Registrarse")]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}