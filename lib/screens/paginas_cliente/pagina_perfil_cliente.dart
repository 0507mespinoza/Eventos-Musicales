import 'package:flutter/material.dart';
import 'package:michaelespinozac1/services/servicio_autentificacion.dart';
import 'package:michaelespinozac1/l10n/app_localizations.dart';
import 'package:michaelespinozac1/screens/paginas_cliente/pagina_ayuda.dart';
import 'package:michaelespinozac1/screens/paginas_cliente/pagina_contacto.dart';
import 'package:michaelespinozac1/screens/editar_perfil.dart';

class PaginaPerfilCliente extends StatelessWidget {
  final ServicioAutenticacion _servicioAuth = ServicioAutenticacion();

  PaginaPerfilCliente({super.key});

  @override
  Widget build(BuildContext context) {
    final usuario = _servicioAuth.usuarioActual;
    final localization = AppLocalizations.of(context);

    return Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Avatar
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue,
              child: Text(
                (usuario?.nombre ?? 'U')[0].toUpperCase(),
                style: TextStyle(fontSize: 40, color: Colors.white),
              ),
            ),
            SizedBox(height: 16),
            // Nombre del usuario
            Text(
              usuario?.nombre ?? localization.profile,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            // Información del usuario
            SizedBox(height: 24),
            Text(
              localization.personalInformation,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${localization.age}: ${usuario != null ? usuario.edad.toString() : localization.notAvailable}',
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '${localization.birthplace}: ${usuario != null && usuario.lugarNacimiento.isNotEmpty ? usuario.lugarNacimiento : localization.notAvailable}',
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '${localization.treatment}: ${usuario?.trato ?? localization.notAvailable}',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            // Botones
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _irEditar(context),
                icon: Icon(Icons.edit),
                label: Text(localization.editProfile),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _irContacto(context),
                icon: Icon(Icons.contact_mail),
                label: Text(localization.contact),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _irAyuda(context),
                icon: Icon(Icons.help_outline),
                label: Text(localization.help),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
    );
  }

  void _irEditar(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EditarPerfil(),
      ),
    );
  }

  void _irContacto(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaginaContacto(),
      ),
    );
  }

  void _irAyuda(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaginaAyuda(),
      ),
    );
  }
}

