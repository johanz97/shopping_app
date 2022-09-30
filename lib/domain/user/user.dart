import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/config_reader.dart';
import 'address/address.dart';
import 'country/country.dart';
import 'email/email.dart';
import 'gender/gender.dart';
import 'phone_number/phone_number.dart';
import 'tax_id_type/tax_id_type.dart';

part 'user.freezed.dart';

@freezed
class User with _$User {
  const factory User({
    required int id,
    String? taxId,
    TaxIdType? taxIdType,
    String? name,
    String? description,
    String? thumbnailUrl,
    String? thumbnailBase64,
    required List<Email> emails,
    List<PhoneNumber>? phoneNumbers,
    List<Address>? addresses,
    required Email preferredEmail,
    PhoneNumber? preferredPhoneNumber,
    Address? preferredAddress,
    required bool activated,
    required DateTime signupDateTime,
    DateTime? birth,
    required Gender gender,
    String? password,
  }) = _User;

  factory User.empty() => User(
        id: 0,
        emails: [Email.empty()],
        activated: false,
        signupDateTime: DateTime.now(),
        gender: Gender.empty(),
        preferredEmail: Email.empty(),
      );

  factory User.test() {
    final userTest = ConfigReader.getTestUser();
    return User(
      activated: true,
      phoneNumbers: [PhoneNumber.empty()],
      preferredPhoneNumber: PhoneNumber.empty(),
      birth: DateTime.now(),
      emails: [
        Email(
          id: 1,
          preferred: true,
          activated: true,
          confirmationToken: userTest["otp"] as String,
          email: userTest["email"] as String,
        )
      ],
      password: userTest["password"] as String,
      gender: const Gender(
        id: 1,
        description: "Unknown",
      ),
      id: 1,
      preferredEmail: Email(
        id: 1,
        preferred: true,
        activated: true,
        confirmationToken: userTest["otp"] as String,
        email: userTest["email"] as String,
      ),
      signupDateTime: DateTime.now(),
      addresses: [
        const Address(
          preferred: true,
          activated: true,
          nickname: "Casa",
          confirmationToken: "",
          zipcode: "57309610",
          state: "Alogoas",
          stateCode: "",
          city: "Arapiraca",
          neighborhood: "Massaranduba",
          street: "Rua Amelia",
          number: "123",
          complement: "Lado impar",
          country: Country(
            code: 0,
            name: "Brazil",
            id: 0,
          ),
        )
      ],
      preferredAddress: const Address(
        preferred: true,
        activated: true,
        nickname: "",
        confirmationToken: "",
        zipcode: "57309610",
        state: "Alogoas",
        stateCode: "",
        city: "Arapiraca",
        neighborhood: "Massaranduba",
        street: "Rua Amelia",
        number: "",
        complement: "Lado impar",
        country: Country(
          code: 0,
          name: "Brazil",
          id: 0,
        ),
      ),
    );
  }
}
