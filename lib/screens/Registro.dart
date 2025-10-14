import 'package:flutter/material.dart';
import 'package:michaelespinozac1/config/resources/utils/Button_styles.dart';
import 'package:michaelespinozac1/screens/PantallaPrincipal.dart';

class Registro extends StatefulWidget {
  const Registro({super.key});

  @override
  State<Registro> createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {
  String trato = "Sr.";
  
  void _PantallaPrincipal() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PantallaPrincipal()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 109, 182, 241),
        title: Row(children: [Text("Registros")]),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(80.0),
        child: Column(
          children: [
            Row(
              children: [
                const Text("Trato"),
                Radio(
                  value: "Sr",
                  groupValue: trato,
                  onChanged: (v) => setState(() => trato = v!),
                ),
                const Text("Sr."),
                Radio(
                  value: "Sra.",
                  groupValue: trato,
                  onChanged: (v) => setState(() => trato = v!),
                ),
                const Text("Sra."),
              ],
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Nombre",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Contraseña",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Repita la contraseña",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: const Text("Añadir Imagen"),
            ),
            SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Edad",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Lugar de Nacimiento",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Row(
                children: [
                  Expanded(
                    child: Text('Acepto los términos y condiciones'),
                  ),
                ],
              ),
            SizedBox(height: 10),
            ElevatedButton(
              style: CustomButtonsStyle.botonesDefecto,
              onPressed: _PantallaPrincipal,
              child: Row(children: [Text("Aceptar")]),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              style: CustomButtonsStyle.botonesDefecto,
              onPressed: () {},
              child: Row(children: [Text("Cancelar")]),
            ),
          ],
        ),
      ),
    );
  }
}