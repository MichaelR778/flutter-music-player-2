import 'dart:io';

import 'package:flutter/material.dart';
import 'package:music_bloc/features/song/domain/entities/song.dart';

class SongTile extends StatelessWidget {
  final Song song;
  final void Function()? play;
  final void Function()? delete;
  final String deleteText;

  const SongTile({
    super.key,
    required this.song,
    required this.play,
    required this.delete,
    required this.deleteText,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: play,
      child: Row(
        children: [
          Expanded(
            child: ListTile(
              leading: Image.file(
                File(song.imagePath),
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
              title: Text(
                song.songName,
                softWrap: false,
                overflow: TextOverflow.fade,
              ),
              subtitle: Text(
                song.artistName,
                softWrap: false,
                overflow: TextOverflow.fade,
              ),
              subtitleTextStyle: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          PopupMenuButton(
            color: Theme.of(context).colorScheme.secondary,
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).colorScheme.primary,
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                onTap: delete,
                child: Text(deleteText),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
