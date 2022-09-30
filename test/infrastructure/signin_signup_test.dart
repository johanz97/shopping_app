import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart' as injection;
import 'package:logger/logger.dart';
import 'package:parking_web_app_maicero_shop/domain/user/i_user_repository.dart';
import 'package:parking_web_app_maicero_shop/injection.dart';
import 'package:path_provider/path_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:test/test.dart';

Future<void> main() async {
  configureInjection(injection.Environment.prod);
  Hive.init((await getApplicationDocumentsDirectory()).path);
  await Hive.openBox('app');
  await Hive.openBox('userData');
  getIt<Dio>().options.baseUrl = "https://api-dev.super.cash/v2/";
  getIt<Dio>().options.headers["X-Supercash-Marketplace-Id"] = 14824;
  final _logger = getIt<Logger>();

  //SignUp test
  test('SignUp test', () async {
    //Generate temporary email: https://temp-mail.org/es/
    const email = 'kogef24693@zoeyy.com';
    const password = 'password';
    _logger.d('Running SignUp test');
    try {
      final userRepository = getIt<IUserRepository>();

      //SignUp test
      final signUpEither = await userRepository.signUp(email: email);
      assert(signUpEither.isRight());

      final token = signUpEither
          .fold((f) => null, (u) => u)!
          .preferredEmail
          .confirmationToken;
      //Create password test
      final createPasswordEither = await userRepository.createUserPassword(
        token: token,
        password: password,
      );
      assert(createPasswordEither.isRight());

      _logger.d('SignUp test was executed correctly');
    } on Exception catch (_) {
      _logger.e('SignUp test did not run correctly');
    }
  });

  //SignIn test
  test('SignIn test', () async {
    const email = 'marco@super.cash';
    const password = '22222222';
    _logger.d('Running SignIn test');
    try {
      final userRepository = getIt<IUserRepository>();
      final either =
          await userRepository.signIn(email: email, password: password);
      assert(either.isRight());
      _logger.d('SignIn test was executed correctly');
    } on Exception catch (_) {
      _logger.e('SignIn test did not run correctly');
    }
  });
}
