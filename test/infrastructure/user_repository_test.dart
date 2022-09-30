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
  getIt<Dio>().options.baseUrl = "https://api-dev.super.cash/v2/";
  Hive.init((await getApplicationDocumentsDirectory()).path);
  getIt<Dio>().options.headers["Authorization"] =
      'eyJhbGciOiJIUzI1NiJ9.eyJtYXJrZXRwbGFjZV9pZCI6MTQ4MjQsImlkIjoxNTI0MSwiZXhwIjoxNjQzMTM2ODI1LCJhdXRob3JpemF0aW9uX3R5cGUiOiJVU0VSIn0.7QnoVapQXLJ1iJpaXEAJ-e5pQKWPRb5_v4bh2Igb-Co';
  await Hive.openBox<Map>('genres');
  final Logger _logger = getIt<Logger>();

  //Get all genres test
  test('Get all genres test', () async {
    _logger.d('Running get all genres test');
    try {
      final IUserRepository userRepository = getIt<IUserRepository>();
      final gendersEither = await userRepository.getAllGenders();
      assert(gendersEither.isRight());
      _logger.d('Get all genres test was executed correctly');
    } catch (e) {
      _logger.e('Get all genres test did not run correctly');
    }
  });

  //Get user test
  test('Get user test', () async {
    _logger.d('Running get user test');
    try {
      final IUserRepository userRepository = getIt<IUserRepository>();
      final gendersEither = await userRepository.getUser();
      assert(gendersEither.isRight());
      _logger.d('Get user test was executed correctly');
    } catch (e) {
      _logger.e('Get user test did not run correctly');
    }
  });

  //Patch phone number test
  test('Patch phone number test', () async {
    _logger.d('Running patch phone number test');
    try {
      final IUserRepository userRepository = getIt<IUserRepository>();
      final Map<String, dynamic> phone = {
        'id': 15243,
        'preferred': true,
        'activated': false,
        'confirmationToken': '026746',
        'country': {'id': 0, 'name': 'Brasil', 'code': 55},
        'areaCode': 23,
        'number': 232333333
      };
      final gendersEither = await userRepository.patchPhoneNumber(phone: phone);
      assert(gendersEither.isRight());
      _logger.d('Patch phone number test was executed correctly');
    } catch (e) {
      _logger.e('Patch phone number test did not run correctly');
    }
  });

  //Patch email test
  test('Patch email test', () async {
    _logger.d('Running patch email test');
    try {
      final IUserRepository userRepository = getIt<IUserRepository>();
      final Map<String, dynamic> email = {
        'id': 15242,
        'preferred': true,
        'activated': true,
        'confirmationToken': '814931',
        'email': "marco@super.cash"
      };
      final emailEither = await userRepository.patchEmail(email: email);
      assert(emailEither.isRight());
      _logger.d('Patch email test was executed correctly');
    } catch (e) {
      _logger.e('Patch email test did not run correctly');
    }
  });

  //Save user address test
  test('Save user address test', () async {
    _logger.d('Running save user address test');
    try {
      final IUserRepository userRepository = getIt<IUserRepository>();
      final Map<String, dynamic> address = {
        "city": "Arapiraca",
        "complement": "lado ímpar",
        "country": {'id': 0, 'name': 'Brasil', 'code': 55},
        "neighborhood": "string",
        "nickname": "Casass",
        "number": "0000",
        "preferred": true,
        "state": "Alagoas",
        "stateCode": "AL",
        "street": "street",
        "zipcode": "57309610"
      };
      final gendersEither =
          await userRepository.saveUserAddress(address: address);
      assert(gendersEither.isRight());
      _logger.d('Save user address test was executed correctly');
    } catch (e) {
      _logger.e('Save user address test did not run correctly');
    }
  });

  //Patch user address test
  test('Patch user address test', () async {
    _logger.d('Running patch user address test');
    try {
      final IUserRepository userRepository = getIt<IUserRepository>();
      final Map<String, dynamic> address = {
        "id": 17182,
        "city": "Sto Domingo",
        "complement": "lado ímpar",
        "country": {'id': 0, 'name': 'Brasil', 'code': 55},
        "neighborhood": "string",
        "nickname": "Casasss",
        "number": "0000",
        "preferred": true,
        "state": "Alagoas",
        "stateCode": "AL",
        "street": "street",
        "zipcode": "57309610"
      };
      final gendersEither =
          await userRepository.patchUserAddress(address: address);
      assert(gendersEither.isRight());
      _logger.d('Patch user address test was executed correctly');
    } catch (e) {
      _logger.e('Patch user address test did not run correctly');
    }
  });

  //Delete user address test
  test('Delete user address test', () async {
    _logger.d('Running delete user address test');
    try {
      final IUserRepository userRepository = getIt<IUserRepository>();
      final gendersEither =
          await userRepository.deleteUserAddress(addressId: 17182);
      assert(gendersEither.isRight());
      _logger.d('Delete user address test was executed correctly');
    } catch (e) {
      _logger.e('Delete user address test did not run correctly');
    }
  });
}
