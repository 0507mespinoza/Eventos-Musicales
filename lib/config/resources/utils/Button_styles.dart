import 'package:flutter/material.dart';

class CustomButtonsStyle{

  static final ButtonStyle redButton = ButtonStyle(
    backgroundColor: const MaterialStatePropertyAll(Colors.red), 
    foregroundColor: const MaterialStatePropertyAll(Colors.white),
    minimumSize: const MaterialStatePropertyAll(Size(100,50)),
  );
 
  static const ButtonStyle botonesDefecto = ButtonStyle(
    backgroundColor: MaterialStatePropertyAll(Color.fromARGB(255, 150, 189, 255)),
    textStyle: MaterialStatePropertyAll(TextStyle(color:Colors.black)),
    maximumSize: const MaterialStatePropertyAll(Size(140,50)),
  );
}
