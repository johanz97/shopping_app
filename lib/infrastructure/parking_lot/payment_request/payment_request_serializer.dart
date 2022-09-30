import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/utils.dart';
import '../../../domain/parking_lot/payment_request.dart';
import '../../ticket/ticket_status/ticket_status_serializer.dart';
import '../../user/user/user_serializer.dart';
import '../../wallet/credit_card_info/credit_card_info_serializer.dart';
import '../users_device_info/users_device_info_serializer.dart';

part 'payment_request_serializer.freezed.dart';
part 'payment_request_serializer.g.dart';

@freezed
class PaymentRequestSerializer with _$PaymentRequestSerializer {
  @JsonSerializable(explicitToJson: true)
  factory PaymentRequestSerializer({
    required CreditCardInfoSerializer creditCardSerializer,
    required TicketStatusSerializer ticketStatusSerializer,
    required UserSerializer userSerializer,
    required UsersDeviceInfoSerializer usersDeviceInfoSerializer,
  }) = _PaymentRequestSerializer;

  const PaymentRequestSerializer._();

  factory PaymentRequestSerializer.fromJson(Map<String, dynamic> json) =>
      _$PaymentRequestSerializerFromJson(json);

  factory PaymentRequestSerializer.fromDomain(
    PaymentRequest paymentRequest,
  ) =>
      PaymentRequestSerializer(
        creditCardSerializer:
            CreditCardInfoSerializer.fromDomain(paymentRequest.creditCard),
        ticketStatusSerializer:
            TicketStatusSerializer.fromDomain(paymentRequest.ticketStatus),
        userSerializer: UserSerializer.fromDomain(paymentRequest.user),
        usersDeviceInfoSerializer: UsersDeviceInfoSerializer.fromDomain(
          paymentRequest.usersDeviceInfo,
        ),
      );

  PaymentRequest toDomain() => PaymentRequest(
        creditCard: creditCardSerializer.toDomain(),
        ticketStatus: ticketStatusSerializer.toDomain(),
        user: userSerializer.toDomain(),
        usersDeviceInfo: usersDeviceInfoSerializer.toDomain(),
      );

  Map<String, dynamic> toMap() {
    return {
      'payTicketRequest': {
        'amount': ticketStatusSerializer.value != null &&
                ticketStatusSerializer.paidValue != null
            ? (ticketStatusSerializer.value! * 100) -
                (ticketStatusSerializer.paidValue! * 100)
            : 0,
        'card_number': creditCardSerializer.cardNumber,
        'card_cvv': creditCardSerializer.cardCVVNumber,
        'card_expiration_date':
            "${creditCardSerializer.cardMonth}${creditCardSerializer.cardYear}",
        'card_holder_name': creditCardSerializer.holderName,
        'customer': {
          'external_id': userSerializer.id.toString(),
          'name': userSerializer.name,
          'type': creditCardSerializer.cardType,
          'email': userSerializer.emailsSerializer
              .firstWhere((email) => email.preferred)
              .email,
          'documents': [
            {
              "type": creditCardSerializer.cardType == 'INDIVIDUAL'
                  ? 'CPF'
                  : 'CNPJ',
              "number": creditCardSerializer.cpfCnpj
                  .replaceAll(RegExp(r'[^\w\s]+'), ''),
            }
          ],
          'phone_numbers': [
            if (userSerializer.phoneNumbersSerializer != null)
              '+55${userSerializer.phoneNumbersSerializer!.firstWhere((phone) => phone.preferred).areaCode}${userSerializer.phoneNumbersSerializer!.firstWhere((phone) => phone.preferred).number}'
            else
              '+55'
          ]
        },
        'billing': {
          'name': creditCardSerializer.holderName,
          'address': creditCardSerializer.addressSerializer.toMapParkingLot(),
        },
        'metadata': {
          'sale_id': ticketStatusSerializer.ticketSaleSerializer != null
              ? ticketStatusSerializer.ticketSaleSerializer!.saleId.toString()
              : 0,
          'device_id': userSerializer.id.toString(),
          'private_ip': usersDeviceInfoSerializer.privateIp.trim(),
          'public_ip': usersDeviceInfoSerializer.publicIp.trim(),
          'lapsed_time': getNow()
              .difference(
                DateTime.fromMillisecondsSinceEpoch(
                  ticketStatusSerializer.entraceDate,
                ),
              )
              .inSeconds
        }
      }
    };
  }
}
