part of 'select_card_bloc.dart';

@freezed
class SelectCardEvent with _$SelectCardEvent {
  const factory SelectCardEvent.initialize(List<CreditCardInfo> creditCards) =
      Initialize;

  const factory SelectCardEvent.getCreditCards() = GetCreditCards;
  const factory SelectCardEvent.animate(int length) = Animate;
  const factory SelectCardEvent.selectCard(CreditCardInfo creditCardInfo) =
      SelectCard;

  const factory SelectCardEvent.updateList() = _UpdateList;
  const factory SelectCardEvent.deleteCreditCard() = DeleteCreditCard;
}
