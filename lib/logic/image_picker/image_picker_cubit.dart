import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_template/data/services/image_upload_service.dart';
import 'package:flutter_firebase_template/logic/image_picker/image_picker_state.dart';

/// Cubit for managing image picking and uploading operations.
class ImagePickerCubit extends Cubit<ImagePickerState> {
  final ImageUploadService imageUploadService;

  ImagePickerCubit({required this.imageUploadService})
      : super(const ImagePickerInitial());

  /// Picks an image from the gallery.
  Future<void> pickFromGallery() async {
    try {
      final image = await imageUploadService.pickImageFromGallery();
      if (image != null) {
        final updatedImages = [...state.selectedImages, image];
        emit(ImagePickerReady(selectedImages: updatedImages));
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Image Picker Cubit Error: failed to pick from gallery - $e');
      }
      emit(ImagePickerError(
        message: e.toString(),
        selectedImages: state.selectedImages,
      ));
    }
  }

  /// Picks an image from the camera.
  Future<void> pickFromCamera() async {
    try {
      final image = await imageUploadService.pickImageFromCamera();
      if (image != null) {
        final updatedImages = [...state.selectedImages, image];
        emit(ImagePickerReady(selectedImages: updatedImages));
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Image Picker Cubit Error: failed to pick from camera - $e');
      }
      emit(ImagePickerError(
        message: e.toString(),
        selectedImages: state.selectedImages,
      ));
    }
  }

  /// Removes an image at the specified index.
  void removeImage(int index) {
    if (index >= 0 && index < state.selectedImages.length) {
      final updatedImages = [...state.selectedImages]..removeAt(index);
      if (updatedImages.isEmpty) {
        emit(const ImagePickerInitial());
      } else {
        emit(ImagePickerReady(selectedImages: updatedImages));
      }
    }
  }

  /// Uploads all selected images.
  Future<List<String>> uploadImages({
    required String userId,
    required String issueId,
  }) async {
    if (state.selectedImages.isEmpty) {
      return [];
    }

    try {
      final urls = await imageUploadService.uploadMultipleScreenshots(
        images: state.selectedImages,
        userId: userId,
        issueId: issueId,
        onProgress: (current, total) {
          emit(ImagesUploading(
            current: current,
            total: total,
            selectedImages: state.selectedImages,
          ));
        },
      );
      emit(ImagesUploaded(uploadedUrls: urls));
      return urls;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Image Picker Cubit Error: failed to upload images - $e');
      }
      emit(ImagesUploadFailure(
        error: e.toString(),
        selectedImages: state.selectedImages,
      ));
      rethrow;
    }
  }

  /// Resets the cubit to initial state.
  void reset() {
    emit(const ImagePickerInitial());
  }
}

