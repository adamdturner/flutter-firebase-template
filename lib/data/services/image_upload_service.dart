import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class ImageUploadService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  /// Pick an image from gallery
  Future<XFile?> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      return image;
    } catch (e) {
      throw Exception('Error picking image: $e');
    }
  }

  /// Pick an image from camera
  Future<XFile?> pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      return image;
    } catch (e) {
      throw Exception('Error taking photo: $e');
    }
  }

  /// Upload image to Firebase Storage and return the download URL
  Future<String> uploadIssueScreenshot({
    required XFile image,
    required String userId,
    required String issueId,
  }) async {
    try {
      final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final String fileName = 'screenshot_${timestamp}_${image.name}';
      final String path = 'issue-reports/$userId/$issueId/$fileName';

      final Reference ref = _storage.ref().child(path);

      UploadTask uploadTask;

      if (kIsWeb) {
        // For web, use bytes
        final bytes = await image.readAsBytes();
        uploadTask = ref.putData(
          bytes,
          SettableMetadata(
            contentType: 'image/jpeg',
            customMetadata: {'uploaded_by': userId},
          ),
        );
      } else {
        // For mobile, use file
        final File file = File(image.path);
        uploadTask = ref.putFile(
          file,
          SettableMetadata(
            contentType: 'image/jpeg',
            customMetadata: {'uploaded_by': userId},
          ),
        );
      }

      // Wait for upload to complete
      final TaskSnapshot snapshot = await uploadTask;

      // Get download URL
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      throw Exception('Error uploading image: $e');
    }
  }

  /// Delete an image from Firebase Storage
  Future<void> deleteIssueScreenshot(String downloadUrl) async {
    try {
      final Reference ref = _storage.refFromURL(downloadUrl);
      await ref.delete();
    } catch (e) {
      throw Exception('Error deleting image: $e');
    }
  }

  /// Upload multiple images and return their download URLs
  Future<List<String>> uploadMultipleScreenshots({
    required List<XFile> images,
    required String userId,
    required String issueId,
    Function(int current, int total)? onProgress,
  }) async {
    final List<String> downloadUrls = [];

    for (int i = 0; i < images.length; i++) {
      onProgress?.call(i + 1, images.length);
      
      final String url = await uploadIssueScreenshot(
        image: images[i],
        userId: userId,
        issueId: issueId,
      );
      
      downloadUrls.add(url);
    }

    return downloadUrls;
  }

  /// Upload profile image to Firebase Storage and return the download URL
  Future<String> uploadProfileImage({
    required XFile image,
    required String userId,
  }) async {
    try {
      final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final String fileName = 'profile_${timestamp}_${image.name}';
      final String path = 'profile-images/$userId/$fileName';

      final Reference ref = _storage.ref().child(path);

      UploadTask uploadTask;

      if (kIsWeb) {
        // For web, use bytes
        final bytes = await image.readAsBytes();
        uploadTask = ref.putData(
          bytes,
          SettableMetadata(
            contentType: 'image/jpeg',
            customMetadata: {'uploaded_by': userId, 'type': 'profile'},
          ),
        );
      } else {
        // For mobile, use file
        final File file = File(image.path);
        uploadTask = ref.putFile(
          file,
          SettableMetadata(
            contentType: 'image/jpeg',
            customMetadata: {'uploaded_by': userId, 'type': 'profile'},
          ),
        );
      }

      // Wait for upload to complete
      final TaskSnapshot snapshot = await uploadTask;

      // Get download URL
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      throw Exception('Error uploading profile image: $e');
    }
  }

  /// Delete a profile image from Firebase Storage
  Future<void> deleteProfileImage(String downloadUrl) async {
    try {
      final Reference ref = _storage.refFromURL(downloadUrl);
      await ref.delete();
    } catch (e) {
      throw Exception('Error deleting profile image: $e');
    }
  }
}

