import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_bloc/features/audio_player/presentation/components/bottom_tile.dart';
import 'package:music_bloc/features/audio_player/presentation/cubits/audio_player_cubit.dart';
import 'package:music_bloc/features/playlist/domain/entities/playlist.dart';
import 'package:music_bloc/features/playlist/presentation/cubits/playlist_cubit.dart';
import 'package:music_bloc/features/playlist/presentation/cubits/playlistsong_cubit.dart';
import 'package:music_bloc/features/playlist/presentation/cubits/playlistsong_state.dart';
import 'package:music_bloc/features/playlist/presentation/pages/add_song_to_playlist_page.dart';
import 'package:music_bloc/features/song/domain/entities/song.dart';
import 'package:music_bloc/features/song/presentation/components/song_tile.dart';

class PlaylistPage extends StatefulWidget {
  final Playlist playlist;

  const PlaylistPage({super.key, required this.playlist});

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  late final audioPlayerCubit = context.read<AudioPlayerCubit>();
  late final playlistsongCubit = context.read<PlaylistsongCubit>();

  void play(List<Song> songs, int index) {
    audioPlayerCubit.updatePlaylist(widget.playlist.id, songs);
    audioPlayerCubit.playSong(index);
  }

  void deleteSong(Song song) {
    playlistsongCubit.playlistDeleteSong(
      widget.playlist,
      song.id,
    );
  }

  @override
  void initState() {
    super.initState();
    context.read<PlaylistsongCubit>().playlistFetchSong(widget.playlist.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          // playlist image
          Center(
            child: SizedBox(
              width: 200,
              height: 200,
              child: Image.file(
                File(widget.playlist.imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // playlist details
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.playlist.playlistName,
                  style: const TextStyle(fontSize: 28),
                ),
                BlocBuilder<PlaylistsongCubit, PlaylistsongState>(
                  builder: (context, state) {
                    int songCount = widget.playlist.songIds.length;
                    if (state is PlaylistsongLoaded) {
                      songCount = state.songs.length;
                    }
                    return Text(
                      '$songCount songs',
                      style: TextStyle(
                          fontSize: 15,
                          color: Theme.of(context).colorScheme.primary),
                    );
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.favorite_outline),
                    const SizedBox(width: 18),
                    PopupMenuButton(
                      color: Theme.of(context).colorScheme.secondary,
                      icon: Icon(
                        Icons.more_vert,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddSongToPlaylistPage(
                                playlist: widget.playlist,
                              ),
                            ),
                          ),
                          child: const Text('Add song to playlist'),
                        ),
                        PopupMenuItem(
                          onTap: () {
                            context
                                .read<PlaylistCubit>()
                                .deletePlaylist(widget.playlist);
                            Navigator.pop(context);
                          },
                          child: const Text('Delete playlist'),
                        ),
                      ],
                    ),
                    Expanded(child: Container()),
                    IconButton.filled(
                      onPressed: () {
                        final state = context.read<PlaylistsongCubit>().state;
                        if (state is PlaylistsongLoaded) {
                          final songs = state.songs;
                          play(songs, 0);
                        }
                      },
                      icon: const Icon(Icons.play_arrow),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // song listview
          BlocBuilder<PlaylistsongCubit, PlaylistsongState>(
            builder: (context, state) {
              if (state is PlaylistsongLoaded &&
                  state.playlistId == widget.playlist.id) {
                final songs = state.songs;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: songs.length,
                  itemBuilder: (context, index) {
                    final song = songs[index];
                    return SongTile(
                      song: song,
                      play: () => play(songs, index),
                      delete: () => deleteSong(song),
                      deleteText: 'Delete from playlist',
                    );
                  },
                );
              }
              return const SizedBox();
            },
          ),

          const SizedBox(height: 75),
        ],
      ),

      // bottom tile
      floatingActionButton: BottomTile(bottomMargin: 10),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
