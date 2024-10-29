import 'package:music_bloc/features/song/domain/entities/song.dart';

abstract class SongState {}

// initial state
class SongInitial extends SongState {}

// loading state
class SongLoading extends SongState {}

// error state
class SongError extends SongState {
  final String message;
  SongError({required this.message});
}

// song loaded
class SongLoaded extends SongState {
  final List<Song> songs;
  SongLoaded({required this.songs});
}

// song deleted
class SongDeleted extends SongState {
  final int songId;
  SongDeleted({required this.songId});
}
