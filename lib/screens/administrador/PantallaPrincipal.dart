// screens/admin/pantalla_admin.dart
import 'package:flutter/material.dart';
import 'package:michaelespinozac1/model/usuario.dart';
import 'package:michaelespinozac1/services/servicio_autentificacion.dart';
import 'package:michaelespinozac1/l10n/app_localizations.dart';
import 'package:michaelespinozac1/screens/paginas_admin/pagina_gestion_usuarios.dart';
import 'package:michaelespinozac1/screens/paginas_admin/pagina_gestion_productos.dart';
import 'package:michaelespinozac1/screens/paginas_admin/pagina_gestion_pedidos.dart';
import 'package:provider/provider.dart';
import 'package:michaelespinozac1/services/app_state.dart';

class PantallaAdmin extends StatefulWidget {
  final Usuario usuario;

  const PantallaAdmin({super.key, required this.usuario});

  @override
  State<PantallaAdmin> createState() => _PantallaAdminState();
}

class _PantallaAdminState extends State<PantallaAdmin> {
  int _indiceActual = 0;

  final List<Widget> _paginas = const [
    PaginaGestionUsuarios(),
    PaginaGestionEventos(),
    PaginaGestionPedidos(),
  ];

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final appState = Provider.of<AppState>(context);
    final titulos = [
      localization.userManagement,
      localization.productManagement,
      localization.orderManagement,
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(titulos[_indiceActual]),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.language),
            onPressed: () => appState.toggleLanguage(),
            tooltip: localization.language,
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                _cerrarSesion();
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, size: 20),
                    SizedBox(width: 12),
                    Text(localization.logout),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: _paginas[_indiceActual],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indiceActual,
        onTap: (index) {
          setState(() {
            _indiceActual = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Usuarios'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory), label: 'Eventos'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Pedidos'),
        ],
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue[800],
        unselectedItemColor: Colors.grey[600],
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  void _cerrarSesion() {
    final localization = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(localization.logout),
          content: Text('¿Estás seguro de que quieres ${localization.logout.toLowerCase()}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(localization.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                ServicioAutenticacion().cerrarSesion();
                Navigator.of(context).pop();
                // Navegar a pantalla de login
                Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: Text(localization.logout),
            ),
          ],
        );
      },
    );
  }
}