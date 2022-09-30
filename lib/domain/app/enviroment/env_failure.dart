import 'package:freezed_annotation/freezed_annotation.dart';

part 'env_failure.freezed.dart';

//Definition of existing errors in the env object
@freezed
class EnvFailure with _$EnvFailure {
  factory EnvFailure.notInternet() = NotInternet;
  factory EnvFailure.unexpected() = Unexpected;
  factory EnvFailure.timeLimitExceeded() = TimeLimitExceeded;
  factory EnvFailure.serverErrorDown() = ServerErrorDown;
}
