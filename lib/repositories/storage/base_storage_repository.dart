import 'dart:io';

abstract class BaseStorageRepository{

  /// Returns a future String, where the String is a download URL
  // Reason this function takes a URL is because when updating an existing Profile Image with a new Image,
  // we want to overwrite the existing Image with a new Image
  Future<String> uploadProfileImage({String url, File image});

  Future<String> uploadPostImage({File image});

}