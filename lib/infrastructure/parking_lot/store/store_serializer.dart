import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/parking_lot/store/store.dart';
import '../../user/address/address_serializer.dart';
import '../../user/email/email_serializer.dart';
import '../../user/phone_number/phone_number_serializer.dart';
import '../../user/tax_id_type/tax_id_type_serializer.dart';

part 'store_serializer.freezed.dart';
part 'store_serializer.g.dart';

@freezed
class StoreSerializer with _$StoreSerializer {
  @JsonSerializable(explicitToJson: true)
  factory StoreSerializer({
    required int id,
    required String taxId,
    TaxIdTypeSerializer? taxIdTypeSerializer,
    required String name,
    required String description,
    required bool activated,
    required int signupDateTime,
    required String thumbnailUrl,
    required String companyName,
    required bool alwaysOnline,
    String? lastStoreInvoiceId,
    EmailSerializer? preferredEmailSerializer,
    AddressSerializer? preferredAddressSerializer,
    PhoneNumberSerializer? preferredPhoneNumberSerializer,
    List<EmailSerializer>? emailsSerializer,
    List<PhoneNumberSerializer>? phoneNumbersSerializer,
    List<AddressSerializer>? addressesSerializer,
    List<AddressSerializer>? shippingAddressesSerializer,
  }) = _StoreSerializer;

  const StoreSerializer._();

  factory StoreSerializer.fromJson(Map<String, dynamic> json) =>
      _$StoreSerializerFromJson(json);

  Store toDomain() => Store(
        id: id,
        taxId: taxId,
        taxIdType: taxIdTypeSerializer != null
            ? taxIdTypeSerializer!.toDomain()
            : null,
        name: name,
        description: description,
        activated: activated,
        signupDateTime: signupDateTime,
        thumbnailUrl: thumbnailUrl,
        companyName: companyName,
        alwaysOnline: alwaysOnline,
        lastStoreInvoiceId: lastStoreInvoiceId,
        preferredEmail: preferredEmailSerializer != null
            ? preferredEmailSerializer!.toDomain()
            : null,
        preferredAddress: preferredAddressSerializer != null
            ? preferredAddressSerializer!.toDomain()
            : null,
        preferredPhoneNumber: preferredPhoneNumberSerializer != null
            ? preferredPhoneNumberSerializer!.toDomain()
            : null,
        emails: emailsSerializer != null
            ? emailsSerializer!.map((e) => e.toDomain()).toList()
            : null,
        phoneNumbers: phoneNumbersSerializer != null
            ? phoneNumbersSerializer!.map((e) => e.toDomain()).toList()
            : null,
        addresses: addressesSerializer != null
            ? addressesSerializer!.map((e) => e.toDomain()).toList()
            : null,
        shippingAddresses: shippingAddressesSerializer != null
            ? shippingAddressesSerializer!.map((e) => e.toDomain()).toList()
            : null,
      );
}
