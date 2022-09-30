part of 'credit_card_form_bloc.dart';

@freezed
class CreditCardFormEvent with _$CreditCardFormEvent {
  const factory CreditCardFormEvent.initialized({CreditCardInfo? card}) =
      Initialized;
  const factory CreditCardFormEvent.flipCard() = _FlipCard;
  const factory CreditCardFormEvent.nameChanged(String name) = NameChanged;
  const factory CreditCardFormEvent.cardNumberChanged(String number) =
      CardNumberChanged;
  const factory CreditCardFormEvent.cardDateChanged(String date) =
      CardDateChanged;
  const factory CreditCardFormEvent.cvvCodeChanged(String cvv) = CvvCodeChanged;
  const factory CreditCardFormEvent.validateData() = ValidateData;
  const factory CreditCardFormEvent.save() = Save;
  const factory CreditCardFormEvent.update() = Update;
  const factory CreditCardFormEvent.confirmedChanged() = ConfirmedChanged;
  const factory CreditCardFormEvent.showCheck({required bool show}) = ShowCheck;
}
