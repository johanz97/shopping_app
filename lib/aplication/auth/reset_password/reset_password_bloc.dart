import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import '../../../core/config_reader.dart';
import '../../../domain/user/user_failure.dart';

part 'reset_password_state.dart';
part 'reset_password_event.dart';
part 'reset_password_bloc.freezed.dart';

@injectable
class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  ResetPasswordBloc() : super(ResetPasswordState.initial());

  @override
  Stream<ResetPasswordState> mapEventToState(ResetPasswordEvent gEvent) async* {
    yield* gEvent.map(
      resetPassword: (e) async* {
        yield state.copyWith(
          isLoading: true,
          failureOrSuccessNewPassword: none(),
          failureOrSuccessOtpValidation: none(),
          failureOrSuccessResetPassword: none(),
        );
        final user = ConfigReader.getTestUser();
        await Future.delayed(const Duration(seconds: 3));
        yield state.copyWith(
          isLoading: false,
          failureOrSuccessNewPassword: none(),
          failureOrSuccessOtpValidation: none(),
          failureOrSuccessResetPassword: optionOf(
            user["email"] == state.email
                ? right(unit)
                : left(UserFailure.emailAlreadyExists()),
          ),
        );
      },
      nextStep: (e) async* {
        if (state.actualStep < 2) {
          yield state.copyWith(
            actualStep: state.actualStep + 1,
            failureOrSuccessNewPassword: none(),
            failureOrSuccessOtpValidation: none(),
            failureOrSuccessResetPassword: none(),
          );
        } else {
          add(
            const ResetPasswordEvent.passwordUpdate(),
          );
        }
      },
      reSendOtpCode: (e) async* {},
      sendOtpCode: (e) async* {
        yield state.copyWith(
          isLoading: true,
          failureOrSuccessNewPassword: none(),
          failureOrSuccessOtpValidation: none(),
          failureOrSuccessResetPassword: none(),
        );
        final user = ConfigReader.getTestUser();
        await Future.delayed(const Duration(seconds: 3));
        yield state.copyWith(
          isLoading: false,
          failureOrSuccessOtpValidation: optionOf(
            user["otp"] == state.otpCode.toString()
                ? right(unit)
                : left(
                    UserFailure.otpCodeIncorrect(),
                  ),
          ),
          failureOrSuccessNewPassword: none(),
          failureOrSuccessResetPassword: none(),
        );
      },
      emailChanged: (e) async* {
        yield state.copyWith(
          email: e.email,
          failureOrSuccessNewPassword: none(),
          failureOrSuccessOtpValidation: none(),
          failureOrSuccessResetPassword: none(),
        );
      },
      otpCodeChanged: (e) async* {
        yield state.copyWith(
          otpCode: int.tryParse(e.otp) ?? 0000,
          failureOrSuccessNewPassword: none(),
          failureOrSuccessOtpValidation: none(),
          failureOrSuccessResetPassword: none(),
        );
      },
      passwordChanged: (e) async* {
        yield state.copyWith(
          password: e.password,
          failureOrSuccessNewPassword: none(),
          failureOrSuccessOtpValidation: none(),
          failureOrSuccessResetPassword: none(),
        );
      },
      passwordVerifyChanged: (e) async* {
        yield state.copyWith(
          passwordVerified: e.passwordVerify,
          failureOrSuccessNewPassword: none(),
          failureOrSuccessOtpValidation: none(),
          failureOrSuccessResetPassword: none(),
        );
      },
      passwordUpdate: (e) async* {
        yield state.copyWith(
          isLoading: true,
          failureOrSuccessNewPassword: none(),
          failureOrSuccessOtpValidation: none(),
          failureOrSuccessResetPassword: none(),
        );
        await Future.delayed(const Duration(seconds: 3));
        yield state.copyWith(
          isLoading: false,
          failureOrSuccessNewPassword: optionOf(
            right(unit),
          ),
          failureOrSuccessOtpValidation: none(),
          failureOrSuccessResetPassword: none(),
        );
      },
    );
  }
}
