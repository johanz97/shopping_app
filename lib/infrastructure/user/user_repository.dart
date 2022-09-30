import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:logger/logger.dart';

import '../../domain/user/address/address.dart';
import '../../domain/user/gender/gender.dart';
import '../../domain/user/i_user_repository.dart';
import '../../domain/user/user.dart';
import '../../domain/user/user_failure.dart';
import '../core/local_repository.dart';
import 'address/address_serializer.dart';
import 'gender/gender_serializer.dart';
import 'user/user_serializer.dart';

@LazySingleton(as: IUserRepository)
class UserRepository implements IUserRepository {
  final Dio _dio;
  final Logger _logger;

  static const String _getGenderList = "users/genders";
  static const String _createUserPassword = 'users/redefinePassword';
  static const String _forgetPassword = "users/requestForgottenPassword";
  static const String _patchPhoneNumber = "users/phonenumbers/";
  static const String _patchUserPassword = "users/changePassword";
  static const String _postPhotoUser = "users/thumbnail";
  static const String _redefinePassword = "users/redefinePassword";
  static const String _refreshToken = 'users/refreshAuthToken';
  static const String _resentConfirmationEmail = 'users/requestNewAccountToken';
  static const String _sendSignUpTokenConfirmation = 'users/activate/';
  static const String _signUpUrl = 'users/entity';
  static const String _signInUrl = 'users/login';
  static const String _user = "users/";
  static const String _userAddress = "users/addresses";
  static const String _userEmail = 'users/emails/';
  static const String _cepServices = "addresses/zip";

  UserRepository(this._dio, this._logger);

  //Check if the session token is valid, otherwise update it.
  @override
  Future<Either<UserFailure, Unit>> refreshAuthToken() async {
    _logger.d('renewing token in with headers: ${_dio.options}');
    try {
      final token = LocalRepository.getToken();
      if (token == null) {
        return left(UserFailure.notLogIn());
      }
      if (JwtDecoder.isExpired(token)) {
        _dio.options.headers['Authorization'] = token;
        final response = await _dio.get(_refreshToken);
        final newToken = response.headers['Authorization']!.first;

        _dio.options.headers['Authorization'] = newToken;
        LocalRepository.setToken(newToken);
        _logger.d('the token was successfully renewed: $token');
      } else {
        _dio.options.headers['Authorization'] = token;
        _logger.d('The tocken is still valid');
      }
      _dio.options.headers['X-Supercash-Uid'] =
          LocalRepository.getSuperCashUid();

      return right(unit);
    } on DioError catch (e) {
      if (e.error is SocketException) {
        if ("${e.error}".contains("Connection refused")) {
          _logger.e(
            "Supercash server is unreachable: ${e.error} in the function: refreshAuthToken() on user_repository",
          );
          return left(UserFailure.serverIsDown());
        } else {
          _logger.e(
            "No internet connection: ${e.error} in the function: refreshAuthToken() on user_repository",
          );
          return left(UserFailure.notInternet());
        }
      } else {
        if (e.response!.statusCode == 500) {
          _logger.e(
            'Critical server error: ${e.message} in the function: refreshAuthToken() on user_repository',
          );
          return left(UserFailure.serverIsDown());
        } else {
          _logger.e(
            'Time limit exceeded: ${e.message} in the function: refreshAuthToken() on user_repository',
          );
          return left(UserFailure.timeLimitExceeded());
        }
      }
    } on Exception catch (e) {
      _logger.e(
        'Unexpected error: $e in the function refreshAuthToken() on user_repository',
      );
      return left(UserFailure.unexpected());
    }
  }

