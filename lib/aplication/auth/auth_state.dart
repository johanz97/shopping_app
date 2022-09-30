part of 'auth_bloc.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = Initial;
  const factory AuthState.loading() = Loading;
  const factory AuthState.authenticated({required bool isNewUser}) =
      Authenticated;
  const factory AuthState.modeFailure(UserFailure failure) = ModeFailure;
  const factory AuthState.unauthenticated() = Unauthenticated;
}
