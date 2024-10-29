import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_bloc/features/audio_player/presentation/cubits/audio_player_state.dart';
import 'package:music_bloc/features/song/domain/entities/song.dart';

class AudioPlayerCubit extends Cubit<AudioPlayerState> {
  // constructor
  AudioPlayerCubit() : super(AudioPlayerStopped()) {
    listenToDuration();
  }

  final List<Song> songs = [];
  int currPlaylistId = -2;
  int currSongIndex = -2;

  /*

  Audio Player

  */

  final AudioPlayer audioPlayer = AudioPlayer();
  Duration currentDuration = Duration.zero;
  Duration totalDuration = Duration.zero;
  bool isPlaying = false;

  // reset to initial
  Future<void> reset() async {
    await audioPlayer.stop();
    isPlaying = false;
    songs.clear();
    currPlaylistId = -2;
    currSongIndex = -2;
    emit(AudioPlayerStopped());
  }

  // play song
  void play() async {
    final String path = songs[currSongIndex].audioPath;
    await audioPlayer.stop();
    await audioPlayer.play(DeviceFileSource(path));
    isPlaying = true;
    emit(AudioPlayerPlaying(
      song: songs[currSongIndex],
      currentDuration: currentDuration,
      totalDuration: totalDuration,
    ));
  }

  void playSong(int index) {
    currSongIndex = index;
    play();
  }

  // pause song
  void pause() async {
    await audioPlayer.pause();
    isPlaying = false;
    emit(AudioPlayerPaused(song: songs[currSongIndex]));
  }

  // resume song
  void resume() async {
    await audioPlayer.resume();
    isPlaying = true;
    emit(AudioPlayerPlaying(
      song: songs[currSongIndex],
      currentDuration: currentDuration,
      totalDuration: totalDuration,
    ));
  }

  // pause or resume
  void toggle() async {
    if (isPlaying) {
      pause();
    } else {
      resume();
    }
  }

  // seek to specific duration
  void seek(Duration position) async {
    await audioPlayer.seek(position);
  }

  // play next song
  void playNextSong() {
    playSong((currSongIndex + 1) % songs.length);
  }

  // play prev song
  void playPreviousSong() async {
    // if not in the beginning of curr song, go back to beginning
    if (currentDuration.inSeconds > 2) {
      seek(Duration.zero);
    } else {
      playSong((currSongIndex - 1) % songs.length);
    }
  }

  // listen to duration
  void listenToDuration() {
    // listen to total duration
    audioPlayer.onDurationChanged.listen((newDuration) {
      totalDuration = newDuration;
      emit(AudioPlayerPlaying(
        song: songs[currSongIndex],
        currentDuration: currentDuration,
        totalDuration: totalDuration,
      ));
    });

    // listen to curr duration
    audioPlayer.onPositionChanged.listen((newPosition) {
      currentDuration = newPosition;
      emit(AudioPlayerPlaying(
        song: songs[currSongIndex],
        currentDuration: currentDuration,
        totalDuration: totalDuration,
      ));
    });

    // listen for song completion
    audioPlayer.onPlayerComplete.listen((event) {
      playNextSong();
    });
  }

  /*

  audio play management

  */

  // update playlist for audio player
  void updatePlaylist(int playlistId, List<Song> songs) {
    currPlaylistId = playlistId;
    this.songs.clear();
    this.songs.addAll(songs);
  }

  // update if song added or deleted to curr playlist
  void updateChange(int playlistId, List<Song> songs) {
    // the playlist that's changed is not curr playlist
    if (playlistId != currPlaylistId) return;

    // new playlist is empty => last song deleted
    if (songs.isEmpty) {
      reset();
      return;
    }

    // curr song
    final currSong = this.songs[currSongIndex];

    // update curr playlist
    updatePlaylist(playlistId, songs);

    // if song was deleted, skip deleted song
    if (!songs.contains(currSong)) {
      playSong(currSongIndex % songs.length);
    }
  }

  // if curr playlist is deleted
  // void cascadeDeletePlaylist(List<int> playlistIds) {
  //   if (!playlistIds.contains(currPlaylistId)) reset();
  // }
}