  //Allows the user to log into the application and saves it in the LocalStorage.
  @override
  Future<Either<UserFailure, User>> signIn({
    required String email,
    required String password,
  }) async {
    _logger.d('Logging in with headers: ${_dio.options}');
    try {
      final response = await _dio.post(
        _signInUrl,
        data: json.encode({'login': email, 'password': password}),
      );

      _dio.options.headers['Authorization'] = response.headers['Authorization'];
      _dio.options.headers['X-Supercash-Uid'] = response.data['id'];

      LocalRepository.setSuperCashUid(
        int.parse(response.data['id'].toString()),
      );

      LocalRepository.setToken(response.headers['Authorization']!.first);

      final userSerializer =
          UserSerializer.fromJson(response.data as Map<String, dynamic>);

      _logger.d('Updated headers: ${_dio.options.headers}');
      LocalRepository.setUserSerializer(userSerializer);
      return right(userSerializer.toDomain());
    } on DioError catch (e) {
      if (e.error is SocketException) {
        if ("${e.error}".contains("Connection refused")) {
          _logger.e(
            "Supercash server is unreachable: ${e.error} in the function: signIn() on user_repository",
          );
          return left(UserFailure.serverIsDown());
        } else {
          _logger.e(
            "No internet connection: ${e.error} in the function: signIn() on user_repository",
          );
          return left(UserFailure.notInternet());
        }
      } else {
        if (e.response!.statusCode == 500) {
          _logger.e(
            'Critical server error: ${e.message} in the function: signIn() on user_repository',
          );
          return left(UserFailure.serverIsDown());
        } else {
          _logger.e(
            'Time limit exceeded: ${e.message} in the function: signIn() on user_repository',
          );
          return left(UserFailure.timeLimitExceeded());
        }
      }
    } on Exception catch (e) {
      _logger.e(
        'Unexpected error: $e in the function signIn() on user_repository',
      );
      return left(UserFailure.unexpected());
    }
  }

  //Allows you to log out the user by deleting him from the LocalStorage.
  @override
  Either<UserFailure, Unit> signOut() {
    try {
      _logger.d('closing session');
      LocalRepository.deleteUser();
      _logger.d('successfully closed session');
      return right(unit);
    } on Exception catch (e) {
      _logger.e(
        'Unexpected error: $e in the function signOut() on user_repository',
      );
      return left(UserFailure.unexpected());
    }
  }

  //Allows you to register a new user in the application.
  @override
  Future<Either<UserFailure, User>> signUp({required String email}) async {
    final data = {
      'emails': [
        {'email': email}
      ]
    };
    _logger.d('Creating an account: $data');
    try {
      final response = await _dio.post(
        _signUpUrl,
        data: json.encode(data),
      );
      _logger.d('Account created: $data');
      return right(
        UserSerializer.fromJson(response.data as Map<String, dynamic>)
            .toDomain(),
      );
    } on DioError catch (e) {
      if (e.error is SocketException) {
        if ("${e.error}".contains("Connection refused")) {
          _logger.e(
            "Supercash server is unreachable: ${e.error} in the function: signUp() on user_repository",
          );
          return left(UserFailure.serverIsDown());
        } else {
          _logger.e(
            "No internet connection: ${e.error} in the function: signUp() on user_repository",
          );
          return left(UserFailure.notInternet());
        }
      } else {
        if (e.response!.statusCode == 500) {
          _logger.e(
            'Critical server error: ${e.message} in the function: signUp() on user_repository',
          );
          return left(UserFailure.serverIsDown());
        } else {
          _logger.e(
            'Time limit exceeded: ${e.message} in the function: signUp() on user_repository',
          );
          return left(UserFailure.timeLimitExceeded());
        }
      }
    } on Exception catch (e) {
      _logger.e(
        'Unexpected error: $e in the function signUp() on user_repository',
      );
      return left(UserFailure.emailAlreadyExists());
    }
  }

  //Check if the user is already logged into the application.
  @override
  Either<UserFailure, User> checkSession() {
    try {
      _logger.d('Checking if the user is logged in');
      final userSerializer = LocalRepository.getUserSerializer();
      if (userSerializer != null) {
        _logger.d('logged in user: ${userSerializer.toDomain()}');

        return right(userSerializer.toDomain());
      }
      _logger.e('The user could not log in to the app');
      return left(UserFailure.notLogIn());
    } on Exception catch (e) {
      _logger.e(
        'Unexpected error: $e in the function checkSession() on user_repository',
      );
      return left(UserFailure.unexpected());
    }
  }

