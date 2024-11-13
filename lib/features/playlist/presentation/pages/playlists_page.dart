import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:music_bloc/features/playlist/presentation/components/playlist_tile.dart';
import 'package:music_bloc/features/playlist/presentation/cubits/playlist_cubit.dart';
import 'package:music_bloc/features/playlist/presentation/cubits/playlist_state.dart';
import 'package:music_bloc/features/playlist/presentation/pages/add_playlist_page.dart';

class PlaylistsPage extends StatefulWidget {
  const PlaylistsPage({super.key});

  @override
  State<PlaylistsPage> createState() => _PlaylistsPageState();
}

class _PlaylistsPageState extends State<PlaylistsPage> {
  @override
  void initState() {
    super.initState();
    context.read<PlaylistCubit>().fetchAllPlaylists();
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
            const Text('Playlists'),
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
                builder: (context) => AddPlaylistPage(),
              ),
            ),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: BlocConsumer<PlaylistCubit, PlaylistState>(
        builder: (context, state) {
          // loading
          if (state is PlaylistLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // loaded
          else if (state is PlaylistLoaded) {
            final playlists = state.playlists;
            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.88,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: playlists.length,
                  itemBuilder: (context, index) {
                    return PlaylistTile(playlist: playlists[index]);
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

        // error listener
        listener: (context, state) {
          if (state is PlaylistError) {
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
