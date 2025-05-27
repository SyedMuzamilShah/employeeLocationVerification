class ExceptionLog implements Exception {
  final String message;

  ExceptionLog(this.message);

  @override
  String toString() {
    return message;
  }
}