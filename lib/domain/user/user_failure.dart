import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_failure.freezed.dart';

//Definition of existing errors in the user object
@freezed
class UserFailure with _$UserFailure {
  factory UserFailure.cpfAlreadyExists() = CpfAlreadyExists;
  factory UserFailure.emailAlreadyExists() = EmailAlreadyExists;
  factory UserFailure.emailNotFound() = EmailNotFound;
  factory UserFailure.incorrectEmailOrPassword() = IncorrectEmailOrPassword;
  factory UserFailure.notInternet() = NotInternet;
  factory UserFailure.notLogIn() = NotLogIn;
  factory UserFailure.otpCodeIncorrect() = OtpCodeIncorrect;
  factory UserFailure.phoneNumberAlreadyExists() = PhoneNumberAlreadyExists;
  factory UserFailure.serverIsDown() = ServerIsDown;
  factory UserFailure.timeLimitExceeded() = TimeLimitExceeded;
  factory UserFailure.unexpected() = Unexpected;
  factory UserFailure.addressNotFound() = AddressNotFound;
}
