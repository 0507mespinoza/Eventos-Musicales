// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:michaelespinozac1/services/servicio_autentificacion.dart';
import 'package:michaelespinozac1/screens/pantalla_login.dart';
import 'package:michaelespinozac1/l10n/app_localizations.dart';
import 'package:michaelespinozac1/services/app_state.dart';
import 'package:michaelespinozac1/services/logica_productos.dart';
import 'package:michaelespinozac1/services/sevicios_pedidos.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar servicios
  final servicioAuth = ServicioAutenticacion();
  servicioAuth.inicializarMusica(); // Inicializar música
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
        ChangeNotifierProvider(create: (_) => LogicaProductos.instance),        ChangeNotifierProvider(create: (_) => ServicioPedidos.instance),      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        return MaterialApp(
          title: 'Tu App',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          locale: appState.locale,
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            Locale('es'),
            Locale('en'),
          ],
          home: const PantallaLogin(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}