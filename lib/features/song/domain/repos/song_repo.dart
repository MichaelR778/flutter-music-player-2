import 'package:music_bloc/features/song/domain/entities/song.dart';

abstract class SongRepo {
  Future<void> createSong(Song song);
  Future<void> deleteSong(int songId);
  Future<List<Song>> fetchAllSongs();
  Future<List<Song>> fetchSongByIds(List<int> songIds);
}
