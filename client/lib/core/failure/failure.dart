class AppFailure {
  final String message;
  // final int statusCode;
  AppFailure([this.message = "Sorry, An unexpected error has occured"]);

  @override
  String toString() => 'AppFailure(message:$message)';
}
