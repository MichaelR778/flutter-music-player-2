import 'dart:io';

import 'package:dio/dio.dart';
import 'package:music_bloc/features/storage/domain/storage_repo.dart';
import 'package:path_provider/path_provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class DataStorageRepo implements StorageRepo {
  @override
  Future<String> downloadImage(String url) async {
    try {
      final Dio dio = Dio();

      final dir = await getExternalStorageDirectory();
      if (dir == null) throw Exception('Error getting directory');

      // timestamp to ensure unique filename
      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      String imagePath = '${dir.path}/image_$timestamp.jpg';

      await dio.download(url, imagePath);
      return imagePath;
    } catch (e) {
      throw Exception('Error downloading image: $e');
    }
  }

  @override
  Future<String> downloadYtAudio(String url) async {
    try {
      var yt = YoutubeExplode();

      final dir = await getExternalStorageDirectory();
      if (dir == null) throw Exception('Error getting directory');

      // timestamp to ensure unique filename
      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      String audioPath = '${dir.path}/audio_$timestamp.jpg';

      // yt explode stuff
      final videoId = VideoId(url);
      final manifest = await yt.videos.streamsClient.getManifest(videoId);
      final streamInfo = manifest.audioOnly.withHighestBitrate();
      final stream = yt.videos.streamsClient.get(streamInfo);

      // open file for writing
      var file = File(audioPath);
      var fileStream = file.openWrite();

      // pipe all content of the stream into file
      await stream.pipe(fileStream);

      // close file
      await fileStream.flush();
      await fileStream.close();

      // dispose ytexplode object
      yt.close();

      return audioPath;
    } catch (e) {
      throw Exception('Error downloading song audio: $e');
    }
  }

  @override
  Future<void> deleteFile(String filepath) async {
    try {
      final file = File(filepath);
      await file.delete();
    } catch (e) {
      throw Exception('Error deleting file: $e');
    }
  }
}
