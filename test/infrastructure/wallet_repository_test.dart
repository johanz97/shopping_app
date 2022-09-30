import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart' as injection;
import 'package:logger/logger.dart';
import 'package:parking_web_app_maicero_shop/domain/user/address/address.dart';
import 'package:parking_web_app_maicero_shop/domain/user/country/country.dart';
import 'package:parking_web_app_maicero_shop/domain/wallet/credit_card_info/credit_card_info.dart';
import 'package:parking_web_app_maicero_shop/domain/wallet/i_wallet_repository.dart';
import 'package:parking_web_app_maicero_shop/injection.dart';
import 'package:path_provider/path_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:test/test.dart';

Future<void> main() async {
  configureInjection(injection.Environment.prod);
  Hive.init((await getApplicationDocumentsDirectory()).path);
  await Hive.openBox('app');
  await Hive.openBox<Map>('credit_cards');
  final Logger _logger = getIt<Logger>();
  const Country country = Country(id: 0, name: 'Brasil', code: 55);
  const Address address = Address(
    id: 0,
    preferred: true,
    activated: false,
    nickname: 'Casa',
    confirmationToken: '989621',
    zipcode: '57309610',
    state: 'Alagoas',
    stateCode: 'AL',
    city: 'Arapiraca',
    neighborhood: 'Massaranduba',
    street: 'Rua Amélia Nunes Correia',
    number: '123',
    complement: 'lado ímpar',
    country: country,
  );

  //Save credit card test
  test('Save credit card test', () {
    _logger.d('Running save credit card test');
    try {
      final IWalletRepository walletRepository = getIt<IWalletRepository>();
      const CreditCardInfo creditCard = CreditCardInfo(
        cardCVVNumber: '123',
        cardMonth: '03',
        cardYear: '2026',
        cardNumber: '4111111111111111',
        cardType: CreditCardType.indivudual,
        holderName: 'Jose da Silva',
        address: address,
        cpfCnpj: '993.030.200-06',
      );
      final saveEither =
          walletRepository.saveCreditCardInfo(creditCardInfo: creditCard);
      assert(saveEither.isRight());
      _logger.d('Save credit card test was executed correctly');
    } catch (e) {
      _logger.e('Save credit card test did not run correctly');
    }
  });

  //Patch credit card test
  test('Patch credit card test', () {
    _logger.d('Running patch credit card test');
    try {
      final IWalletRepository walletRepository = getIt<IWalletRepository>();
      const CreditCardInfo creditCard = CreditCardInfo(
        cardCVVNumber: '123',
        cardMonth: '03',
        cardYear: '2026',
        cardNumber: '4111111111111111',
        cardType: CreditCardType.indivudual,
        holderName: 'Pedro Pablo Leon',
        address: address,
        cpfCnpj: '993.030.200-06',
      );
      final patchEither =
          walletRepository.updateCreditCard(creditCardInfo: creditCard);
      assert(patchEither.isRight());
      _logger.d('Patch credit card test was executed correctly');
    } catch (e) {
      _logger.e('Patch credit card test did not run correctly');
    }
  });

  //Delete credit card test
  test('Delete credit card test', () {
    _logger.d('Running delete credit card test');
    try {
      final IWalletRepository walletRepository = getIt<IWalletRepository>();
      const CreditCardInfo creditCard = CreditCardInfo(
        cardCVVNumber: '123',
        cardMonth: '03',
        cardYear: '2026',
        cardNumber: '4111111111111111',
        cardType: CreditCardType.indivudual,
        holderName: 'Pedro Pablo Leon',
        address: address,
        cpfCnpj: '993.030.200-06',
      );
      final deleteEither =
          walletRepository.deleteCreditCard(creditCardInfo: creditCard);
      assert(deleteEither.isRight());
      _logger.d('Delete credit card test was executed correctly');
    } catch (e) {
      _logger.e('Delete credit card test did not run correctly');
    }
  });
}
