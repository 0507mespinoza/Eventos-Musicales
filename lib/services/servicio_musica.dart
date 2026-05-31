import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class ServicioMusica {
  static final ServicioMusica _instancia = ServicioMusica._internal();
  factory ServicioMusica() => _instancia;
  ServicioMusica._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _estaReproduciendo = false;
  bool _musicaActivada = true;

  String _normalizarRutaAsset(String ruta) {
    // audioplayers AssetSource requiere ruta relativa al bundle, sin prefijo "assets/"
    if (ruta.startsWith('assets/')) {
      return ruta.substring('assets/'.length);
    }
    return ruta;
  }

  // Inicializar el servicio
  void inicializar() async {
    // Configurar notificaciones de estado
    _audioPlayer.onPlayerStateChanged.listen((state) {
      _estaReproduciendo = state == PlayerState.playing;
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      // Repetir la música cuando termine (sin especificar ruta para usar default)
      _reproducirMusica();
    });
  }

  // Reproducir música de fondo (archivo local o URL)
  Future<void> _reproducirMusica({String? rutaArchivo}) async {
    if (!_musicaActivada) return;

    try {
      // Si no se proporciona ruta, usar archivo por defecto
      final ruta = _normalizarRutaAsset(rutaArchivo ?? 'audio/login_music.mp3');
      
      // Reproducir desde archivo local (assets)
      await _audioPlayer.play(AssetSource(ruta));
      
      // Configurar volumen (0.0 a 1.0)
      await _audioPlayer.setVolume(0.3);
      
      // Reproducir en loop
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      
      _estaReproduciendo = true;
      debugPrint('🎵 Música iniciada: $ruta');
    } catch (e) {
      debugPrint('❌ Error al reproducir música: $e');
    }
  }
  
  // Iniciar música (llamar al iniciar sesión)
  Future<void> iniciarMusica({String? rutaArchivo}) async {
    _musicaActivada = true;
    await _reproducirMusica(rutaArchivo: rutaArchivo);
  }

  // Detener música (llamar al cerrar sesión)
  Future<void> detenerMusica() async {
    _musicaActivada = false;
    await _audioPlayer.stop();
    _estaReproduciendo = false;
    debugPrint('🎵 Música detenida');
  }

  // Pausar música temporalmente
  Future<void> pausarMusica() async {
    await _audioPlayer.pause();
    _estaReproduciendo = false;
    debugPrint('🎵 Música pausada');
  }

  // Reanudar música
  Future<void> reanudarMusica() async {
    if (_musicaActivada) {
      await _audioPlayer.resume();
      _estaReproduciendo = true;
      debugPrint('🎵 Música reanudada');
    }
  }

  // Controlar volumen
  Future<void> setVolumen(double volumen) async {
    await _audioPlayer.setVolume(volumen.clamp(0.0, 1.0));
    debugPrint('🎵 Volumen ajustado a: $volumen');
  }

  // Alternar música (activar/desactivar)
  Future<void> alternarMusica() async {
    _musicaActivada = !_musicaActivada;
    if (_musicaActivada) {
      await _reproducirMusica();
      debugPrint('🎵 Música activada');
    } else {
      await _audioPlayer.stop();
      debugPrint('🎵 Música desactivada');
    }
  }

  // Getters
  bool get estaReproduciendo => _estaReproduciendo;
  bool get musicaActivada => _musicaActivada;

  // Disposer
  void dispose() {
    _audioPlayer.dispose();
  }
}