  @override
  Future<Either<UserFailure, Unit>> sendSignUpConfirmationToken({
    required String token,
  }) async {
    _logger.d('sending SignUp token confirmation');
    try {
      final marketplaceId =
          await _dio.options.headers["X-Supercash-Marketplace-Id"];
      await _dio.patch(
        '$_sendSignUpTokenConfirmation/$marketplaceId/$token',
      );
      _logger.d('user_repository.sendSignUpConfirmationToken TOKEN => $token');
      return right(unit);
    } on DioError catch (e) {
      if (e.error is SocketException) {
        if ("${e.error}".contains("Connection refused")) {
          _logger.e(
            "Supercash server is unreachable: ${e.error} in the function: sendSignUpConfirmationToken() on user_repository",
          );
          return left(UserFailure.serverIsDown());
        } else {
          _logger.e(
            "No internet connection: ${e.error} in the function: sendSignUpConfirmationToken() on user_repository",
          );
          return left(UserFailure.notInternet());
        }
      } else {
        if (e.response!.statusCode == 500) {
          _logger.e(
            'Critical server error: ${e.message} in the function: sendSignUpConfirmationToken() on user_repository',
          );
          return left(UserFailure.serverIsDown());
        } else {
          _logger.e(
            'Time limit exceeded: ${e.message} in the function: sendSignUpConfirmationToken() on user_repository',
          );
          return left(UserFailure.timeLimitExceeded());
        }
      }
    } catch (e) {
      _logger.e(
        'Unexpected error: $e in the function sendSignUpConfirmationToken() on user_repository',
      );
      return left(UserFailure.unexpected());
    }
  }

  //Allows to resend the confirmation email
  @override
  Future<Either<UserFailure, Unit>> resendEmailConfirmation({
    required String email,
  }) async {
    _logger.d('resend confirmation email');
    try {
      await _dio.get(
        "$_resentConfirmationEmail /$email",
      );
      _logger.d('confirmation email sent: $email');
      return right(unit);
    } on DioError catch (e) {
      if (e.error is SocketException) {
        if ("${e.error}".contains("Connection refused")) {
          _logger.e(
            "Supercash server is unreachable: ${e.error} in the function: resendEmailConfirmation() on user_repository",
          );
          return left(UserFailure.serverIsDown());
        } else {
          _logger.e(
            "No internet connection: ${e.error} in the function: resendEmailConfirmation() on user_repository",
          );
          return left(UserFailure.notInternet());
        }
      } else {
        if (e.response!.statusCode == 500) {
          _logger.e(
            'Critical server error: ${e.message} in the function: resendEmailConfirmation() on user_repository',
          );
          return left(UserFailure.serverIsDown());
        } else {
          _logger.e(
            'Time limit exceeded: ${e.message} in the function: resendEmailConfirmation() on user_repository',
          );
          return left(UserFailure.timeLimitExceeded());
        }
      }
    } on Exception catch (e) {
      _logger.e(
        'Unexpected error: $e in the function resendEmailConfirmation() on user_repository',
      );
      return left(UserFailure.unexpected());
    }
  }

  //Create a password for the user
  @override
  Future<Either<UserFailure, Unit>> createUserPassword({
    required String token,
    required String password,
  }) async {
    _logger.d('Creating user password');
    try {
      await _dio.post(
        _createUserPassword,
        data: {
          'token': token,
          'password': password,
        },
      );
      _logger.d('User password created');
      return right(unit);
    } on DioError catch (e) {
      if (e.error is SocketException) {
        if ("${e.error}".contains("Connection refused")) {
          _logger.e(
            "Supercash server is unreachable: ${e.error} in the function: patchUserPassword() on user_repository",
          );
          return left(UserFailure.serverIsDown());
        } else {
          _logger.e(
            "No internet connection: ${e.error} in the function: patchUserPassword() on user_repository",
          );
          return left(UserFailure.notInternet());
        }
      } else {
        if (e.response!.statusCode == 500) {
          _logger.e(
            'Critical server error: ${e.message} in the function: patchUserPassword() on user_repository',
          );
          return left(UserFailure.serverIsDown());
        } else {
          _logger.e(
            'Time limit exceeded: ${e.message} in the function: patchUserPassword() on user_repository',
          );
          return left(UserFailure.timeLimitExceeded());
        }
      }
    } on Exception catch (e) {
      _logger.e(
        'Unexpected error: $e in the function patchUserPassword() on user_repository',
      );
      return left(UserFailure.unexpected());
    }
  }

