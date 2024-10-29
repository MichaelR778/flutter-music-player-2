import 'package:music_bloc/features/song/domain/entities/song.dart';

abstract class AudioPlayerState {}

// stopped (not playing)
class AudioPlayerStopped extends AudioPlayerState {}

// playing
class AudioPlayerPlaying extends AudioPlayerState {
  final Song song;
  final Duration currentDuration;
  final Duration totalDuration;
  AudioPlayerPlaying({
    required this.song,
    required this.currentDuration,
    required this.totalDuration,
  });
}

// paused
class AudioPlayerPaused extends AudioPlayerState {
  final Song song;
  AudioPlayerPaused({required this.song});
}
