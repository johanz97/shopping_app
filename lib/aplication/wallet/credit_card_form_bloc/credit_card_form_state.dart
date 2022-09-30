part of 'credit_card_form_bloc.dart';

@freezed
class CreditCardFormState with _$CreditCardFormState {
  const factory CreditCardFormState({
    required String cardNumber,
    required String holderName,
    required String cardCvvNumber,
    required String dateExp,
    required bool hasErrors,
    required bool isLoading,
    required bool flipCard,
    required bool showCheck,
    required bool isConfirmed,
    required bool isEditing,
    required FocusNode cardNumberNode,
    required FocusNode expiryDateNode,
    required FocusNode cardHolderNode,
    required MaskedTextController cardNumberController,
    required MaskedTextController expiryDateController,
    required MaskedTextController cardHolderNameController,
    required MaskedTextController cvvCodeController,
    required Option<Either<CreditCardInfoFailure, CreditCardInfo>>
        failureOrCreditCard,
    required Option<Either<CreditCardInfoFailure, Unit>> failureOrUpdate,
  }) = _CreditCardFormState;

  factory CreditCardFormState.initial() => CreditCardFormState(
        cardNumber: '',
        cardCvvNumber: '',
        holderName: '',
        dateExp: '',
        flipCard: false,
        isLoading: false,
        hasErrors: false,
        failureOrCreditCard: none(),
        cardHolderNameController:
            MaskedTextController(mask: 'AAAAAAAAAAAAAAAAAAAAAAAAA'),
        cardNumberController: MaskedTextController(mask: '0000 0000 0000 0000'),
        cvvCodeController: MaskedTextController(mask: '0000'),
        expiryDateController: MaskedTextController(mask: '00/0000'),
        cardHolderNode: FocusNode(),
        cardNumberNode: FocusNode(),
        expiryDateNode: FocusNode(),
        isConfirmed: false,
        showCheck: false,
        failureOrUpdate: none(),
        isEditing: false,
      );
}
