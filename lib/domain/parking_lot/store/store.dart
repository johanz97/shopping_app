import 'package:freezed_annotation/freezed_annotation.dart';

import '../../user/address/address.dart';
import '../../user/email/email.dart';
import '../../user/phone_number/phone_number.dart';
import '../../user/tax_id_type/tax_id_type.dart';

part 'store.freezed.dart';

@freezed
class Store with _$Store {
  const factory Store({
    required int id,
    required String taxId,
    TaxIdType? taxIdType,
    required String name,
    required String description,
    required bool activated,
    required int signupDateTime,
    required String thumbnailUrl,
    required String companyName,
    required bool alwaysOnline,
    String? lastStoreInvoiceId,
    Email? preferredEmail,
    Address? preferredAddress,
    PhoneNumber? preferredPhoneNumber,
    List<Email>? emails,
    List<PhoneNumber>? phoneNumbers,
    List<Address>? addresses,
    List<Address>? shippingAddresses,
  }) = _Store;
}
