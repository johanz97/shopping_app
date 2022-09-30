part of 'sign_up_bloc.dart';

@freezed
class SignUpEvent with _$SignUpEvent {
  const factory SignUpEvent.confirmAcount() = ConfirmAcount;
  const factory SignUpEvent.reSendOtpCode() = ReSendOtpCode;
  const factory SignUpEvent.createUser() = CreateUser;
  const factory SignUpEvent.nextStep() = NextStep;
  const factory SignUpEvent.emailChanged(String email) = EmailChanged;
  const factory SignUpEvent.otpCodeChanged(String otp) = OtpCodeChanged;
  const factory SignUpEvent.passwordChanged(String password) = PasswordChanged;
  const factory SignUpEvent.passwordVerifyChanged(String passwordVerify) =
      PasswordVerifyChanged;
  const factory SignUpEvent.updateUserPassword() = UpdateUserPassword;
  const factory SignUpEvent.setOtpCodeFromServer(String otpCode) =
      SetOtpCodeFromServer;
}
