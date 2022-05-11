class MYHttpException implements Exception {
  final int code;
  final String message;

  MYHttpException(this.code, this.message);

  @override
  toString() => 'MYHttpException($code, $message)';
}
