import 'package:flutter/material.dart';
import 'package:michaelespinozac1/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class PaginaContacto extends StatelessWidget {
  const PaginaContacto({super.key});

  Future<void> _llamar(String numero) async {
    final Uri url = Uri(scheme: 'tel', path: numero);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  Future<void> _enviarEmail(String email) async {
    final Uri url = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  Future<void> _abrirWeb(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _abrirMaps() async {
    // Coordenadas de ejemplo (Madrid, España)
    const lat = 40.4168;
    const lng = -3.7038;
    final Uri url = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);

    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            Text(
              localization.contactInfo,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            // Teléfono
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.phone, color: Colors.green),
                title: Text(localization.phone),
                subtitle: const Text('+34 900 123 456'),
                trailing: IconButton(
                  icon: const Icon(Icons.call),
                  onPressed: () => _llamar('+34900123456'),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Email
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.email, color: Colors.blue),
                title: Text(localization.email),
                subtitle: const Text('contacto@eventosapp.com'),
                trailing: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => _enviarEmail('contacto@eventosapp.com'),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Sitio Web
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.web, color: Colors.orange),
                title: Text(localization.website),
                subtitle: const Text('www.eventosapp.com'),
                trailing: IconButton(
                  icon: const Icon(Icons.open_in_browser),
                  onPressed: () => _abrirWeb('https://www.eventosapp.com'),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Ubicación
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.location_on, color: Colors.red),
                title: Text(localization.place),
                subtitle: Text(localization.madridSpain),
                trailing: IconButton(
                  icon: const Icon(Icons.map),
                  onPressed: _abrirMaps,
                ),
              ),
            ),
            const SizedBox(height: 40),
            Text(
              localization.contactMessage,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
    );
  }
}