import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_bloc/features/audio_player/presentation/cubits/audio_player_cubit.dart';
import 'package:music_bloc/features/audio_player/presentation/cubits/audio_player_state.dart';
import 'package:music_bloc/features/overflow%20text/overflow_text.dart';
import 'package:music_bloc/features/song/domain/entities/song.dart';
import 'package:music_bloc/features/song/presentation/pages/song_page.dart';

class BottomTile extends StatelessWidget {
  final double bottomMargin;

  const BottomTile({
    super.key,
    required this.bottomMargin,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioPlayerCubit, AudioPlayerState>(
      builder: (context, state) {
        Song? song;

        if (state is AudioPlayerPlaying) {
          song = state.song;
        } else if (state is AudioPlayerPaused) {
          song = state.song;
        } else if (state is AudioPlayerStopped) {
          return const SizedBox();
        }

        return GestureDetector(
          child: Container(
            height: 70,
            margin: EdgeInsets.only(bottom: bottomMargin, left: 8, right: 8),
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.secondary,
              ),
              borderRadius: BorderRadius.circular(12),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF424242), // Dark grey
                  Color(0xFF212121), // Darker grey
                  Color(0xFF0D0D0D), // Near-black grey
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                // leading image
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Image.file(
                    File(song!.imagePath),
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),

                // title and subtitle
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // song name
                      SizedBox(
                        height: 25,
                        child: OverflowText(
                          text: song.songName,
                          textStyle: const TextStyle(fontSize: 16),
                        ),
                      ),

                      // artist name
                      SizedBox(
                        height: 20,
                        child: OverflowText(
                          text: song.artistName,
                          textStyle: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                      // Text(
                      //   song.artistName,
                      //   style: TextStyle(
                      //     color: Theme.of(context).colorScheme.primary,
                      //   ),
                      // ),
                    ],
                  ),
                ),

                // trailing
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 20),
                  child: GestureDetector(
                    onTap: context.read<AudioPlayerCubit>().toggle,
                    child: Icon(context.watch<AudioPlayerCubit>().isPlaying
                        ? Icons.pause
                        : Icons.play_arrow),
                  ),
                ),
              ],
            ),
          ),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SongPage(),
            ),
          ),
        );
      },
    );
  }
}
