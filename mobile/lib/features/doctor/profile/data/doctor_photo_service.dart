import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class DoctorPhotoService {
  final ImagePicker _picker = ImagePicker();

  Future<String?> pickAndSavePhoto() async {
    final XFile? selectedImage = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 1200,
    );

    if (selectedImage == null) return null;

    final directory = await getApplicationDocumentsDirectory();
    final photoDirectory = Directory('${directory.path}/doctor_profile');

    if (!await photoDirectory.exists()) {
      await photoDirectory.create(recursive: true);
    }

    final extension = selectedImage.name.contains('.')
        ? selectedImage.name.split('.').last
        : 'jpg';

    final savedPhoto = File('${photoDirectory.path}/doctor_photo.$extension');

    await File(selectedImage.path).copy(savedPhoto.path);

    return savedPhoto.path;
  }

  Future<void> deletePhoto(String? photoPath) async {
    if (photoPath == null || photoPath.isEmpty) return;

    final photo = File(photoPath);

    if (await photo.exists()) {
      await photo.delete();
    }
  }
}
