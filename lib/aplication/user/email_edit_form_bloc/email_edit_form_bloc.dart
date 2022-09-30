import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import '../../../domain/user/user.dart';
import '../../../domain/user/user_failure.dart';
import '../../../injection.dart';

part 'email_edit_form_state.dart';
part 'email_edit_form_event.dart';
part 'email_edit_form_bloc.freezed.dart';

@injectable
class EmailEditFormBloc extends Bloc<EmailEditFormEvent, EmailEditFormState> {
  EmailEditFormBloc() : super(EmailEditFormState.initial());

  @override
  Stream<EmailEditFormState> mapEventToState(EmailEditFormEvent gEvent) async* {
    yield* gEvent.map(
      nextStep: (e) async* {
        if (state.actualStep < 1) {
          yield state.copyWith(
            actualStep: state.actualStep + 1,
            failureOrSuccessOtpValidation: none(),
            failureOrSuccessUpdateEmail: none(),
            failureOrSuccessResendOtpCode: none(),
          );
        } else {
          add(const ConfirmEmail());
        }
      },
      updateEmail: (e) async* {
        yield state.copyWith(
          isLoading: true,
          failureOrSuccessResendOtpCode: none(),
          failureOrSuccessOtpValidation: none(),
          failureOrSuccessUpdateEmail: none(),
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
          failureOrSuccess = right(User.test());
        }
        yield state.copyWith(
          isLoading: false,
          failureOrSuccessOtpValidation: none(),
          failureOrSuccessUpdateEmail: optionOf(failureOrSuccess),
          failureOrSuccessResendOtpCode: none(),
        );
      },
      confirmEmail: (e) async* {
        yield state.copyWith(
          isLoading: true,
          failureOrSuccessOtpValidation: none(),
          failureOrSuccessUpdateEmail: none(),
          failureOrSuccessResendOtpCode: none(),
        );
        Either<UserFailure, Unit> failureOrSuccess;
        final userTest = User.test();
        if (state.email == userTest.preferredEmail.email) {
          // Test logic withOut http Request
          final _logger = getIt<Logger>();
          _logger.d("Confirm test email");
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
          failureOrSuccess = right(unit);
        }
        yield state.copyWith(
          isLoading: false,
          failureOrSuccessOtpValidation: optionOf(
            failureOrSuccess,
          ),
          failureOrSuccessUpdateEmail: none(),
          failureOrSuccessResendOtpCode: none(),
        );
      },
      reSendOtpCode: (e) async* {
        yield state.copyWith(
          isLoading: true,
          failureOrSuccessOtpValidation: none(),
          failureOrSuccessUpdateEmail: none(),
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
          failureOrSuccess = right(unit);
        }
        yield state.copyWith(
          isLoading: false,
          failureOrSuccessOtpValidation: none(),
          failureOrSuccessUpdateEmail: none(),
          failureOrSuccessResendOtpCode: optionOf(
            failureOrSuccess,
          ),
        );
      },
      emailChanged: (e) async* {
        yield state.copyWith(
          failureOrSuccessOtpValidation: none(),
          failureOrSuccessUpdateEmail: none(),
          failureOrSuccessResendOtpCode: none(),
          email: e.email,
        );
      },
      otpCodeChanged: (e) async* {
        yield state.copyWith(
          failureOrSuccessOtpValidation: none(),
          failureOrSuccessUpdateEmail: none(),
          failureOrSuccessResendOtpCode: none(),
          otpCode: int.parse(e.otp),
        );
      },
      setOtpCodeFromServer: (e) async* {
        yield state.copyWith(
          failureOrSuccessOtpValidation: none(),
          failureOrSuccessUpdateEmail: none(),
          failureOrSuccessResendOtpCode: none(),
          optCodeFromServer: int.parse(e.otpCode),
        );
      },
      initialize: (e) async* {
        yield state.copyWith(
          failureOrSuccessOtpValidation: none(),
          failureOrSuccessUpdateEmail: none(),
          failureOrSuccessResendOtpCode: none(),
          emailController: TextEditingController(text: e.email),
        );
      },
    );
  }
}
