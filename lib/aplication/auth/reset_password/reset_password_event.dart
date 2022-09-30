part of 'reset_password_bloc.dart';

@freezed
class ResetPasswordEvent with _$ResetPasswordEvent {
  const factory ResetPasswordEvent.resetPassword() = ResetPassword;
  const factory ResetPasswordEvent.nextStep() = NextStep;
  const factory ResetPasswordEvent.sendOtpCode() = SendOtpCode;
  const factory ResetPasswordEvent.reSendOtpCode() = ReSendOtpCode;
  const factory ResetPasswordEvent.emailChanged(String email) = EmailChanged;
  const factory ResetPasswordEvent.otpCodeChanged(String otp) = OtpCodeChanged;
  const factory ResetPasswordEvent.passwordChanged(String password) =
      PasswordChanged;
  const factory ResetPasswordEvent.passwordUpdate() = PasswordUpdate;
  const factory ResetPasswordEvent.passwordVerifyChanged(
    String passwordVerify,
  ) = PasswordVerifyChanged;
}