  //Delete a user's address by searching for its id.
  @override
  Future<Either<UserFailure, User>> deleteUserAddress({
    required int addressId,
  }) async {
    _logger.d('Deleting user address: $addressId');
    try {
      await _dio.delete("$_userAddress/$addressId");
      final user = await getUser();
      if (user.isRight()) {
        _logger.d('User address deleted');
      } else {
        _logger.e('User address not deleted');
      }
      return user;
    } on DioError catch (e) {
      if (e.error is SocketException) {
        if ("${e.error}".contains("Connection refused")) {
          _logger.e(
            "Supercash server is unreachable: ${e.error} in the function: deleteUserAddress() on user_repository",
          );
          return left(UserFailure.serverIsDown());
        } else {
          _logger.e(
            "No internet connection: ${e.error} in the function: deleteUserAddress() on user_repository",
          );
          return left(UserFailure.notInternet());
        }
      } else {
        if (e.response!.statusCode == 500) {
          _logger.e(
            'Critical server error: ${e.message} in the function: deleteUserAddress() on user_repository',
          );
          return left(UserFailure.serverIsDown());
        } else {
          _logger.e(
            'Time limit exceeded: ${e.message} in the function: deleteUserAddress() on user_repository',
          );
          return left(UserFailure.timeLimitExceeded());
        }
      }
    } on Exception catch (e) {
      _logger.e(
        'Unexpected error: $e in the function deleteUserAddress() on user_repository',
      );
      return left(UserFailure.unexpected());
    }
  }

  //Gets the list of registered genres.
  @override
  Future<Either<UserFailure, List<Gender>>> getAllGenders() async {
    _logger.d('Getting all genders');
    try {
      List<Map<String, dynamic>>? genders = LocalRepository.getGenres();
      if (genders == null) {
        final response = await _dio.get(
          _getGenderList,
        );
        genders = (response.data as List)
            .map((e) => e as Map<String, dynamic>)
            .toList();
        LocalRepository.setGenres(genders);
      }
      final List<Gender> gendersList = genders
          .map(
            (e) => GenderSerializer.fromJson(e).toDomain(),
          )
          .toList();
      _logger.d('All genders obtained: $gendersList');
      return right(gendersList);
    } on DioError catch (e) {
      if (e.error is SocketException) {
        if ("${e.error}".contains("Connection refused")) {
          _logger.e(
            "Supercash server is unreachable: ${e.error} in the function: getAllGenders() on user_repository",
          );
          return left(UserFailure.serverIsDown());
        } else {
          _logger.e(
            "No internet connection: ${e.error} in the function: getAllGenders() on user_repository",
          );
          return left(UserFailure.notInternet());
        }
      } else {
        if (e.response!.statusCode == 500) {
          _logger.e(
            'Critical server error: ${e.message} in the function: getAllGenders() on user_repository',
          );
          return left(UserFailure.serverIsDown());
        } else {
          _logger.e(
            'Time limit exceeded: ${e.message} in the function: getAllGenders() on user_repository',
          );
          return left(UserFailure.timeLimitExceeded());
        }
      }
    } on Exception catch (e) {
      _logger.e(
        'Unexpected error: $e in the function getAllGenders() on user_repository',
      );
      return left(UserFailure.unexpected());
    }
  }

