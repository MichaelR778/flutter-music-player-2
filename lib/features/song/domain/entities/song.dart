import 'package:isar/isar.dart';

// to generate file: flutter pub run build_runner build
part 'song.g.dart';

@collection
class Song {
  Id id = Isar.autoIncrement;
  final String songName;
  final String artistName;
  final String imagePath;
  final String audioPath;

  Song({
    required this.songName,
    required this.artistName,
    required this.imagePath,
    required this.audioPath,
  });

  // override the == operator
  @override
  bool operator ==(Object other) {
    if (other is! Song) return false;
    if (id != other.id) return false;
    if (songName != other.songName) return false;
    if (artistName != other.artistName) return false;
    return true;
  }

  // override hashcode
  @override
  int get hashCode => id.hashCode ^ songName.hashCode ^ artistName.hashCode;
}
