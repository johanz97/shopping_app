import 'package:freezed_annotation/freezed_annotation.dart';

part 'email.freezed.dart';

@freezed
class Email with _$Email {
  const factory Email({
    required int id,
    required bool preferred,
    required bool activated,
    String? nickname,
    required String confirmationToken,
    required String email,
  }) = _Email;

  factory Email.empty() => const Email(
        id: 0,
        preferred: true,
        activated: true,
        confirmationToken: "",
        email: "",
      );
}
