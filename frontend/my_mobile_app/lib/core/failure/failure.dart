class Failure {
  final String message;

  Failure({required this.message});
}


class ValidationFailure extends Failure {
  final List<dynamic> errors;
  final String? msg;
  ValidationFailure({required this.errors, this.msg}) : super(message: msg ?? 'Validation failure');
}

class ServerFailure extends Failure {
  ServerFailure({required super.message});
}

class CacheFailure extends Failure {
  CacheFailure({required super.message});
}

class NetworkFailure extends Failure {
  NetworkFailure({required super.message});
}

class NotLoginFailure extends Failure {
  NotLoginFailure({required super.message});
}