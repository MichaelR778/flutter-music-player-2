abstract class StorageRepo {
  Future<String> downloadImage(String url);
  Future<String> downloadYtAudio(String url);
  Future<void> deleteFile(String filepath);
}
