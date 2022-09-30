import 'dart:io';

import 'package:dartz/dartz.dart';

import 'address/address.dart';
import 'gender/gender.dart';
import 'user.dart';
import 'user_failure.dart';

abstract class IUserRepository {
  Either<UserFailure, User> checkSession();
  Future<Either<UserFailure, Unit>> createUserPassword({
    required String token,
    required String password,
  });
  Future<Either<UserFailure, User>> deleteUserAddress({required int addressId});
  Future<Either<UserFailure, List<Gender>>> getAllGenders();
  Future<Either<UserFailure, User>> getUser();
  Future<Either<UserFailure, Address>> loadAddressFromCEP({
    required String cep,
  });
  Future<Either<UserFailure, Unit>> patchEmail({
    required Map<String, dynamic> email,
  });
  Future<Either<UserFailure, User>> patchUserAddress({
    required Map<String, dynamic> address,
  });
  Future<Either<UserFailure, User>> patchUserData({
    required Map<String, dynamic> user,
  });
  Future<Either<UserFailure, Unit>> patchUserPassword({
    required Map<String, dynamic> user,
  });
  Future<Either<UserFailure, Unit>> patchPhoneNumber({
    required Map<String, dynamic> phone,
  });
  Future<Either<UserFailure, Unit>> resendEmailConfirmation({
    required String email,
  });
  Future<Either<UserFailure, Unit>> refreshAuthToken();
  Future<Either<UserFailure, User>> saveUserAddress({
    required Map<String, dynamic> address,
  });
  Future<Either<UserFailure, User>> signIn({
    required String email,
    required String password,
  });
  Either<UserFailure, Unit> signOut();
  Future<Either<UserFailure, User>> signUp({required String email});
  Future<Either<UserFailure, Unit>> sendForgotPassword({required String email});
  Future<Either<UserFailure, Unit>> sendSignUpConfirmationToken({
    required String token,
  });
  Future<Either<UserFailure, User>> uploadUserProfileThumbnail({
    required File picture,
  });
  Future<Either<UserFailure, String>> sendNewPassword({
    required String token,
    required String password,
  });
}
