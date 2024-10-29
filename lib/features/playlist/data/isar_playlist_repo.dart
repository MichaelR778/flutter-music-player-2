import 'package:isar/isar.dart';
import 'package:music_bloc/features/playlist/domain/entities/playlist.dart';
import 'package:music_bloc/features/playlist/domain/repos/playlist_repo.dart';

class IsarPlaylistRepo implements PlaylistRepo {
  final Isar isar;

  IsarPlaylistRepo({required this.isar});

  @override
  Future<void> createPlaylist(Playlist playlist) async {
    try {
      await isar.writeTxn(() async {
        await isar.playlists.put(playlist);
      });
    } catch (e) {
      throw Exception('Error creating playlist: $e');
    }
  }

  @override
  Future<void> deletePlaylist(int playlistId) async {
    try {
      await isar.writeTxn(() async {
        await isar.playlists.delete(playlistId);
      });
    } catch (e) {
      throw Exception('Error deleting playlist: $e');
    }
  }

  @override
  Future<List<Playlist>> fetchAllPlaylists() async {
    try {
      List<Playlist> fetchedPlaylists = await isar.playlists.where().findAll();
      return fetchedPlaylists;
    } catch (e) {
      throw Exception('Error fetching all playlists: $e');
    }
  }

  @override
  Future<void> playlistAddSong(int playlistId, int songId) async {
    try {
      final playlist = await isar.playlists.get(playlistId);
      if (playlist == null) throw Exception('Playlist not found');

      // song already in playlist
      if (playlist.songIds.contains(songId)) {
        throw Exception('Song already in playlist');
      }

      // add song id to playlist
      List<int> songIds = List<int>.from(playlist.songIds);
      songIds.add(songId);
      playlist.songIds = songIds;

      // save updated playlist
      await isar.writeTxn(() async {
        await isar.playlists.put(playlist);
      });
    } catch (e) {
      throw Exception('Error adding song to playlist: $e');
    }
  }

  @override
  Future<void> playlistDeleteSong(int playlistId, int songId) async {
    try {
      final playlist = await isar.playlists.get(playlistId);
      if (playlist == null) throw Exception('Playlist not found');

      // song not in playlist
      if (!playlist.songIds.contains(songId)) throw Exception('Song not found');

      // delete song from playlist
      List<int> songIds = List<int>.from(playlist.songIds);
      songIds.remove(songId);
      playlist.songIds = songIds;

      // save updated playlist
      await isar.writeTxn(() async {
        await isar.playlists.put(playlist);
      });
    } catch (e) {
      throw Exception('Error deleting song from playlist: $e');
    }
  }

  @override
  Future<Playlist> fetchPlaylist(int playlistId) async {
    try {
      final fetchedPlaylist = await isar.playlists.get(playlistId);
      if (fetchedPlaylist == null) throw Exception('Playlist not found');

      return fetchedPlaylist;
    } catch (e) {
      throw Exception('Error fetching a playlist: $e');
    }
  }
}
