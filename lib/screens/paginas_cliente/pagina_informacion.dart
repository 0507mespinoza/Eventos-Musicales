import 'package:flutter/material.dart';
import 'package:michaelespinozac1/model/productos.dart';
import 'package:michaelespinozac1/l10n/app_localizations.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:michaelespinozac1/services/evento_localizado_helper.dart';
import 'package:michaelespinozac1/services/servicio_musica.dart';

class PaginaInformacion extends StatefulWidget {
  final EntradaConcierto evento;
  const PaginaInformacion({super.key, required this.evento});

  @override
  State<PaginaInformacion> createState() => _PaginaInformacionState();
}

class _PaginaInformacionState extends State<PaginaInformacion> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final ServicioMusica _servicioMusica = ServicioMusica();
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  double _volume = 0.5;
  bool _reproduciendo = false;
  int _indiceAudioSeleccionado = 0;
  bool _debeReanudarMusicaApp = false;
  bool _salidaGestionada = false;

  // Mínimo 3 pistas precargadas por evento
  List<Map<String, String>> _audiosLocalizados(
    AppLocalizations localization,
    String eventoId,
  ) {
    List<Map<String, String>> pistas;
    switch (eventoId) {
      case '1':
        pistas = [
          {
            'titulo': localization.translate('BAD_ANGEL'),
            'url': 'assets/audio/Coachella_Anyma_Bad_Angel.mp3',
          },
          {
            'titulo': localization.translate('SI_ANTES_TE_HUBIERA_CONOCIDO'),
            'url': 'assets/audio/Coachella_KAROL_G_Si_Antes_Te_Hubiera_Conocido.mp3',
          },
          {
            'titulo': localization.translate('MANCHILD'),
            'url': 'assets/audio/Coachella_Sabrina_Carpenter_Manchild.mp3',
          },
        ];
        break;
      case '2':
        pistas = [
          {
            'titulo': localization.translate('HIJOS_DE_LA_RUINA'),
            'url': 'assets/audio/Rocanrola_HIJOS_DE_LA_RUINA_Hijos_de_la_ruina.mp3',
          },
          {
            'titulo': localization.translate('DESTINO'),
            'url': 'assets/audio/Rocanrola_Nach_Destino.mp3',
          },
          {
            'titulo': localization.translate('REPARTIENDO_ARTE'),
            'url': 'assets/audio/Rocanrola_KASEO_REPARTIENDO_ARTE.mp3',
          },
        ];
        break;
      case '3':
        pistas = [
          {
            'titulo': localization.translate('BACK_TO_THE_START'),
            'url': 'assets/audio/Taylor Swift - Back to the Start (Heartfelt Storytelling Pop 2026) _ Music Lyric Video 2026.mp3',
          },
          {
            'titulo': localization.translate('SHAKE_IT_OFF'),
            'url': 'assets/audio/Taylor Swift - Shake It Off.mp3',
          },
          {
            'titulo': localization.translate('THE_FATE_OF_OPHELIA'),
            'url': 'assets/audio/Taylor Swift - The Fate of Ophelia (Official Music Video).mp3',
          },
        ];
        break;
      default:
        pistas = [
          {
            'titulo': localization.translate('audio_track_1'),
            'url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
          },
          {
            'titulo': localization.translate('audio_track_2'),
            'url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
          },
          {
            'titulo': localization.translate('audio_track_3'),
            'url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
          },
        ];
    }

    return pistas;
  }

  @override
  void initState() {
    super.initState();
    _audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        _reproduciendo = state == PlayerState.playing;
      });
    });
    _audioPlayer.onDurationChanged.listen((duration) {
      setState(() {
        _duration = duration;
      });
    });
    _audioPlayer.onPositionChanged.listen((position) {
      setState(() {
        _position = position;
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _inicializarAudioAlEntrar();
    });
  }

  Future<void> _inicializarAudioAlEntrar() async {
    if (!mounted) return;
    final localization = AppLocalizations.of(context);

    // Al entrar en información: pausamos música global y reproducimos pista 1.
    _debeReanudarMusicaApp = _servicioMusica.musicaActivada;
    await _servicioMusica.pausarMusica();

    setState(() {
      _indiceAudioSeleccionado = 0;
      _position = Duration.zero;
      _duration = Duration.zero;
    });

    await _reproducirAudio(localization, widget.evento.id);
  }

  @override
  void didUpdateWidget(covariant PaginaInformacion oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.evento.id != widget.evento.id) {
      _detenerAudio();
      setState(() {
        _indiceAudioSeleccionado = 0;
        _duration = Duration.zero;
        _position = Duration.zero;
      });

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!mounted) return;
        final localization = AppLocalizations.of(context);
        await _reproducirAudio(localization, widget.evento.id);
      });
    }
  }

  Future<void> _gestionarSalidaInformacion() async {
    if (_salidaGestionada) return;
    _salidaGestionada = true;

    await _audioPlayer.stop();

    if (mounted) {
      setState(() {
        _position = Duration.zero;
      });
    }

    // Al salir de información: reanudamos música global de la app.
    if (_debeReanudarMusicaApp && _servicioMusica.musicaActivada) {
      await _servicioMusica.reanudarMusica();
    }
  }

  @override
  void deactivate() {
    // Refuerzo: si esta vista deja de estar activa, detenemos su audio y
    // restauramos música global.
    _gestionarSalidaInformacion();
    super.deactivate();
  }

  @override
  void dispose() {
    _gestionarSalidaInformacion();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _reproducirAudio(
    AppLocalizations localization,
    String eventoId,
  ) async {
    final audios = _audiosLocalizados(localization, eventoId);
    final ruta = audios[_indiceAudioSeleccionado]['url']!;
    await _audioPlayer.play(_crearFuenteAudio(ruta), volume: _volume);
  }

  Source _crearFuenteAudio(String ruta) {
    if (ruta.startsWith('http://') || ruta.startsWith('https://')) {
      return UrlSource(ruta);
    }

    final rutaAsset = ruta.startsWith('assets/')
        ? ruta.replaceFirst('assets/', '')
        : ruta;
    return AssetSource(rutaAsset);
  }

  Future<void> _pausarAudio() async {
    await _audioPlayer.pause();
  }

  Future<void> _detenerAudio() async {
    await _audioPlayer.stop();
    setState(() {
      _position = Duration.zero;
    });
  }

  Future<void> _cambiarPista(
    int indice,
    AppLocalizations localization,
    String eventoId,
  ) async {
    final audios = _audiosLocalizados(localization, eventoId);
    if (indice < 0 || indice >= audios.length) return;
    setState(() {
      _indiceAudioSeleccionado = indice;
      _position = Duration.zero;
      _duration = Duration.zero;
      _reproduciendo = false;
    });
    await _audioPlayer.stop();
    await _reproducirAudio(localization, eventoId);
  }

  Future<void> _pistaAnterior(
    AppLocalizations localization,
    String eventoId,
  ) async {
    final audios = _audiosLocalizados(localization, eventoId);
    if (audios.isEmpty) return;
    final indiceAnterior =
        (_indiceAudioSeleccionado - 1 + audios.length) % audios.length;
    await _cambiarPista(indiceAnterior, localization, eventoId);
  }

  Future<void> _pistaSiguiente(
    AppLocalizations localization,
    String eventoId,
  ) async {
    final audios = _audiosLocalizados(localization, eventoId);
    if (audios.isEmpty) return;
    final indiceSiguiente = (_indiceAudioSeleccionado + 1) % audios.length;
    await _cambiarPista(indiceSiguiente, localization, eventoId);
  }

  Future<void> _avanzarRetroceder(int segundos) async {
    final nuevaPosicion = _position + Duration(seconds: segundos);
    final tiempo = nuevaPosicion.inMilliseconds.clamp(0, _duration.inMilliseconds);
    await _audioPlayer.seek(Duration(milliseconds: tiempo));
  }

  String _formatearDuracion(Duration duracion) {
    String dosDigitos(int n) => n.toString().padLeft(2, '0');
    final minutos = dosDigitos(duracion.inMinutes.remainder(60));
    final segundos = dosDigitos(duracion.inSeconds.remainder(60));
    return '$minutos:$segundos';
  }


  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final evento = EventoLocalizadoHelper.localizeProducto(widget.evento, localization);
    final audios = _audiosLocalizados(localization, evento.id);
    return WillPopScope(
      onWillPop: () async {
        await _gestionarSalidaInformacion();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(localization.information),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (evento.imagen.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: evento.imagen.startsWith('assets/')
                      ? Image.asset(
                          evento.imagen,
                          fit: BoxFit.cover,
                          height: 220,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 220,
                              color: Colors.grey[300],
                              child: const Center(child: Icon(Icons.image_not_supported, size: 48)),
                            );
                          },
                        )
                      : Image.network(
                          evento.imagen,
                          fit: BoxFit.cover,
                          height: 220,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 220,
                              color: Colors.grey[300],
                              child: const Center(child: Icon(Icons.image_not_supported, size: 48)),
                            );
                          },
                        ),
                )
              else
                Container(
                  height: 220,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(child: Icon(Icons.event, size: 56, color: Colors.grey)),
                ),
              const SizedBox(height: 12),
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        audios[_indiceAudioSeleccionado]['titulo']!,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new),
                            tooltip: localization.skipBackward,
                            onPressed: () => _pistaAnterior(localization, evento.id),
                          ),
                          ElevatedButton(
                            onPressed: _reproduciendo
                                ? _pausarAudio
                                : () => _reproducirAudio(localization, evento.id),
                            child: Text(_reproduciendo ? localization.pause : localization.play),
                          ),
                          IconButton(
                            icon: const Icon(Icons.arrow_forward_ios),
                            tooltip: localization.skipForward,
                            onPressed: () => _pistaSiguiente(localization, evento.id),
                          ),
                          IconButton(
                            icon: const Icon(Icons.stop),
                            onPressed: _detenerAudio,
                            tooltip: localization.stopAudio,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text('${localization.volume}: ${(_volume * 100).round()}%'),
                      Slider(
                        min: 0,
                        max: 1,
                        value: _volume,
                        onChanged: (value) async {
                          setState(() {
                            _volume = value;
                          });
                          await _audioPlayer.setVolume(_volume);
                        },
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_formatearDuracion(_position)),
                          Text(_formatearDuracion(_duration)),
                        ],
                      ),
                      Slider(
                        min: 0,
                        max: _duration.inMilliseconds > 0 ? _duration.inMilliseconds.toDouble() : 1.0,
                        value: _position.inMilliseconds.toDouble().clamp(0, _duration.inMilliseconds > 0 ? _duration.inMilliseconds.toDouble() : 1.0),
                        onChanged: (value) async {
                          final nuevaDuracion = Duration(milliseconds: value.toInt());
                          await _audioPlayer.seek(nuevaDuracion);
                        },
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton.icon(
                            onPressed: () => _avanzarRetroceder(-10),
                            icon: const Icon(Icons.replay),
                            label: const Text('-10s'),
                          ),
                          const SizedBox(width: 12),
                          TextButton.icon(
                            onPressed: () => _avanzarRetroceder(10),
                            icon: const Icon(Icons.forward),
                            label: const Text('+10s'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                evento.nombre,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 12,
                runSpacing: 8,
                children: [
                  _buildInfoChip('${localization.artist}: ${evento.artista}'),
                  _buildInfoChip('${localization.date}: ${evento.fecha}'),
                  _buildInfoChip('${localization.place}: ${evento.lugar}'),
                  _buildInfoChip('${localization.type}: ${evento.tipo}'),
                  _buildInfoChip('${localization.price}: €${evento.precio.toStringAsFixed(2)}'),
                  _buildInfoChip('${localization.stock}: ${evento.stock}'),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                localization.description,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                evento.descripcion,
                style: const TextStyle(fontSize: 15, color: Colors.black87),
              ),
              const SizedBox(height: 16),
              Text(
                localization.translate('synopsis'),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                '${evento.nombre} - ${evento.artista}. ${localization.date}: ${evento.fecha}. ${localization.place}: ${evento.lugar}.',
                style: const TextStyle(fontSize: 15, color: Colors.black87),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(String label) {
    return Chip(
      label: Text(label),
      backgroundColor: Colors.blue[50],
    );
  }
}