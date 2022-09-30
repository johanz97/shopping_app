import 'package:dartz/dartz.dart';

import 'credit_card_info/credit_card_info.dart';
import 'credit_card_info/credit_card_info_failure.dart';

abstract class IWalletRepository {
  Either<CreditCardInfoFailure, Unit> saveCreditCardInfo({
    required CreditCardInfo creditCardInfo,
  });
  Either<CreditCardInfoFailure, List<CreditCardInfo>> getCreditCards();
  Either<CreditCardInfoFailure, Unit> updateCreditCard({
    required CreditCardInfo creditCardInfo,
  });
  Either<CreditCardInfoFailure, List<CreditCardInfo>> deleteCreditCard({
    required CreditCardInfo creditCardInfo,
  });
  Either<CreditCardInfoFailure, Unit> deleteAllCards();
}