  //Gets the data of the logged in user.
  @override
  Future<Either<UserFailure, User>> getUser() async {
    _logger.d('Getting user data');
    try {
      final response = await _dio.get(_user);
      final user =
          UserSerializer.fromJson(response.data as Map<String, dynamic>)
              .toDomain();
      _logger.d('User data obtained: $user');
      return right(user);
    } on DioError catch (e) {
      if (e.error is SocketException) {
        if ("${e.error}".contains("Connection refused")) {
          _logger.e(
            "Supercash server is unreachable: ${e.error} in the function: getUser() on user_repository",
          );
          return left(UserFailure.serverIsDown());
        } else {
          _logger.e(
            "No internet connection: ${e.error} in the function: getUser() on user_repository",
          );
          return left(UserFailure.notInternet());
        }
      } else {
        if (e.response!.statusCode == 500) {
          _logger.e(
            'Critical server error: ${e.message} in the function: getUser() on user_repository',
          );
          return left(UserFailure.serverIsDown());
        } else {
          _logger.e(
            'Time limit exceeded: ${e.message} in the function: getUser() on user_repository',
          );
          return left(UserFailure.timeLimitExceeded());
        }
      }
    } on Exception catch (e) {
      _logger.e(
        'Unexpected error: $e in the function getUser() on user_repository',
      );
      return left(UserFailure.unexpected());
    }
  }

  //Update a logged in user phone number by sending the json object.
  @override
  Future<Either<UserFailure, Unit>> patchPhoneNumber({
    required Map<String, dynamic> phone,
  }) async {
    _logger.d('Updating phone number: $phone');
    try {
      await _dio.patch(
        "$_patchPhoneNumber${phone["id"]}",
        data: json.encode(phone),
      );
      _logger.d('Phone number updated: $phone');
      return right(unit);
    } on DioError catch (e) {
      if (e.error is SocketException) {
        if ("${e.error}".contains("Connection refused")) {
          _logger.e(
            "Supercash server is unreachable: ${e.error} in the function: patchPhoneNumber() on user_repository",
          );
          return left(UserFailure.serverIsDown());
        } else {
          _logger.e(
            "No internet connection: ${e.error} in the function: patchPhoneNumber() on user_repository",
          );
          return left(UserFailure.notInternet());
        }
      } else {
        if (e.response!.statusCode == 500) {
          _logger.e(
            'Critical server error: ${e.message} in the function: patchPhoneNumber() on user_repository',
          );
          return left(UserFailure.serverIsDown());
        } else {
          _logger.e(
            'Time limit exceeded: ${e.message} in the function: patchPhoneNumber() on user_repository',
          );
          return left(UserFailure.timeLimitExceeded());
        }
      }
    } on Exception catch (e) {
      _logger.e(
        'Unexpected error: $e in the function patchPhoneNumber() on user_repository',
      );
      return left(UserFailure.unexpected());
    }
  }

  //Update a logged in user address by sending the json object.
  @override
  Future<Either<UserFailure, User>> patchUserAddress({
    required Map<String, dynamic> address,
  }) async {
    _logger.d('Updating user address: $address');
    try {
      await _dio.patch(
        "$_userAddress/${address['id']}",
        data: json.encode(address),
      );
      final user = await getUser();
      if (user.isRight()) {
        _logger.d('User address updated');
      } else {
        _logger.e('User address not updated');
      }
      return user;
    } on DioError catch (e) {
      if (e.error is SocketException) {
        if ("${e.error}".contains("Connection refused")) {
          _logger.e(
            "Supercash server is unreachable: ${e.error} in the function: patchUserAddress() on user_repository",
          );
          return left(UserFailure.serverIsDown());
        } else {
          _logger.e(
            "No internet connection: ${e.error} in the function: patchUserAddress() on user_repository",
          );
          return left(UserFailure.notInternet());
        }
      } else {
        if (e.response!.statusCode == 500) {
          _logger.e(
            'Critical server error: ${e.message} in the function: patchUserAddress() on user_repository',
          );
          return left(UserFailure.serverIsDown());
        } else {
          _logger.e(
            'Time limit exceeded: ${e.message} in the function: patchUserAddress() on user_repository',
          );
          return left(UserFailure.timeLimitExceeded());
        }
      }
    } on Exception catch (e) {
      _logger.e(
        'Unexpected error: $e in the function patchUserAddress() on user_repository',
      );
      return left(UserFailure.unexpected());
    }
  }

