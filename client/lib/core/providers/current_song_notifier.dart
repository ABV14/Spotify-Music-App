import 'package:client/features/home/model/song_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:just_audio/just_audio.dart';
part 'current_song_notifier.g.dart';

@riverpod
class CurrentSongNotifier extends _$CurrentSongNotifier{
AudioPlayer? audioPlayer;
bool isPlaying = false;
@override
  SongModel? build(){
    audioPlayer = AudioPlayer();
    return null;
  }

void updateSong(SongModel song) async{
  // await audioPlayer!.stop(); 
  final audioSource = AudioSource.uri(Uri.parse(song.songUrl));
  // await audioPlayer!.setUrl(song.songUrl);
  await audioPlayer!.setAudioSource(audioSource);
  // audioPlayer?.positionStream;

  audioPlayer!.playerStateStream.listen((state){
    if(state.processingState == ProcessingState.completed){
      audioPlayer!.seek(Duration.zero);
      audioPlayer!.pause();
      isPlaying = false;
      this.state = this.state?.copyWith(hexcode: this.state?.hexcode);
    }
  });

   audioPlayer!.play();
   isPlaying = true;
   state = song;
}

void playPause(){
  if(isPlaying){
    audioPlayer?.pause();
  }
  else{
    audioPlayer?.play();
  }
  isPlaying = !isPlaying;
  state = state?.copyWith(hexcode: state?.hexcode);
}

void seek(double val){
  audioPlayer!.seek(Duration(milliseconds: (val * audioPlayer!.duration!.inMilliseconds).toInt()));
}

}