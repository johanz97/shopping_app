part of 'app_bloc.dart';

@freezed
class AppState with _$AppState {
  const factory AppState({
    EnvTag? actualEnvTag,
    Env? actualEnv,
    required Option<Either<EnvFailure, Env>> initFailureOrSuccessOption,
  }) = _Initial;

  factory AppState.initial() => AppState(
        initFailureOrSuccessOption: none(),
      );
}
