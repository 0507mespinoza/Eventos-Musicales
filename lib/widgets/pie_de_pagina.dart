import 'package:flutter/material.dart';

class PieDePagina extends StatelessWidget {
  final int indiceActual;
  final Function(int) onTabChanged;

  const PieDePagina({
    super.key,
    required this.indiceActual,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _BotonPiePagina(
            icono: Icons.home,
            etiqueta: 'Home',
            estaActivo: indiceActual == 0,
            onTap: () => onTabChanged(0),
          ),
          _BotonPiePagina(
            icono: Icons.shopping_bag,
            etiqueta: 'Pedidos',
            estaActivo: indiceActual == 1,
            onTap: () => onTabChanged(1),
          ),
          _BotonPiePagina(
            icono: Icons.person,
            etiqueta: 'Yo',
            estaActivo: indiceActual == 2,
            onTap: () => onTabChanged(2),
          ),
        ],
      ),
    );
  }
}

class _BotonPiePagina extends StatelessWidget {
  final IconData icono;
  final String etiqueta;
  final bool estaActivo;
  final VoidCallback onTap;

  const _BotonPiePagina({
    required this.icono,
    required this.etiqueta,
    required this.estaActivo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icono,
              size: 28,
              color: estaActivo ? Colors.blue : Colors.grey,
            ),
            SizedBox(height: 4),
            Text(
              etiqueta,
              style: TextStyle(
                fontSize: 12,
                fontWeight: estaActivo ? FontWeight.bold : FontWeight.normal,
                color: estaActivo ? Colors.blue : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}