import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../core/utils.dart';

import '../../../domain/user/user.dart';
import '../address/address_serializer.dart';
import '../email/email_serializer.dart';
import '../gender/gender_serializer.dart';
import '../phone_number/phone_number_serializer.dart';
import '../tax_id_type/tax_id_type_serializer.dart';

part 'user_serializer.freezed.dart';
part 'user_serializer.g.dart';

@freezed
class UserSerializer with _$UserSerializer {
  @JsonSerializable(explicitToJson: true)
  factory UserSerializer({
    required int id,
    String? taxId,
    @JsonKey(name: 'taxIdType') TaxIdTypeSerializer? taxIdTypeSerializer,
    String? name,
    String? description,
    String? thumbnailUrl,
    String? thumbnailBase64,
    @JsonKey(name: 'emails') required List<EmailSerializer> emailsSerializer,
    @JsonKey(name: 'phoneNumbers')
        List<PhoneNumberSerializer>? phoneNumbersSerializer,
    @JsonKey(name: 'addresses') List<AddressSerializer>? addressesSerializer,
    required bool activated,
    required int signupDateTime,
    String? birth,
    @JsonKey(name: 'gender') required GenderSerializer genderSerializer,
    String? password,
  }) = _UserSerializer;

  const UserSerializer._();

  factory UserSerializer.fromJson(Map<String, dynamic> json) =>
      _$UserSerializerFromJson(json);

  factory UserSerializer.fromDomain(User user) => UserSerializer(
        id: user.id,
        taxId: user.taxId,
        taxIdTypeSerializer: user.taxIdType != null
            ? TaxIdTypeSerializer.fromDomain(user.taxIdType!)
            : null,
        name: user.name,
        description: user.description,
        thumbnailUrl: user.thumbnailUrl,
        thumbnailBase64: user.thumbnailBase64,
        emailsSerializer:
            user.emails.map((e) => EmailSerializer.fromDomain(e)).toList(),
        phoneNumbersSerializer: user.phoneNumbers != null
            ? user.phoneNumbers!
                .map((e) => PhoneNumberSerializer.fromDomain(e))
                .toList()
            : null,
        addressesSerializer: user.addresses != null
            ? user.addresses!
                .map((e) => AddressSerializer.fromDomain(e))
                .toList()
            : null,
        activated: user.activated,
        signupDateTime: user.signupDateTime.millisecondsSinceEpoch,
        birth: user.birth.toString(),
        genderSerializer: GenderSerializer.fromDomain(user.gender),
        password: user.password,
      );

  User toDomain() => User(
        id: id,
        taxId: taxId,
        taxIdType: taxIdTypeSerializer != null
            ? taxIdTypeSerializer!.toDomain()
            : null,
        name: name,
        description: description,
        thumbnailUrl: thumbnailUrl,
        thumbnailBase64: thumbnailBase64,
        emails: emailsSerializer.map((e) => e.toDomain()).toList(),
        phoneNumbers: phoneNumbersSerializer != null
            ? phoneNumbersSerializer!.map((e) => e.toDomain()).toList()
            : null,
        addresses: addressesSerializer != null
            ? addressesSerializer!.map((e) => e.toDomain()).toList()
            : null,
        preferredEmail: emailsSerializer
            .firstWhere(
              (email) => email.preferred,
            )
            .toDomain(),
        preferredPhoneNumber: phoneNumbersSerializer != null
            ? phoneNumbersSerializer!
                .firstWhere(
                  (phone) => phone.preferred,
                )
                .toDomain()
            : null,
        preferredAddress: addressesSerializer != null
            ? addressesSerializer!
                .firstWhere(
                  (address) => address.preferred,
                )
                .toDomain()
            : null,
        activated: activated,
        signupDateTime: DateTime.fromMillisecondsSinceEpoch(signupDateTime),
        birth: birth != null ? Utils.fromUSADateToDateTime(birth!) : null,
        gender: genderSerializer.toDomain(),
        password: password,
      );
}
