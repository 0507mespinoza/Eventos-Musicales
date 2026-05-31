import 'package:flutter/material.dart';
import 'package:michaelespinozac1/services/servicio_autentificacion.dart';
import 'package:michaelespinozac1/l10n/app_localizations.dart';
import 'package:michaelespinozac1/screens/paginas_admin/pagina_gestion_usuarios.dart';
import 'package:michaelespinozac1/screens/paginas_admin/pagina_gestion_productos.dart';
import 'package:michaelespinozac1/screens/paginas_admin/pagina_gestion_pedidos.dart';
import 'package:michaelespinozac1/services/app_state.dart';
import 'package:provider/provider.dart';

class PantallaAdminPrincipal extends StatefulWidget {
  const PantallaAdminPrincipal({super.key});

  @override
  State<PantallaAdminPrincipal> createState() => _PantallaAdminPrincipalState();
}

class _PantallaAdminPrincipalState extends State<PantallaAdminPrincipal> {
  final ServicioAutenticacion _servicioAuth = ServicioAutenticacion();
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    PaginaGestionUsuarios(),
    PaginaGestionEventos(),
    PaginaGestionPedidos(),
  ];

  void _cerrarSesion() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cerrar Sesión'),
          content: const Text('¿Deseas cerrar sesión?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                _servicioAuth.cerrarSesion();
                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
              },
              child: const Text('Cerrar Sesión'),
            ),
          ],
        );
      },
    );
  }

  void _salirApp() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Salir'),
          content: const Text('¿Deseas salir de la aplicación?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                _servicioAuth.detenerMusica();
                Navigator.pop(context);
              },
              child: const Text('Salir'),
            ),
          ],
        );
      },
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final usuario = _servicioAuth.usuarioActual;
    final appState = Provider.of<AppState>(context, listen: false);
    final localization = AppLocalizations.of(context);

    return WillPopScope(
      onWillPop: () async {
        _salirApp();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Panel de Administrador - ${usuario?.nombre}'),
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.red,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.admin_panel_settings,
                          size: 30, color: Colors.red),
                    ),
                    SizedBox(height: 8),
                    Text(
                      usuario?.nombre ?? 'Administrador',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    Text(
                      'Administrador',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: Text(localization.logout),
                onTap: _cerrarSesion,
              ),
              ListTile(
                leading: const Icon(Icons.exit_to_app),
                title: Text(localization.exitApp),
                onTap: _salirApp,
              ),
              ExpansionTile(
                leading: const Icon(Icons.language),
                title: Text(localization.language),
                children: [
                  ListTile(
                    contentPadding: const EdgeInsets.only(left: 72, right: 16),
                    title: Text(localization.spanish),
                    trailing: appState.locale.languageCode == 'es'
                        ? const Icon(Icons.check, color: Colors.red)
                        : null,
                    onTap: () {
                      appState.changeLanguage('es');
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    contentPadding: const EdgeInsets.only(left: 72, right: 16),
                    title: Text(localization.english),
                    trailing: appState.locale.languageCode == 'en'
                        ? const Icon(Icons.check, color: Colors.red)
                        : null,
                    onTap: () {
                      appState.changeLanguage('en');
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        body: _pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: 'Usuarios',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.inventory),
              label: 'Productos',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt),
              label: 'Pedidos',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.red[800],
          unselectedItemColor: Colors.grey[600],
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}