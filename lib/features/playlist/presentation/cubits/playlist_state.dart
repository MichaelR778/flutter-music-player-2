import 'package:music_bloc/features/playlist/domain/entities/playlist.dart';

abstract class PlaylistState {}

// initial state
class PlaylistInitial extends PlaylistState {}

// loading state
class PlaylistLoading extends PlaylistState {}

// error state
class PlaylistError extends PlaylistState {
  final String message;
  PlaylistError({required this.message});
}

// all playlists loaded
class PlaylistLoaded extends PlaylistState {
  final List<Playlist> playlists;
  PlaylistLoaded({required this.playlists});
}

// playlist deleted
class PlaylistDeleted extends PlaylistState {
  final int playlistId;
  PlaylistDeleted({required this.playlistId});
}
