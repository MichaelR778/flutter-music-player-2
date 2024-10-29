import 'package:music_bloc/features/song/domain/entities/song.dart';

abstract class PlaylistsongState {}

// initial state
class PlaylistsongInitial extends PlaylistsongState {}

// loading state
// class PlaylistsongLoading extends PlaylistsongState {}

// error state
class PlaylistsongError extends PlaylistsongState {
  final String message;
  PlaylistsongError({required this.message});
}

// playlist song loaded
class PlaylistsongLoaded extends PlaylistsongState {
  final int playlistId;
  final List<Song> songs;
  PlaylistsongLoaded({required this.playlistId, required this.songs});
}
