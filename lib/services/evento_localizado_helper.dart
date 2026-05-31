import 'package:michaelespinozac1/l10n/app_localizations.dart';
import 'package:michaelespinozac1/model/productos.dart';

class EventoLocalizadoHelper {
  static EntradaConcierto localizeProducto(
    EntradaConcierto producto,
    AppLocalizations localization,
  ) {
    return EntradaConcierto(
      id: producto.id,
      nombre: _localizedName(producto.id, localization, producto.nombre),
      descripcion: _localizedDescription(producto.id, localization, producto.descripcion),
      precio: producto.precio,
      stock: producto.stock,
      imagen: producto.imagen,
      artista: _localizedArtist(producto.id, localization, producto.artista),
      fecha: producto.fecha,
      lugar: _localizedPlace(producto.id, localization, producto.lugar),
      tipo: _localizedType(producto.id, localization, producto.tipo),
      estaActivo: producto.estaActivo,
    );
  }

  static Map<String, dynamic> localizeProductoMap(
    Map<String, dynamic> producto,
    AppLocalizations localization,
  ) {
    final productoId = producto['id']?.toString() ?? '';
    final categoria = producto['categoria']?.toString() ?? producto['tipo']?.toString() ?? '';

    return {
      ...producto,
      'nombre': _localizedName(productoId, localization, producto['nombre']?.toString() ?? ''),
      'descripcion': _localizedDescription(
        productoId,
        localization,
        producto['descripcion']?.toString() ?? '',
      ),
      'artista': _localizedArtist(productoId, localization, producto['artista']?.toString() ?? ''),
      'lugar': _localizedPlace(productoId, localization, producto['lugar']?.toString() ?? ''),
      'tipo': _localizedType(productoId, localization, producto['tipo']?.toString() ?? categoria),
      'categoria': _localizedCategory(localization, categoria),
    };
  }

  static String localizedNameFromId(
    String productoId,
    AppLocalizations localization,
    String fallback,
  ) {
    return _localizedName(productoId, localization, fallback);
  }

  static String _localizedName(String productoId, AppLocalizations localization, String fallback) {
    switch (productoId) {
      case '1':
        return localization.translate('event_1_name');
      case '2':
        return localization.translate('event_2_name');
      case '3':
        return localization.translate('event_3_name');
      default:
        return fallback;
    }
  }

  static String _localizedDescription(
    String productoId,
    AppLocalizations localization,
    String fallback,
  ) {
    switch (productoId) {
      case '1':
        return localization.translate('event_1_description');
      case '2':
        return localization.translate('event_2_description');
      case '3':
        return localization.translate('event_3_description');
      default:
        return fallback;
    }
  }

  static String _localizedArtist(String productoId, AppLocalizations localization, String fallback) {
    switch (productoId) {
      case '1':
      case '2':
        return localization.translate('event_various_artists');
      case '3':
        return localization.translate('event_3_artist');
      default:
        return fallback;
    }
  }

  static String _localizedPlace(String productoId, AppLocalizations localization, String fallback) {
    switch (productoId) {
      case '1':
        return localization.translate('event_1_place');
      case '2':
        return localization.translate('event_2_place');
      case '3':
        return localization.translate('event_3_place');
      default:
        return fallback;
    }
  }

  static String _localizedType(String productoId, AppLocalizations localization, String fallback) {
    switch (productoId) {
      case '1':
      case '2':
        return localization.translate('type_festival');
      case '3':
        return localization.translate('type_concert');
      default:
        return _localizedCategory(localization, fallback);
    }
  }

  static String _localizedCategory(AppLocalizations localization, String value) {
    final normalizedValue = value.toLowerCase();
    if (normalizedValue == 'festival') {
      return localization.translate('type_festival');
    }
    if (normalizedValue == 'concierto' || normalizedValue == 'concert') {
      return localization.translate('type_concert');
    }
    return value;
  }
}
