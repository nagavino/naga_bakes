abstract class AppException implements Exception {
  final String message;
  const AppException(this.message);
}

class StorageException extends AppException {
  const StorageException([super.message = 'Storage operation failed']);
}

class ImageException extends AppException {
  const ImageException([super.message = 'Image processing failed']);
}

class PdfException extends AppException {
  const PdfException([super.message = 'PDF generation failed']);
}
