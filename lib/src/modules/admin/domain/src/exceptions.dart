class SuperHttpBadRequest implements Exception {
  final Object exception;
  final StackTrace? stack;

  SuperHttpBadRequest({
    required this.exception,
    this.stack,
  });

  @override
  String toString() {
    return exception.toString();
  }
}
