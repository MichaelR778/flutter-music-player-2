import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_bloc/features/song/domain/entities/song.dart';
import 'package:music_bloc/features/song/domain/repos/song_repo.dart';
import 'package:music_bloc/features/song/presentation/cubits/song_state.dart';
import 'package:music_bloc/features/storage/domain/storage_repo.dart';

class SongCubit extends Cubit<SongState> {
  final SongRepo songRepo;
  final StorageRepo storageRepo;

  SongCubit({
    required this.songRepo,
    required this.storageRepo,
  }) : super(SongInitial());

  // create song
  Future<void> createSong(
      {required String songName,
      required String artistName,
      required String imageUrl,
      required String youtubeUrl}) async {
    try {
      emit(SongLoading());
      final imagePath = await storageRepo.downloadImage(imageUrl);
      final audioPath = await storageRepo.downloadYtAudio(youtubeUrl);

      final newSong = Song(
        songName: songName,
        artistName: artistName,
        imagePath: imagePath,
        audioPath: audioPath,
      );

      await songRepo.createSong(newSong);

      // re fetch all songs
      // fetchAllSongs();
    } catch (e) {
      emit(SongError(message: e.toString()));
    } finally {
      // move re fetch to here?
      // re fetch all songs
      fetchAllSongs();
    }
  }

  // delete song
  Future<void> deleteSong(Song song) async {
    try {
      await storageRepo.deleteFile(song.imagePath);
      await storageRepo.deleteFile(song.audioPath);
      await songRepo.deleteSong(song.id);

      emit(SongDeleted(songId: song.id));
    } catch (e) {
      emit(SongError(message: e.toString()));
    } finally {
      // re fetch all songs
      fetchAllSongs();
    }
  }

  // fetch all songs (update home ui)
  Future<void> fetchAllSongs() async {
    try {
      emit(SongLoading());
      final List<Song> fetchedSongs = await songRepo.fetchAllSongs();
      emit(SongLoaded(songs: fetchedSongs));
    } catch (e) {
      emit(SongError(message: e.toString()));
    }
  }

  // fetch songs by ids (update ui for playlist)
  // Future<void> fetchSongByIds(List<int> songIds) async {
  //   try {
  //     emit(SongLoading());
  //     final List<Song> fetchedSongs = await songRepo.fetchSongByIds(songIds);
  //     emit(SongLoaded(songs: fetchedSongs));
  //   } catch (e) {
  //     emit(SongError(message: e.toString()));
  //   }
  // }
}
