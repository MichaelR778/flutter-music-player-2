import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_bloc/features/playlist/domain/entities/playlist.dart';
import 'package:music_bloc/features/playlist/domain/repos/playlist_repo.dart';
import 'package:music_bloc/features/playlist/presentation/cubits/playlistsong_state.dart';
import 'package:music_bloc/features/song/domain/entities/song.dart';
import 'package:music_bloc/features/song/domain/repos/song_repo.dart';

class PlaylistsongCubit extends Cubit<PlaylistsongState> {
  final SongRepo songRepo;
  final PlaylistRepo playlistRepo;

  PlaylistsongCubit({
    required this.songRepo,
    required this.playlistRepo,
  }) : super(PlaylistsongInitial());

  // add song to playlist
  Future<void> playlistAddSong(Playlist playlist, int songId) async {
    try {
      await playlistRepo.playlistAddSong(
        playlist.id,
        songId,
      );
      playlistFetchSong(playlist.id);
    } catch (e) {
      emit(PlaylistsongError(message: e.toString()));
      playlistFetchSong(playlist.id);
    }
  }

  // delete song from playlist
  Future<void> playlistDeleteSong(Playlist playlist, int songId) async {
    try {
      await playlistRepo.playlistDeleteSong(
        playlist.id,
        songId,
      );
      playlistFetchSong(playlist.id);
    } catch (e) {
      emit(PlaylistsongError(message: e.toString()));
      playlistFetchSong(playlist.id);
    }
  }

  // fetch playlists songs for playlist page
  Future<void> playlistFetchSong(int playlistId) async {
    try {
      final playlist = await playlistRepo.fetchPlaylist(playlistId);
      final List<Song> songs = await songRepo.fetchSongByIds(playlist.songIds);
      emit(PlaylistsongLoaded(playlistId: playlist.id, songs: songs));
    } catch (e) {
      emit(PlaylistsongError(message: e.toString()));
    }
  }

  // a song is deleted from db
  Future<void> cascadeDelete(int songId) async {
    final playlists = await playlistRepo.fetchAllPlaylists();

    for (final playlist in playlists) {
      if (playlist.songIds.contains(songId)) {
        playlistDeleteSong(playlist, songId);
      }
    }
  }
}
