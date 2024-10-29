import 'package:isar/isar.dart';
import 'package:music_bloc/features/song/domain/entities/song.dart';
import 'package:music_bloc/features/song/domain/repos/song_repo.dart';

class IsarSongRepo implements SongRepo {
  final Isar isar;

  IsarSongRepo({required this.isar});

  @override
  Future<void> createSong(Song song) async {
    try {
      await isar.writeTxn(() async {
        await isar.songs.put(song);
      });
    } catch (e) {
      throw Exception('Error creating song: $e');
    }
  }

  @override
  Future<void> deleteSong(int songId) async {
    try {
      await isar.writeTxn(() async {
        await isar.songs.delete(songId);
      });
    } catch (e) {
      throw Exception('Error deleting song: $e');
    }
  }

  @override
  Future<List<Song>> fetchAllSongs() async {
    try {
      List<Song> fetchedSongs = await isar.songs.where().findAll();
      return fetchedSongs;
    } catch (e) {
      throw Exception('Error fetching all songs: $e');
    }
  }

  @override
  Future<List<Song>> fetchSongByIds(List<int> songIds) async {
    try {
      List<Song> fetchedSongs = [];
      for (final songId in songIds) {
        final song = await isar.songs.get(songId);
        if (song != null) fetchedSongs.add(song);
      }

      return fetchedSongs;
    } catch (e) {
      throw Exception('Error fetching songs: $e');
    }
  }
}
