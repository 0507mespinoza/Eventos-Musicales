import 'package:flutter/material.dart';
import 'package:michaelespinozac1/screens/paginas_cliente/pagina_compras.dart';
import 'package:michaelespinozac1/screens/paginas_cliente/pagina_pedidos_cliente.dart';
import 'package:michaelespinozac1/screens/paginas_cliente/pagina_perfil_cliente.dart';
import 'package:michaelespinozac1/screens/paginas_cliente/pagina_informacion.dart';
import 'package:michaelespinozac1/model/productos.dart';
import 'package:michaelespinozac1/screens/paginas_cliente/pagina_contacto.dart';
import 'package:michaelespinozac1/services/servicio_autentificacion.dart';
import 'package:michaelespinozac1/services/logica_productos.dart';
import 'package:michaelespinozac1/l10n/app_localizations.dart';
import 'package:michaelespinozac1/services/app_state.dart';
import 'package:provider/provider.dart';

class PantallaClientePrincipal extends StatefulWidget {
  const PantallaClientePrincipal({super.key});

  @override
  State<PantallaClientePrincipal> createState() => _PantallaClientePrincipalState();
}

class _PantallaClientePrincipalState extends State<PantallaClientePrincipal> {
  final ServicioAutenticacion _servicioAuth = ServicioAutenticacion();
  int _selectedIndex = 0;
  EntradaConcierto? _eventoSeleccionado;

  @override
  void initState() {
    super.initState();
    final productos = LogicaProductos.instance.getProductos();
    if (productos.isNotEmpty) {
      _eventoSeleccionado = productos.first;
    }
  }

  EntradaConcierto _eventoPlaceholder() {
    return EntradaConcierto(
      id: 'info',
      nombre: 'Información',
      descripcion: 'Selecciona un evento en la pestaña Eventos para ver su información extendida.',
      precio: 0.0,
      stock: 0,
      imagen: '',
      artista: '',
      fecha: '',
      lugar: '',
      tipo: 'info',
    );
  }

  void _seleccionarEventoDesdeCompras(EntradaConcierto evento) {
    setState(() {
      _eventoSeleccionado = evento;
      _selectedIndex = 2;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _cerrarSesion() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context).logout),
          content: Text(AppLocalizations.of(context).closeSessionQuestion),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context).cancel),
            ),
            TextButton(
              onPressed: () {
                _servicioAuth.cerrarSesion();
                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
              },
              child: Text(AppLocalizations.of(context).logout),
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
          title: Text(AppLocalizations.of(context).exitApp),
          content: Text(AppLocalizations.of(context).exitAppQuestion),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context).cancel),
            ),
            TextButton(
              onPressed: () {
                _servicioAuth.detenerMusica();
                Navigator.pop(context);
              },
              child: Text(AppLocalizations.of(context).exitApp),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final usuario = _servicioAuth.usuarioActual;
    final appState = Provider.of<AppState>(context, listen: false);
    final localization = AppLocalizations.of(context);

    final pages = <Widget>[
      PaginaCompras(onEventoSeleccionado: _seleccionarEventoDesdeCompras),
      PaginaPedidosCliente(),
      PaginaInformacion(evento: _eventoSeleccionado ?? _eventoPlaceholder()),
      PaginaPerfilCliente(),
      PaginaContacto(),
    ];

    return WillPopScope(
      onWillPop: () async {
        _salirApp();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('${localization.welcome} ${usuario?.nombre}'),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: Text(
                        (usuario?.nombre ?? 'U')[0].toUpperCase(),
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      usuario?.nombre ?? 'Usuario',
                      style: TextStyle(color: Colors.white, fontSize: 16),
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
                        ? const Icon(Icons.check, color: Colors.blue)
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
                        ? const Icon(Icons.check, color: Colors.blue)
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
        body: pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: const Icon(Icons.shopping_bag),
              label: localization.home,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.receipt),
              label: localization.orders,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.info),
              label: localization.information,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person),
              label: localization.profile,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.contact_mail),
              label: localization.contact,
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue[800],
          unselectedItemColor: Colors.grey[600],
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
