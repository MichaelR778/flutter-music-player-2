import 'package:isar/isar.dart';

// to generate file: flutter pub run build_runner build
part 'playlist.g.dart';

@collection
class Playlist {
  Id id = Isar.autoIncrement;
  final String playlistName;
  final String imagePath;
  List<int> songIds = [];

  Playlist({
    required this.playlistName,
    required this.imagePath,
  });
}
