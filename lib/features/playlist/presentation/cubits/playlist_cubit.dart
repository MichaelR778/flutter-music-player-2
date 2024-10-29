import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_bloc/features/playlist/domain/entities/playlist.dart';
import 'package:music_bloc/features/playlist/domain/repos/playlist_repo.dart';
import 'package:music_bloc/features/playlist/presentation/cubits/playlist_state.dart';
import 'package:music_bloc/features/storage/domain/storage_repo.dart';

class PlaylistCubit extends Cubit<PlaylistState> {
  final PlaylistRepo playlistRepo;
  final StorageRepo storageRepo;

  PlaylistCubit({
    required this.playlistRepo,
    required this.storageRepo,
  }) : super(PlaylistInitial());

  // create playlist
  Future<void> createPlaylist({
    required String playlistName,
    required String imageUrl,
  }) async {
    try {
      emit(PlaylistLoading());
      final imagePath = await storageRepo.downloadImage(imageUrl);

      final newPlaylist = Playlist(
        playlistName: playlistName,
        imagePath: imagePath,
      );

      await playlistRepo.createPlaylist(newPlaylist);
    } catch (e) {
      emit(PlaylistError(message: e.toString()));
    } finally {
      // re fetch all playlists
      fetchAllPlaylists();
    }
  }

  // delete playlist
  Future<void> deletePlaylist(Playlist playlist) async {
    try {
      await storageRepo.deleteFile(playlist.imagePath);
      await playlistRepo.deletePlaylist(playlist.id);
      emit(PlaylistDeleted(playlistId: playlist.id));
    } catch (e) {
      emit(PlaylistError(message: e.toString()));
    } finally {
      // re fetch all playlists
      fetchAllPlaylists();
    }
  }

  // fetch all playlist for playlists page
  Future<void> fetchAllPlaylists() async {
    try {
      emit(PlaylistLoading());
      final List<Playlist> fetchedPlaylists =
          await playlistRepo.fetchAllPlaylists();
      emit(PlaylistLoaded(playlists: fetchedPlaylists));
    } catch (e) {
      emit(PlaylistError(message: e.toString()));
    }
  }
}
