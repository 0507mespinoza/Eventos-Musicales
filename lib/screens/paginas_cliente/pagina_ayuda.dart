import 'package:flutter/material.dart';
import 'package:michaelespinozac1/l10n/app_localizations.dart';

class PaginaAyuda extends StatelessWidget {
  const PaginaAyuda({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localization.helpTitle),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              localization.helpDescription,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 24),
            _buildSection(
              context,
              title: localization.orders,
              content: localization.helpOrders,
            ),
            const SizedBox(height: 16),
            _buildSection(
              context,
              title: localization.profile,
              content: localization.helpProfile,
            ),
            const SizedBox(height: 16),
            _buildSection(
              context,
              title: localization.contact,
              content: localization.helpContact,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, {required String title, required String content}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: const TextStyle(fontSize: 14, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
