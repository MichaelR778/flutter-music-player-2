import 'dart:io';

import 'package:flutter/material.dart';
import 'package:music_bloc/features/playlist/domain/entities/playlist.dart';
import 'package:music_bloc/features/playlist/presentation/pages/playlist_page.dart';

class PlaylistTile extends StatelessWidget {
  final Playlist playlist;

  const PlaylistTile({super.key, required this.playlist});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlaylistPage(playlist: playlist),
            ),
          ),
          child: AspectRatio(
            aspectRatio: 1,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: FileImage(File(playlist.imagePath)),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        Text(
          playlist.playlistName,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
