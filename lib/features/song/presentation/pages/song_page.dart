import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_bloc/features/audio_player/presentation/cubits/audio_player_cubit.dart';
import 'package:music_bloc/features/audio_player/presentation/cubits/audio_player_state.dart';
import 'package:music_bloc/features/overflow%20text/overflow_text.dart';
import 'package:music_bloc/features/song/domain/entities/song.dart';
import 'package:music_bloc/features/song/presentation/components/neu_box.dart';

class SongPage extends StatelessWidget {
  const SongPage({super.key});

  // convert seconds into minsec duration
  String format(Duration duration) {
    String seconds =
        duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '${duration.inMinutes}:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioPlayerCubit, AudioPlayerState>(
      builder: (context, state) {
        Song? currSong;

        if (state is AudioPlayerPlaying) {
          currSong = state.song;
        } else if (state is AudioPlayerPaused) {
          currSong = state.song;
        } else if (state is AudioPlayerStopped) {
          Navigator.pop(context);
        }

        final audioPlayer = context.read<AudioPlayerCubit>();
        final listen = context.watch<AudioPlayerCubit>();

        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 25, right: 25, bottom: 25),
              child: Column(
                children: [
                  // appbar
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // back button
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back),
                        ),

                        // title
                        const Text('P L A Y L I S T'),

                        // menu button
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.menu),
                        ),
                      ],
                    ),
                  ),

                  Expanded(child: Container()),

                  Column(
                    children: [
                      // album artwork
                      NeuBox(
                        child: Column(
                          children: [
                            // image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: Image.file(
                                  File(currSong!.imagePath),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),

                            // song, artist and icon
                            Padding(
                              padding: EdgeInsets.all(15.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // song and artist name
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // song name
                                      // Text(
                                      //   currSong.songName,
                                      //   style: const TextStyle(
                                      //     fontWeight: FontWeight.bold,
                                      //     fontSize: 20,
                                      //   ),
                                      // ),
                                      SizedBox(
                                        width: 210,
                                        height: 30,
                                        child: OverflowText(
                                          text: currSong.songName,
                                          textStyle: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),

                                      // artist name
                                      // Text(
                                      //   currSong.artistName,
                                      //   style: TextStyle(
                                      //     color: Theme.of(context)
                                      //         .colorScheme
                                      //         .primary,
                                      //   ),
                                      // ),
                                      SizedBox(
                                        width: 210,
                                        height: 20,
                                        child: OverflowText(
                                          text: currSong.artistName,
                                          textStyle: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  // heart icon
                                  const Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 25),

                      // song duration progress
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // start time
                                Text(format(listen.currentDuration)),

                                // shuffle icon
                                const Icon(Icons.shuffle),

                                // repeat icon
                                const Icon(Icons.repeat),

                                // end time
                                Text(format(listen.totalDuration))
                              ],
                            ),
                          ),

                          // song duration progress
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              thumbShape: const RoundSliderThumbShape(
                                  enabledThumbRadius: 0),
                            ),
                            child: Slider(
                              min: 0,
                              max: listen.totalDuration.inSeconds.toDouble(),
                              value:
                                  listen.currentDuration.inSeconds.toDouble(),
                              activeColor: Colors.green,
                              onChanged: (changedValue) {
                                // during sliding
                              },
                              onChangeEnd: (changedValue) {
                                // finish sliding
                                audioPlayer.seek(
                                    Duration(seconds: changedValue.toInt()));
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // playback control
                      Row(
                        children: [
                          // skip previous
                          Expanded(
                            child: GestureDetector(
                              onTap: audioPlayer.playPreviousSong,
                              child: const NeuBox(
                                child: Icon(Icons.skip_previous),
                              ),
                            ),
                          ),

                          const SizedBox(width: 20),

                          // play pause
                          Expanded(
                            flex: 2,
                            child: GestureDetector(
                              onTap: audioPlayer.toggle,
                              child: NeuBox(
                                child: Icon(listen.isPlaying
                                    ? Icons.pause
                                    : Icons.play_arrow),
                              ),
                            ),
                          ),

                          const SizedBox(width: 20),

                          // skip forward
                          Expanded(
                            child: GestureDetector(
                              onTap: audioPlayer.playNextSong,
                              child: const NeuBox(
                                child: Icon(Icons.skip_next),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  Expanded(child: Container()),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
