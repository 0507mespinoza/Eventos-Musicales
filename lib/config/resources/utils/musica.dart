import 'package:audioplayers/audioplayers.dart';

class Music {

  static final AudioPlayer audioPlayer = AudioPlayer();

  static Future<void> playMusic() async{
    try{
      await audioPlayer.play(AssetSource("assets/music/musica.mp3"));
    }catch (e){
      print("Erroy al reproducirce: $e");
    }
  }

  static Future <void> pauseMusic() async{
    await audioPlayer.pause();
  }
}