  //Updates the logged in user data by sending the json object.
  @override
  Future<Either<UserFailure, User>> patchUserData({
    required Map<String, dynamic> user,
  }) async {
    _logger.d("Updating user data: $user");
    try {
      final response = await _dio.patch(_user, data: json.encode(user));
      final newUser =
          UserSerializer.fromJson(response.data as Map<String, dynamic>)
              .toDomain();
      _logger.d("User data updated: ${response.data}");
      return right(newUser);
    } on DioError catch (e) {
      if (e.error is SocketException) {
        if ("${e.error}".contains("Connection refused")) {
          _logger.e(
            "Supercash server is unreachable: ${e.error} in the function: patchUserData() on user_repository",
          );
          return left(UserFailure.serverIsDown());
        } else {
          _logger.e(
            "No internet connection: ${e.error} in the function: patchUserData() on user_repository",
          );
          return left(UserFailure.notInternet());
        }
      } else {
        if (e.response!.statusCode == 500) {
          _logger.e(
            'Critical server error: ${e.message} in the function: patchUserData() on user_repository',
          );
          return left(UserFailure.serverIsDown());
        } else {
          _logger.e(
            'Time limit exceeded: ${e.message} in the function: patchUserData() on user_repository',
          );
          return left(UserFailure.timeLimitExceeded());
        }
      }
    } on Exception catch (e) {
      _logger.e(
        'Unexpected error: $e in the function patchUserData() on user_repository',
      );
      return left(UserFailure.unexpected());
    }
  }

  //Update the logged in user password by sending the json object
  @override
  Future<Either<UserFailure, Unit>> patchUserPassword({
    required Map<String, dynamic> user,
  }) async {
    _logger.d("Updating password");
    try {
      await _dio.patch(_patchUserPassword, data: json.encode(user));
      _logger.d("Password updated");
      return right(unit);
    } on DioError catch (e) {
      if (e.error is SocketException) {
        if ("${e.error}".contains("Connection refused")) {
          _logger.e(
            "Supercash server is unreachable: ${e.error} in the function: patchUserPassword() on user_repository",
          );
          return left(UserFailure.serverIsDown());
        } else {
          _logger.e(
            "No internet connection: ${e.error} in the function: patchUserPassword() on user_repository",
          );
          return left(UserFailure.notInternet());
        }
      } else {
        if (e.response!.statusCode == 500) {
          _logger.e(
            'Critical server error: ${e.message} in the function: patchUserPassword() on user_repository',
          );
          return left(UserFailure.serverIsDown());
        } else {
          _logger.e(
            'Time limit exceeded: ${e.message} in the function: patchUserPassword() on user_repository',
          );
          return left(UserFailure.timeLimitExceeded());
        }
      }
    } on Exception catch (e) {
      _logger.e(
        'Unexpected error: $e in the function patchUserPassword() on user_repository',
      );
      return left(UserFailure.unexpected());
    }
  }

  //Saves an address of the logged in user by sending a json object.
  @override
  Future<Either<UserFailure, User>> saveUserAddress({
    required Map<String, dynamic> address,
  }) async {
    _logger.d('Saving user address: $address');
    try {
      await _dio.post(_userAddress, data: json.encode(address));
      final user = await getUser();
      if (user.isRight()) {
        _logger.d('User address saved: $address');
      } else {
        _logger.e('User address not saved: $address');
      }
      return user;
    } on DioError catch (e) {
      if (e.error is SocketException) {
        if ("${e.error}".contains("Connection refused")) {
          _logger.e(
            "Supercash server is unreachable: ${e.error} in the function: saveUserAddress() on user_repository",
          );
          return left(UserFailure.serverIsDown());
        } else {
          _logger.e(
            "No internet connection: ${e.error} in the function: saveUserAddress() on user_repository",
          );
          return left(UserFailure.notInternet());
        }
      } else {
        if (e.response!.statusCode == 500) {
          _logger.e(
            'Critical server error: ${e.message} in the function: saveUserAddress() on user_repository',
          );
          return left(UserFailure.serverIsDown());
        } else {
          _logger.e(
            'Time limit exceeded: ${e.message} in the function: saveUserAddress() on user_repository',
          );
          return left(UserFailure.timeLimitExceeded());
        }
      }
    } on Exception catch (e) {
      _logger.e(
        'Unexpected error: $e in the function saveUserAddress() on user_repository',
      );
      return left(UserFailure.unexpected());
    }
  }

