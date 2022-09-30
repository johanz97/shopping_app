import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import '../../../domain/user/i_user_repository.dart';
import '../../../domain/user/user.dart';
import '../../../domain/user/user_failure.dart';

import '../../../injection.dart';

part 'sign_up_bloc.freezed.dart';
part 'sign_up_event.dart';
part 'sign_up_state.dart';

@injectable
class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final IUserRepository _userRepository;
  SignUpBloc(this._userRepository) : super(SignUpState.initial());

  @override
  Stream<SignUpState> mapEventToState(SignUpEvent gEvent) async* {
    yield* gEvent.map(
      nextStep: (e) async* {
        if (state.actualStep < 2) {
          yield state.copyWith(
            actualStep: state.actualStep + 1,
            failureOrSuccessOtpValidation: none(),
            failureOrSuccessCreateUser: none(),
            failureOrSuccessPasswordCreate: none(),
          );
        } else {
          add(const UpdateUserPassword());
        }
      },
      createUser: (e) async* {
        yield state.copyWith(
          isLoading: true,
          failureOrSuccessResendOtpCode: none(),
          failureOrSuccessOtpValidation: none(),
          failureOrSuccessCreateUser: none(),
          failureOrSuccessPasswordCreate: none(),
        );
        Either<UserFailure, User> failureOrSuccess;
        final userTest = User.test();
        if (userTest.preferredEmail.email == state.email) {
          //test logic without http request
          final _logger = getIt<Logger>();
          _logger.d(
            "Create test user: ${userTest.preferredEmail.email}",
          );
          await Future.delayed(
            const Duration(milliseconds: 100),
          );
          failureOrSuccess = right(User.test());
        } else {
          // Create user with http request
          failureOrSuccess = await _userRepository.signUp(email: state.email);
        }
        yield state.copyWith(
          isLoading: false,
          failureOrSuccessOtpValidation: none(),
          failureOrSuccessCreateUser: optionOf(
            failureOrSuccess,
          ),
          failureOrSuccessPasswordCreate: none(),
          failureOrSuccessResendOtpCode: none(),
        );
      },
      reSendOtpCode: (e) async* {
        yield state.copyWith(
          isLoading: true,
          failureOrSuccessOtpValidation: none(),
          failureOrSuccessCreateUser: none(),
          failureOrSuccessPasswordCreate: none(),
          failureOrSuccessResendOtpCode: none(),
        );
        Either<UserFailure, Unit> failureOrSuccess;
        final userTest = User.test();
        if (state.email == userTest.preferredEmail.email) {
          // Test logic withOut http Request
          final _logger = getIt<Logger>();
          _logger.d(
            "Resend otp code to email: ${userTest.preferredEmail.email}",
          );
          await Future.delayed(
            const Duration(milliseconds: 100),
          );
          failureOrSuccess = right(unit);
        } else {
          // Resend Otp code with http request
          failureOrSuccess = await _userRepository.resendEmailConfirmation(
            email: state.email,
          );
        }
        yield state.copyWith(
          isLoading: false,
          failureOrSuccessOtpValidation: none(),
          failureOrSuccessCreateUser: none(),
          failureOrSuccessPasswordCreate: none(),
          failureOrSuccessResendOtpCode: optionOf(
            failureOrSuccess,
          ),
        );
      },
      confirmAcount: (e) async* {
        yield state.copyWith(
          isLoading: true,
          failureOrSuccessOtpValidation: none(),
          failureOrSuccessCreateUser: none(),
          failureOrSuccessPasswordCreate: none(),
          failureOrSuccessResendOtpCode: none(),
        );
        Either<UserFailure, Unit> failureOrSuccess;
        final userTest = User.test();
        if (state.email == userTest.preferredEmail.email) {
          // Test logic withOut http Request
          final _logger = getIt<Logger>();
          _logger.d("Confirm test acount");
          await Future.delayed(
            const Duration(milliseconds: 100),
          );

          if (state.otpCode.toString() ==
              userTest.preferredEmail.confirmationToken) {
            failureOrSuccess = right(unit);
          } else {
            failureOrSuccess = left(
              UserFailure.otpCodeIncorrect(),
            );
          }
        } else {
          // Confirm with http request
          failureOrSuccess = await _userRepository.sendSignUpConfirmationToken(
            token: state.otpCode.toString(),
          );
        }
        yield state.copyWith(
          isLoading: false,
          failureOrSuccessOtpValidation: optionOf(
            failureOrSuccess,
          ),
          failureOrSuccessCreateUser: none(),
          failureOrSuccessPasswordCreate: none(),
          failureOrSuccessResendOtpCode: none(),
        );
      },
      emailChanged: (e) async* {
        yield state.copyWith(
          email: e.email,
          failureOrSuccessOtpValidation: none(),
          failureOrSuccessCreateUser: none(),
          failureOrSuccessPasswordCreate: none(),
          failureOrSuccessResendOtpCode: none(),
        );
      },
      otpCodeChanged: (e) async* {
        yield state.copyWith(
          otpCode: int.parse(e.otp),
          failureOrSuccessOtpValidation: none(),
          failureOrSuccessCreateUser: none(),
          failureOrSuccessPasswordCreate: none(),
          failureOrSuccessResendOtpCode: none(),
        );
      },
      passwordChanged: (e) async* {
        yield state.copyWith(
          password: e.password,
          failureOrSuccessOtpValidation: none(),
          failureOrSuccessCreateUser: none(),
          failureOrSuccessPasswordCreate: none(),
          failureOrSuccessResendOtpCode: none(),
        );
      },
      passwordVerifyChanged: (e) async* {
        yield state.copyWith(
          passwordVerified: e.passwordVerify,
          failureOrSuccessOtpValidation: none(),
          failureOrSuccessCreateUser: none(),
          failureOrSuccessPasswordCreate: none(),
          failureOrSuccessResendOtpCode: none(),
        );
      },
      updateUserPassword: (e) async* {
        yield state.copyWith(
          isLoading: true,
          failureOrSuccessOtpValidation: none(),
          failureOrSuccessCreateUser: none(),
          failureOrSuccessPasswordCreate: none(),
          failureOrSuccessResendOtpCode: none(),
        );
        Either<UserFailure, Unit> failureOrSuccess;
        final userTest = User.test();
        if (state.email == userTest.preferredEmail.email) {
          // Test logic withOut http Request
          final _logger = getIt<Logger>();
          _logger.d("Update password test acount");
          await Future.delayed(
            const Duration(milliseconds: 100),
          );
          if (state.password == userTest.password) {
            failureOrSuccess = right(unit);
          } else {
            failureOrSuccess = left(UserFailure.unexpected());
          }
        } else {
          // Update password with http request
          failureOrSuccess = await _userRepository.createUserPassword(
            token: state.otpCode.toString(),
            password: state.password,
          );
        }
        yield state.copyWith(
          isLoading: false,
          failureOrSuccessOtpValidation: none(),
          failureOrSuccessCreateUser: none(),
          failureOrSuccessPasswordCreate: optionOf(
            failureOrSuccess,
          ),
          failureOrSuccessResendOtpCode: none(),
        );
      },
      setOtpCodeFromServer: (e) async* {
        yield state.copyWith(
          optCodeFromServer: int.parse(e.otpCode),
          failureOrSuccessResendOtpCode: none(),
          failureOrSuccessOtpValidation: none(),
          failureOrSuccessCreateUser: none(),
          failureOrSuccessPasswordCreate: none(),
        );
      },
    );
  }
}
