part of 'select_card_bloc.dart';

@freezed
class SelectCardState with _$SelectCardState {
  factory SelectCardState({
    required CreditCardInfo creditCardInfo,
    required List<CreditCardInfo> creditCards,
    PageController? pageController,
    required Option<Either<CreditCardInfoFailure, Unit>> failureOrUpdateCard,
    required Option<Either<CreditCardInfoFailure, List<CreditCardInfo>>>
        failureOrDeleteCard,
    required bool isLoading,
  }) = _Initial;

  factory SelectCardState.initial() => SelectCardState(
        creditCardInfo: CreditCardInfo.test(),
        failureOrDeleteCard: none(),
        failureOrUpdateCard: none(),
        creditCards: [],
        isLoading: false,
      );
}
