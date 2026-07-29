abstract class Failure {
  final String message;
  const Failure(this.message);
}

class StorageFailure extends Failure {
  const StorageFailure([super.message = 'Database error occurred']);
}

class ImageFailure extends Failure {
  const ImageFailure([super.message = 'Unable to save or load image']);
}

class PdfFailure extends Failure {
  const PdfFailure([super.message = 'Unable to create invoice PDF']);
}

class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'An unexpected error occurred']);
}
