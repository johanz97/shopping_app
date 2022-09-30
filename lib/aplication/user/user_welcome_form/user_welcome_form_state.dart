part of 'user_welcome_form_bloc.dart';

@freezed
class UserWelcomeFormState with _$UserWelcomeFormState {
  factory UserWelcomeFormState({
    required int totalStepts,
    required int actualStep,
  }) = _Initial;
  factory UserWelcomeFormState.initial() => UserWelcomeFormState(
        actualStep: 0,
        totalStepts: 3,
      );
}
