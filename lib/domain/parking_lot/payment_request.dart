import 'package:freezed_annotation/freezed_annotation.dart';

import '../ticket/ticket_status/ticket_status.dart';
import '../user/user.dart';
import '../wallet/credit_card_info/credit_card_info.dart';
import 'users_device_info/users_device_info.dart';

part 'payment_request.freezed.dart';

@freezed
class PaymentRequest with _$PaymentRequest {
  const factory PaymentRequest({
    required CreditCardInfo creditCard,
    required TicketStatus ticketStatus,
    required User user,
    required UsersDeviceInfo usersDeviceInfo,
  }) = _PaymentRequest;
}
