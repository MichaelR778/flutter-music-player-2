import 'package:music_bloc/features/playlist/domain/entities/playlist.dart';

abstract class PlaylistRepo {
  Future<void> createPlaylist(Playlist playlist);
  Future<void> deletePlaylist(int playlistId);
  Future<List<Playlist>> fetchAllPlaylists();
  Future<void> playlistAddSong(int playlistId, int songId);
  Future<void> playlistDeleteSong(int playlistId, int songId);
  Future<Playlist> fetchPlaylist(int playlistId);
}