  //Send password recovery code by email
  @override
  Future<Either<UserFailure, Unit>> sendForgotPassword({
    required String email,
  }) async {
    _logger.d('Recovering password:  $email');
    try {
      await _dio.post(_forgetPassword, data: json.encode({"login": email}));
      _logger.d('Password recovered: $email');
      return right(unit);
    } on DioError catch (e) {
      if (e.error is SocketException) {
        if ("${e.error}".contains("Connection refused")) {
          _logger.e(
            "Supercash server is unreachable: ${e.error} in the function: sendForgotPassword() on user_repository",
          );
          return left(UserFailure.serverIsDown());
        } else {
          _logger.e(
            "No internet connection: ${e.error} in the function: sendForgotPassword() on user_repository",
          );
          return left(UserFailure.notInternet());
        }
      } else {
        if (e.response!.statusCode == 500) {
          _logger.e(
            'Critical server error: ${e.message} in the function: sendForgotPassword() on user_repository',
          );
          return left(UserFailure.serverIsDown());
        } else {
          _logger.e(
            'Time limit exceeded: ${e.message} in the function: sendForgotPassword() on user_repository',
          );
          return left(UserFailure.timeLimitExceeded());
        }
      }
    } on Exception catch (e) {
      _logger.e(
        'Unexpected error: $e in the function sendForgotPassword() on user_repository',
      );
      return left(UserFailure.unexpected());
    }
  }

  //Save the new password after recovering it
  @override
  Future<Either<UserFailure, String>> sendNewPassword({
    required String token,
    required String password,
  }) async {
    _logger.d('Redefining password');
    try {
      final response = await _dio.post(
        _redefinePassword,
        data: json.encode({'token': token, 'password': password}),
      );
      final message = response.data['message'] ?? 'Password redefined';
      _logger.d(message);
      return right(message.toString());
    } on DioError catch (e) {
      if (e.error is SocketException) {
        if ("${e.error}".contains("Connection refused")) {
          _logger.e(
            "Supercash server is unreachable: ${e.error} in the function: sendNewPassword() on user_repository",
          );
          return left(UserFailure.serverIsDown());
        } else {
          _logger.e(
            "No internet connection: ${e.error} in the function: sendNewPassword() on user_repository",
          );
          return left(UserFailure.notInternet());
        }
      } else {
        if (e.response!.statusCode == 500) {
          _logger.e(
            'Critical server error: ${e.message} in the function: sendNewPassword() on user_repository',
          );
          return left(UserFailure.serverIsDown());
        } else {
          _logger.e(
            'Time limit exceeded: ${e.message} in the function: sendNewPassword() on user_repository',
          );
          return left(UserFailure.timeLimitExceeded());
        }
      }
    } on Exception catch (e) {
      _logger.e(
        'Unexpected error: $e in the function sendNewPassword() on user_repository',
      );
      return left(UserFailure.unexpected());
    }
  }

