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

class VChatHttpUnAuth implements Exception {
  final Object exception;
  final StackTrace? stack;

  VChatHttpUnAuth({
    required this.exception,
    this.stack,
  });

  @override
  String toString() {
    return exception.toString();
  }
}
