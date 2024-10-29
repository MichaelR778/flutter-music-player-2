import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_bloc/features/playlist/domain/entities/playlist.dart';
import 'package:music_bloc/features/playlist/presentation/cubits/playlistsong_cubit.dart';
import 'package:music_bloc/features/playlist/presentation/cubits/playlistsong_state.dart';
import 'package:music_bloc/features/song/presentation/cubits/song_cubit.dart';
import 'package:music_bloc/features/song/presentation/cubits/song_state.dart';

class AddSongToPlaylistPage extends StatelessWidget {
  final Playlist playlist;

  const AddSongToPlaylistPage({super.key, required this.playlist});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add song'),
        centerTitle: true,
      ),
      body: BlocBuilder<SongCubit, SongState>(
        builder: (context, songState) {
          if (songState is SongLoaded) {
            // all song in database
            final allSongs = songState.songs;

            // blocbuilder for playlist songs
            return BlocBuilder<PlaylistsongCubit, PlaylistsongState>(
              builder: (context, state) {
                if (state is PlaylistsongLoaded) {
                  // song in playlist
                  final playlistSongs = state.songs;

                  // song not in playlist
                  final songs = allSongs
                      .where((song) => !playlistSongs.contains(song))
                      .toList();

                  // listview
                  return ListView.builder(
                    itemCount: songs.length,
                    itemBuilder: (context, index) {
                      final song = songs[index];
                      return Row(
                        children: [
                          Expanded(
                            child: ListTile(
                              leading: Image.file(
                                File(song.imagePath),
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                              title: Text(song.songName),
                              subtitle: Text(song.artistName),
                              subtitleTextStyle: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              context
                                  .read<PlaylistsongCubit>()
                                  .playlistAddSong(playlist, song.id);
                            },
                            icon: const Icon(Icons.add),
                          ),
                        ],
                      );
                    },
                  );
                }

                // song not loaded or some other state
                return const SizedBox();
              },
            );
          }
          // other states
          return const SizedBox();
        },
      ),
    );
  }
}
