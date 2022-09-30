part of 'user_profile_bloc.dart';

@freezed
class UserProfileState with _$UserProfileState {
  factory UserProfileState({
    required User user,
    required bool isLoading,
    required bool hasErrors,
    required Option<Either<UserFailure, User>> failureOrSuccess,
  }) = _Initial;

  factory UserProfileState.initial() => UserProfileState(
        user: User.test(),
        isLoading: false,
        failureOrSuccess: none(),
        hasErrors: false,
      );
}