  //Update the user profile image
  @override
  Future<Either<UserFailure, User>> uploadUserProfileThumbnail({
    required File picture,
  }) async {
    _logger.d('Saving profile picture');
    try {
      final FormData formData = FormData.fromMap({
        'thumbnail':
            await MultipartFile.fromFile(picture.path, filename: "upload1.jpg")
      });
      await _dio.post(
        _postPhotoUser,
        data: formData,
      );
      final user = await getUser();
      if (user.isRight()) {
        _logger.d('Profile picture saved');
      } else {
        _logger.e('Profile picture not saved');
      }
      return user;
    } on DioError catch (e) {
      if (e.error is SocketException) {
        if ("${e.error}".contains("Connection refused")) {
          _logger.e(
            "Supercash server is unreachable: ${e.error} in the function: uploadUserProfileThumbnail() on user_repository",
          );
          return left(UserFailure.serverIsDown());
        } else {
          _logger.e(
            "No internet connection: ${e.error} in the function: uploadUserProfileThumbnail() on user_repository",
          );
          return left(UserFailure.notInternet());
        }
      } else {
        if (e.response!.statusCode == 500) {
          _logger.e(
            'Critical server error: ${e.message} in the function: uploadUserProfileThumbnail() on user_repository',
          );
          return left(UserFailure.serverIsDown());
        } else {
          _logger.e(
            'Time limit exceeded: ${e.message} in the function: uploadUserProfileThumbnail() on user_repository',
          );
          return left(UserFailure.timeLimitExceeded());
        }
      }
    } on Exception catch (e) {
      _logger.e(
        'Unexpected error: $e in the function uploadUserProfileThumbnail() on user_repository',
      );
      return left(UserFailure.unexpected());
    }
  }

  //Load an address using a CEP code
  @override
  Future<Either<UserFailure, Address>> loadAddressFromCEP({
    required String cep,
  }) async {
    _logger.d('Looking for address for Cep: $cep');
    try {
      final response = await _dio.get("$_cepServices/$cep");
      final address =
          AddressSerializer.fromJson(response.data as Map<String, dynamic>)
              .toDomain();
      _logger.d('Address found: ${response.data}');
      return right(address);
    } on DioError catch (e) {
      if (e.error is SocketException) {
        if ("${e.error}".contains("Connection refused")) {
          _logger.e(
            "Supercash server is unreachable: ${e.error} in the function: loadAddressFromCEP() on user_repository",
          );
          return left(UserFailure.serverIsDown());
        } else {
          _logger.e(
            "No internet connection: ${e.error} in the function: loadAddressFromCEP() on user_repository",
          );
          return left(UserFailure.notInternet());
        }
      } else {
        if (e.response!.statusCode == 500) {
          _logger.e(
            'Critical server error: ${e.message} in the function: loadAddressFromCEP() on user_repository',
          );
          return left(UserFailure.serverIsDown());
        } else {
          _logger.e(
            'Time limit exceeded: ${e.message} in the function: loadAddressFromCEP() on user_repository',
          );
          return left(UserFailure.timeLimitExceeded());
        }
      }
    } on Exception catch (e) {
      _logger.e(
        'Unexpected error: $e in the function loadAddressFromCEP() on user_repository',
      );
      return left(UserFailure.unexpected());
    }
  }

  //Update a user email
  @override
  Future<Either<UserFailure, Unit>> patchEmail({
    required Map<String, dynamic> email,
  }) async {
    _logger.d('Updating email: $email');
    try {
      await _dio.patch(
        "$_userEmail/${email['id']}",
        data: json.encode(email),
      );
      _logger.d('Email updated');
      return right(unit);
    } on DioError catch (e) {
      if (e.error is SocketException) {
        if ("${e.error}".contains("Connection refused")) {
          _logger.e(
            "Supercash server is unreachable: ${e.error} in the function: patchEmail() on user_repository",
          );
          return left(UserFailure.serverIsDown());
        } else {
          _logger.e(
            "No internet connection: ${e.error} in the function: patchEmail() on user_repository",
          );
          return left(UserFailure.notInternet());
        }
      } else {
        if (e.response!.statusCode == 500) {
          _logger.e(
            'Critical server error: ${e.message} in the function: patchEmail() on user_repository',
          );
          return left(UserFailure.serverIsDown());
        } else {
          _logger.e(
            'Time limit exceeded: ${e.message} in the function: patchEmail() on user_repository',
          );
          return left(UserFailure.timeLimitExceeded());
        }
      }
    } on Exception catch (e) {
      _logger.e(
        'Unexpected error: $e in the function patchEmail() on user_repository',
      );
      return left(UserFailure.unexpected());
    }
  }
}
