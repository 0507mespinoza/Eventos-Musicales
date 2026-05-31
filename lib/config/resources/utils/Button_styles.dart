import 'package:flutter/material.dart';

class CustomButtonsStyle{

  static const ButtonStyle redButton = ButtonStyle(
    backgroundColor: WidgetStatePropertyAll(Colors.red), 
    foregroundColor: WidgetStatePropertyAll(Colors.white),
    minimumSize: WidgetStatePropertyAll(Size(100,50)),
  );
 
  static const ButtonStyle botonesDefecto = ButtonStyle(
    backgroundColor: WidgetStatePropertyAll(Color.fromARGB(255, 150, 189, 255)),
    textStyle: WidgetStatePropertyAll(TextStyle(color:Colors.black)),
    maximumSize: WidgetStatePropertyAll(Size(140,50)),
  );
}
