part of 'app_bloc.dart';

@freezed
class AppEvent with _$AppEvent {
  const factory AppEvent.initializer() = Initializer;
  const factory AppEvent.changeEnv(EnvTag env) = ChangeEnv;
}
