import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/user/email/email.dart';

part 'email_serializer.freezed.dart';
part 'email_serializer.g.dart';

@freezed
class EmailSerializer with _$EmailSerializer {
  @JsonSerializable(createToJson: true)
  factory EmailSerializer({
    required int id,
    required bool preferred,
    required bool activated,
    String? nickname,
    required String confirmationToken,
    required String email,
  }) = _EmailSerializer;

  const EmailSerializer._();

  factory EmailSerializer.fromJson(Map<String, dynamic> json) =>
      _$EmailSerializerFromJson(json);

  factory EmailSerializer.fromDomain(Email email) => EmailSerializer(
        id: email.id,
        preferred: email.preferred,
        activated: email.activated,
        nickname: email.nickname,
        confirmationToken: email.confirmationToken,
        email: email.email,
      );

  Email toDomain() => Email(
        id: id,
        preferred: preferred,
        activated: activated,
        nickname: nickname,
        confirmationToken: confirmationToken,
        email: email,
      );
}
