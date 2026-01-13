import 'package:image_picker/image_picker.dart';

/// Base class for image picker states.
abstract class ImagePickerState {
  final List<XFile> selectedImages;

  const ImagePickerState({this.selectedImages = const []});
}

/// Initial state with no images selected.
class ImagePickerInitial extends ImagePickerState {
  const ImagePickerInitial() : super(selectedImages: const []);
}

/// State when images are selected and ready.
class ImagePickerReady extends ImagePickerState {
  const ImagePickerReady({required List<XFile> selectedImages})
      : super(selectedImages: selectedImages);
}

/// State when an error occurred during image picking.
class ImagePickerError extends ImagePickerState {
  final String message;

  const ImagePickerError({
    required this.message,
    required List<XFile> selectedImages,
  }) : super(selectedImages: selectedImages);
}

/// State when images are being uploaded.
class ImagesUploading extends ImagePickerState {
  final int current;
  final int total;

  const ImagesUploading({
    required this.current,
    required this.total,
    required List<XFile> selectedImages,
  }) : super(selectedImages: selectedImages);
}

/// State when images have been successfully uploaded.
class ImagesUploaded extends ImagePickerState {
  final List<String> uploadedUrls;

  const ImagesUploaded({required this.uploadedUrls})
      : super(selectedImages: const []);
}

/// State when image upload has failed.
class ImagesUploadFailure extends ImagePickerState {
  final String error;

  const ImagesUploadFailure({
    required this.error,
    required List<XFile> selectedImages,
  }) : super(selectedImages: selectedImages);
}

