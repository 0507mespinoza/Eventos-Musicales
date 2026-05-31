import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:michaelespinozac1/l10n/app_localizations.dart';
import 'package:michaelespinozac1/model/productos.dart';
import 'package:michaelespinozac1/services/evento_localizado_helper.dart';

class PaginaDetalleEvento extends StatefulWidget {
  final EntradaConcierto producto;

  const PaginaDetalleEvento({super.key, required this.producto});

  @override
  State<PaginaDetalleEvento> createState() => _PaginaDetalleEventoState();
}

class _PaginaDetalleEventoState extends State<PaginaDetalleEvento> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  double _volume = 0.5;
  bool _reproduciendo = false;
  int _indiceAudioSeleccionado = 0;

  List<Map<String, String>> get _audios {
    final id = widget.producto.id.toString();
    debugPrint('ID recibido en PaginaDetalleEvento: '
      '[32m$id[0m'); // Color verde para visibilidad
    if (id == '1') {
      // Rocanrola
      return [
        {
          'titulo': 'Taylor Swift - Shake It Off',
          'url': 'assets/audio/Taylor Swift - Shake It Off.mp3',},
        {
          'titulo': 'KASE.O - REPARTIENDO ARTE',
          'url': 'assets/audio/Rocanrola_KASEO_REPARTIENDO_ARTE.mp3',
        },
        {
          'titulo': 'Nach - Destino',
          'url': 'assets/audio/Rocanrola_Nach_Destino.mp3',
        },
      ];
    } else if (id == '2') {
      // Coachella
      return [
        {
          'titulo': 'Anyma, LISA - Bad Angel',
          'url': 'assets/audio/Coachella_Anyma_Bad_Angel.mp3',
        },
        {
          'titulo': 'KAROL G - Si Antes Te Hubiera Conocido',
          'url': 'assets/audio/Coachella_KAROL_G_Si_Antes_Te_Hubiera_Conocido.mp3',
        },
        {
          'titulo': 'Sabrina Carpenter - Manchild',
          'url': 'assets/audio/Coachella_Sabrina_Carpenter_Manchild.mp3',
        },
      ];
    } else if (id == '3') {
      // Taylor Swift
      return [
        {
          'titulo': 'Taylor Swift - Shake It Off',
          'url': 'assets/audio/Taylor Swift - Shake It Off.mp3',
        },
        {
          'titulo': 'Taylor Swift - The Fate of Ophelia',
          'url': 'assets/audio/Taylor Swift - The Fate of Ophelia (Official Music Video).mp3',
        },
        {
          'titulo': 'Taylor Swift - Back to the Start',
          'url': 'assets/audio/Taylor Swift - Back to the Start (Heartfelt Storytelling Pop 2026) _ Music Lyric Video 2026.mp3',
        },
      ];
    } else {
      // Otros eventos sin audio
      return [];
    }
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

    // Reproducir automáticamente el primer audio si existe
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_audios.isNotEmpty) {
        await _reproducirAudio();
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.stop();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _reproducirAudio() async {
    final url = _audios[_indiceAudioSeleccionado]['url']!;
    try {
      if (url.startsWith('assets/')) {
        if (kIsWeb) {
          debugPrint('Web: reproduciendo asset como URL: $url');
          await _audioPlayer.play(UrlSource(url), volume: _volume);
        } else {
          final fileName = url.replaceFirst('assets/', '');
          debugPrint('No web: reproduciendo asset como AssetSource: assets/$fileName');
          await _audioPlayer.play(AssetSource(fileName), volume: _volume);
        }
      } else {
        debugPrint('Intentando reproducir URL: $url');
        await _audioPlayer.play(UrlSource(url), volume: _volume);
      }
    } catch (e) {
      debugPrint('Error al reproducir audio: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo reproducir el audio: $e')),
        );
      }
    }
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

  Future<void> _cambiarPista(int indice) async {
    if (indice < 0 || indice >= _audios.length) return;
    setState(() {
      _indiceAudioSeleccionado = indice;
      _position = Duration.zero;
      _duration = Duration.zero;
      _reproduciendo = false;
    });
    await _audioPlayer.stop();
    await _reproducirAudio();
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
    final producto = EventoLocalizadoHelper.localizeProducto(widget.producto, localization);

    // Construcción dinámica de los widgets de detalle
    List<Widget> detalleWidgets = [];
    if (producto.imagen.isNotEmpty) {
      detalleWidgets.add(
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: producto.imagen.startsWith('assets/')
              ? Image.asset(
                  producto.imagen,
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
                  producto.imagen,
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
        ),
      );
    } else {
      detalleWidgets.add(
        Container(
          height: 220,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(child: Icon(Icons.event, size: 56, color: Colors.grey)),
        ),
      );
    }
    detalleWidgets.addAll([
      const SizedBox(height: 16),
      Text(
        producto.nombre,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 10),
      Wrap(
        spacing: 12,
        runSpacing: 8,
        children: [
          _buildInfoChip('${localization.artist}: ${producto.artista}'),
          _buildInfoChip('${localization.date}: ${producto.fecha}'),
          _buildInfoChip('${localization.place}: ${producto.lugar}'),
          _buildInfoChip('${localization.price}: €${producto.precio.toStringAsFixed(2)}'),
          _buildInfoChip('${localization.stock}: ${producto.stock}'),
        ],
      ),
      const SizedBox(height: 20),
      Text(
        localization.description,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 8),
      Text(
        producto.descripcion,
        style: const TextStyle(fontSize: 15, color: Colors.black87),
      ),
      const SizedBox(height: 24),
    ]);
    // Solo mostrar controles de audio si hay audios
    if (_audios.isNotEmpty) {
      detalleWidgets.addAll([
        Text(
          localization.audioControls,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DropdownButtonFormField<int>(
                  value: _indiceAudioSeleccionado < _audios.length ? _indiceAudioSeleccionado : 0,
                  decoration: InputDecoration(labelText: localization.track),
                  items: List.generate(_audios.length, (index) {
                    final titulo = _audios[index]['titulo'] ?? 'Audio';
                    return DropdownMenuItem<int>(
                      value: index,
                      child: Text(titulo),
                    );
                  }),
                  onChanged: (value) async {
                    if (value != null) {
                      await _cambiarPista(value);
                    }
                  },
                ),
                const SizedBox(height: 16),
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
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(onPressed: () => _avanzarRetroceder(-10), icon: const Icon(Icons.replay_10)),
                    // ...existing code...
                  ],
                ),
              ],
            ),
          ),
        ),
      ]);
    } else {
      detalleWidgets.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            'No hay audios disponibles para este evento (id: [31m${widget.producto.id}[0m)',
            style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(localization.eventDetails),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: detalleWidgets,
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
