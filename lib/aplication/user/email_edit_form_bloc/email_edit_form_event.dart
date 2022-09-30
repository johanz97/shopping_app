part of 'email_edit_form_bloc.dart';

@freezed
class EmailEditFormEvent with _$EmailEditFormEvent {
  const factory EmailEditFormEvent.initialize(String email) = Initialize;
  const factory EmailEditFormEvent.updateEmail() = UpdateEmail;
  const factory EmailEditFormEvent.confirmEmail() = ConfirmEmail;
  const factory EmailEditFormEvent.reSendOtpCode() = ReSendOtpCode;
  const factory EmailEditFormEvent.nextStep() = NextStep;
  const factory EmailEditFormEvent.emailChanged(String email) = EmailChanged;
  const factory EmailEditFormEvent.otpCodeChanged(String otp) = OtpCodeChanged;

  const factory EmailEditFormEvent.setOtpCodeFromServer(String otpCode) =
      SetOtpCodeFromServer;
}
