import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:isar/isar.dart';
import 'package:music_bloc/app.dart';
import 'package:music_bloc/features/playlist/data/isar_playlist_repo.dart';
import 'package:music_bloc/features/playlist/domain/entities/playlist.dart';
import 'package:music_bloc/features/song/data/isar_song_repo.dart';
import 'package:music_bloc/features/song/domain/entities/song.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is initialized

  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [SongSchema, PlaylistSchema],
    directory: dir.path,
  );

  // lock to portrait
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(App(
    songRepo: IsarSongRepo(isar: isar),
    playlistRepo: IsarPlaylistRepo(isar: isar),
  ));
}
