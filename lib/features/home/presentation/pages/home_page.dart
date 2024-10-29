import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:music_bloc/features/audio_player/presentation/cubits/audio_player_cubit.dart';
import 'package:music_bloc/features/song/domain/entities/song.dart';
import 'package:music_bloc/features/song/presentation/components/song_tile.dart';
import 'package:music_bloc/features/song/presentation/cubits/song_cubit.dart';
import 'package:music_bloc/features/song/presentation/cubits/song_state.dart';
import 'package:music_bloc/features/song/presentation/pages/add_song_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final songCubit = context.read<SongCubit>();
  late final audioPlayerCubit = context.read<AudioPlayerCubit>();

  void play(List<Song> songs, int index) {
    audioPlayerCubit.updatePlaylist(-1, songs);
    audioPlayerCubit.playSong(index);
  }

  void deleteSong(Song song) {
    songCubit.deleteSong(song);
  }

  @override
  void initState() {
    super.initState();
    context.read<SongCubit>().fetchAllSongs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SizedBox(
              width: 50,
              child: LottieBuilder.asset('assets/wave.json'),
            ),
            const Text('Home'),
          ],
        ),
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.secondary,
                Theme.of(context).colorScheme.surface,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddSongPage(),
              ),
            ),
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: BlocConsumer<SongCubit, SongState>(
        builder: (context, state) {
          // loading
          if (state is SongLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // loaded
          else if (state is SongLoaded) {
            final songs = state.songs;
            return ListView(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: songs.length,
                  itemBuilder: (context, index) {
                    final song = songs[index];
                    return SongTile(
                      song: song,
                      play: () => play(songs, index),
                      delete: () => deleteSong(song),
                      deleteText: 'Delete',
                    );
                  },
                ),
                const SizedBox(height: 125),
              ],
            );
          }

          // other
          else {
            return const SizedBox();
          }
        },

        // error listener to display error message
        listener: (context, state) {
          if (state is SongError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
      ),
    );
  }
}
