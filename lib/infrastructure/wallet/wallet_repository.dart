import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

import '../../domain/wallet/credit_card_info/credit_card_info.dart';
import '../../domain/wallet/credit_card_info/credit_card_info_failure.dart';
import '../../domain/wallet/i_wallet_repository.dart';
import '../core/local_repository.dart';
import 'credit_card_info/credit_card_info_serializer.dart';

@LazySingleton(as: IWalletRepository)
class WalletRepository implements IWalletRepository {
  final Logger _logger;
  final String creditCardKeyList = 'credit_card_list';

  WalletRepository(this._logger);

  //Saves the list of the user's credit cards in the LocalRepository.
  Either<CreditCardInfoFailure, Unit> _saveCreditCardList(
    List<CreditCardInfo> creditCards,
  ) {
    _logger.d('Saving credit card list');
    try {
      final List<Map<String, dynamic>> creditCardsMap = creditCards
          .map(
            (eachCreditCardInfo) =>
                CreditCardInfoSerializer.fromDomain(eachCreditCardInfo)
                    .toJson(),
          )
          .toList();
      LocalRepository.setCreditCardsList(
        creditCards: creditCardsMap,
      );
      _logger.d('List of credit cards saved: $creditCardsMap');
      return right(unit);
    } on Exception catch (e) {
      _logger.e(
        'Unexpected error: $e in the function _saveCreditCardList() on wallet_repository',
      );
      return left(CreditCardInfoFailure.unexpected());
    }
  }

  //Allows to delete all the user's credit cards.
  @override
  Either<CreditCardInfoFailure, Unit> deleteAllCards() {
    _logger.d('Deleting credit cards');
    try {
      LocalRepository.deleteAllCards();
      _logger.d('Credit cards deleted');
      return right(unit);
    } on Exception catch (e) {
      _logger.e(
        'Unexpected error: $e in the function deleteAllCards() on wallet_repository',
      );
      return left(CreditCardInfoFailure.unexpected());
    }
  }

  //Allows to delete a credit card by its id and returns the updated card list.
  @override
  Either<CreditCardInfoFailure, List<CreditCardInfo>> deleteCreditCard({
    required CreditCardInfo creditCardInfo,
  }) {
    _logger.d('Deleting credit card: $creditCardInfo');
    try {
      final List<CreditCardInfo>? creditCards =
          getCreditCards().fold((l) => null, (creditCards) => creditCards);
      if (creditCards != null) {
        creditCards.removeWhere(
          (eachCreditCardInfo) =>
              eachCreditCardInfo.cardNumber == creditCardInfo.cardNumber,
        );
        deleteAllCards();
        _saveCreditCardList(creditCards);
        _logger.d('Credit card deleted');
      }
      return right(creditCards!);
    } catch (e) {
      _logger.e(
        'Unexpected error: $e in the function deleteCreditCard() on wallet_repository',
      );
      return left(CreditCardInfoFailure.unexpected());
    }
  }

  //Allows to obtain the user's credit cards stored in the LocalRepository.
  @override
  Either<CreditCardInfoFailure, List<CreditCardInfo>> getCreditCards() {
    _logger.d('Getting credit cards');
    try {
      final List<Map<String, dynamic>>? result =
          LocalRepository.getCreditCardsList();
      if (result != null) {
        final List<CreditCardInfo> creditCardKeyList = result
            .map((cards) => CreditCardInfoSerializer.fromJson(cards).toDomain())
            .toList();
        return right(creditCardKeyList);
      }
      _logger.e('No credit cards');
      return right([]);
    } catch (e) {
      _logger.e(
        'Unexpected error: $e in the function getCreditCards() on wallet_repository',
      );
      return left(CreditCardInfoFailure.unexpected());
    }
  }

  //Allows to save the information of a credit card.
  @override
  Either<CreditCardInfoFailure, Unit> saveCreditCardInfo({
    required CreditCardInfo creditCardInfo,
  }) {
    _logger.d('Saving credit card information: $creditCardInfo');
    try {
      List<CreditCardInfo>? creditCards =
          getCreditCards().fold((l) => null, (creditCards) => creditCards);
      creditCards ??= [];
      bool existe = false;
      for (final card in creditCards) {
        if (card.cardNumber == creditCardInfo.cardNumber) {
          existe = true;
        }
      }
      if (!existe) {
        creditCards.add(creditCardInfo);
        _logger.d('Credit card information saved: $creditCardInfo');
      } else {
        _logger.e('Credit card information already exists: $creditCardInfo');
        return left(CreditCardInfoFailure.creditCardAlreadyExists());
      }
      deleteAllCards();
      _saveCreditCardList(
        creditCards,
      );
      return right(unit);
    } on Exception catch (e) {
      _logger.e(
        'Unexpected error: $e in the function saveCreditCardInfo() on wallet_repository',
      );
      return left(CreditCardInfoFailure.unexpected());
    }
  }

  //Allows you to update the information of a credit card searched by its id.
  @override
  Either<CreditCardInfoFailure, Unit> updateCreditCard({
    required CreditCardInfo creditCardInfo,
  }) {
    _logger.d('Updating credit card information: $creditCardInfo');
    try {
      final List<CreditCardInfo>? creditCards =
          getCreditCards().fold((l) => null, (creditCards) => creditCards);
      if (creditCards != null) {
        creditCards.removeWhere(
          (eachCreditCardInfo) =>
              eachCreditCardInfo.cardNumber == creditCardInfo.cardNumber,
        );
        creditCards.add(creditCardInfo);
        _saveCreditCardList(creditCards);
        _logger.d('Credit card information updated: $creditCardInfo');
      } else {
        _logger.d('Credit card information not updated: $creditCardInfo');
      }
      return right(unit);
    } on Exception catch (e) {
      _logger.e(
        'Unexpected error: $e in the function updateCreditCard() on wallet_repository',
      );
      return left(CreditCardInfoFailure.unexpected());
    }
  }
}
