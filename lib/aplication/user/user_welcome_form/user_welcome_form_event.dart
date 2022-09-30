part of 'user_welcome_form_bloc.dart';

@freezed
class UserWelcomeFormEvent with _$UserWelcomeFormEvent {
  const factory UserWelcomeFormEvent.nextStep() = NextStep;
  const factory UserWelcomeFormEvent.finishProcess() = FinishProcess;
  const factory UserWelcomeFormEvent.initialize() = Initialize;
}
