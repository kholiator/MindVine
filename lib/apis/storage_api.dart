import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindvine/constants/constants.dart';
import 'package:mindvine/core/providers.dart';

// Provider for accessing the StorageAPI
final storageAPIProvider = Provider((ref) {
  return StorageAPI(
    storage: ref.watch(appwriteStorageProvider),
  );
});

// StorageAPI class for handling file uploads
class StorageAPI {
  final Storage _storage;

  StorageAPI({required Storage storage}) : _storage = storage;

  Future<List<String>> uploadImage(List<File> files) async {
    List<String> imageLinks = [];

    // Upload each file to the Appwrite storage
    for (final file in files) {
      final uploadedImage = await _storage.createFile(
        bucketId: AppwriteConstants.imagesBucket,
        fileId: ID.unique(),
        file: InputFile.fromPath(path: file.path),
      );

      // Retrieve the image link and add it to the list
      imageLinks.add(
        AppwriteConstants.imageUrl(uploadedImage.$id),
      );
    }

    // Return the list of uploaded image links
    return imageLinks;
  }
}
