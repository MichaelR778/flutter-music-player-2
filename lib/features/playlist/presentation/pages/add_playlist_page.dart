import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:music_bloc/features/image_preview/presentation/cubits/preview_cubit.dart';
import 'package:music_bloc/features/playlist/presentation/cubits/playlist_cubit.dart';

class AddPlaylistPage extends StatefulWidget {
  const AddPlaylistPage({super.key});

  @override
  State<AddPlaylistPage> createState() => _AddPlaylistPageState();
}

class _AddPlaylistPageState extends State<AddPlaylistPage> {
  final formGlobalKey = GlobalKey<FormState>();
  String playlistName = '';
  String imageUrl = '';

  @override
  void initState() {
    super.initState();
    context.read<PreviewCubit>().reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          // image
          BlocBuilder<PreviewCubit, PreviewState>(
            builder: (context, state) {
              return Row(
                children: [
                  Expanded(child: Container()),
                  Expanded(
                    flex: 2,
                    child: Image.network(
                      width: double.infinity,
                      height: double.infinity,
                      state.imageUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(child: CircularProgressIndicator());
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return LottieBuilder.asset(
                            'assets/image_placeholder.json');
                      },
                    ),
                  ),
                  Expanded(child: Container()),
                ],
              );
            },
          ),

          // form
          Form(
            key: formGlobalKey,
            child: Container(
              padding: const EdgeInsets.all(40),
              height: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // image url input
                  TextFormField(
                    decoration: const InputDecoration(
                      label: Text('Image url'),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please input an Image url';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      imageUrl = value!;
                    },
                    onChanged: (value) {
                      context.read<PreviewCubit>().preview(value);
                    },
                  ),

                  // playlist name
                  TextFormField(
                    decoration: const InputDecoration(
                      label: Text('Playlist name'),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please input a Playlist name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      playlistName = value!;
                    },
                  ),

                  // button
                  GestureDetector(
                    onTap: () {
                      if (formGlobalKey.currentState!.validate()) {
                        formGlobalKey.currentState!.save();
                        context.read<PlaylistCubit>().createPlaylist(
                              playlistName: playlistName,
                              imageUrl: imageUrl,
                            );
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
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
                      child: const Text(
                        'Create Playlist',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
