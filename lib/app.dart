import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_bloc/features/audio_player/presentation/components/bottom_tile.dart';
import 'package:music_bloc/features/audio_player/presentation/cubits/audio_player_cubit.dart';
import 'package:music_bloc/features/home/presentation/pages/home_page.dart';
import 'package:music_bloc/features/image_preview/presentation/cubits/preview_cubit.dart';
import 'package:music_bloc/features/playlist/domain/repos/playlist_repo.dart';
import 'package:music_bloc/features/playlist/presentation/cubits/playlist_cubit.dart';
import 'package:music_bloc/features/playlist/presentation/cubits/playlist_state.dart';
import 'package:music_bloc/features/playlist/presentation/cubits/playlistsong_cubit.dart';
import 'package:music_bloc/features/playlist/presentation/cubits/playlistsong_state.dart';
import 'package:music_bloc/features/playlist/presentation/pages/playlists_page.dart';
import 'package:music_bloc/features/song/domain/repos/song_repo.dart';
import 'package:music_bloc/features/song/presentation/cubits/song_cubit.dart';
import 'package:music_bloc/features/song/presentation/cubits/song_state.dart';
import 'package:music_bloc/features/storage/data/data_storage_repo.dart';
import 'package:music_bloc/features/storage/domain/storage_repo.dart';

class App extends StatelessWidget {
  // repos for cubit
  final SongRepo songRepo;
  final PlaylistRepo playlistRepo;
  final StorageRepo storageRepo = DataStorageRepo();

  App({
    super.key,
    required this.songRepo,
    required this.playlistRepo,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // song cubit
        BlocProvider<SongCubit>(
          create: (context) => SongCubit(
            songRepo: songRepo,
            storageRepo: storageRepo,
          ),
        ),

        // playlist cubit
        BlocProvider<PlaylistCubit>(
          create: (context) => PlaylistCubit(
            playlistRepo: playlistRepo,
            storageRepo: storageRepo,
          ),
        ),

        // playlistsong cubit
        BlocProvider<PlaylistsongCubit>(
          create: (context) => PlaylistsongCubit(
            songRepo: songRepo,
            playlistRepo: playlistRepo,
          ),
        ),

        // audio player cubit
        BlocProvider<AudioPlayerCubit>(
          create: (context) => AudioPlayerCubit(),
        ),

        // preview cubit
        BlocProvider<PreviewCubit>(
          create: (context) => PreviewCubit(),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          // listener to update audioplayer song list
          // after add/delete song from db
          BlocListener<SongCubit, SongState>(
            listener: (context, state) {
              if (state is SongLoaded) {
                final songs = state.songs;
                context.read<AudioPlayerCubit>().updateChange(-1, songs);
              }

              // cascade delete
              if (state is SongDeleted) {
                context.read<PlaylistsongCubit>().cascadeDelete(state.songId);
              }
            },
          ),
          // listener to update audioplayer
          // if a playlist is deleted
          BlocListener<PlaylistCubit, PlaylistState>(
            listener: (context, state) {
              if (state is PlaylistDeleted) {
                context
                    .read<AudioPlayerCubit>()
                    .updateChange(state.playlistId, []);
              }
            },
          ),

          // listener to update audioplayer song list
          // after add/delete song from playlist
          BlocListener<PlaylistsongCubit, PlaylistsongState>(
            listener: (context, state) {
              if (state is PlaylistsongLoaded) {
                final playlistId = state.playlistId;
                final songs = state.songs;
                context
                    .read<AudioPlayerCubit>()
                    .updateChange(playlistId, songs);
              }
            },
          ),
          // other listeners if needed
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.dark(
              surface: Colors.grey.shade900,
              primary: const Color.fromARGB(255, 200, 200, 200),
              secondary: const Color.fromARGB(255, 75, 75, 75),
            ),
          ),
          home: Root(),
        ),
      ),
    );
  }
}

// root widget to navigate between home and playlists page
class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    PlaylistsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          _pages[_selectedIndex],
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: BottomNavigationBar(
              elevation: 0,
              backgroundColor:
                  Theme.of(context).colorScheme.surface.withOpacity(0.9),
              selectedItemColor: Theme.of(context).colorScheme.primary,
              unselectedItemColor: Theme.of(context).colorScheme.secondary,
              showUnselectedLabels: false,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.library_music),
                  label: 'Playlists',
                ),
              ],
              currentIndex: _selectedIndex,
              onTap: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ],
      ),

      // bottom tile
      floatingActionButton: BottomTile(bottomMargin: 58),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
