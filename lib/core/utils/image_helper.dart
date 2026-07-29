import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class ImageHelper {
  static Future<String?> saveImageToAppStorage(String sourcePath) async {
    try {
      final file = File(sourcePath);
      if (!await file.exists()) return null;

      final appDir = await getApplicationDocumentsDirectory();
      final imagesDir = Directory(p.join(appDir.path, 'app_images'));
      if (!await imagesDir.exists()) {
        await imagesDir.create(recursive: true);
      }

      final ext = p.extension(sourcePath);
      final fileName = '${const Uuid().v4()}$ext';
      final savedFile = await file.copy(p.join(imagesDir.path, fileName));
      return savedFile.path;
    } catch (_) {
      return null;
    }
  }

  const ImageHelper._();
}
