import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import '../../../core/validator.dart';
import '../../../domain/user/i_user_repository.dart';
import '../../../domain/user/user.dart';
import '../../../domain/user/user_failure.dart';
import '../../../infrastructure/core/local_repository.dart';

part 'sign_in_bloc.freezed.dart';
part 'sign_in_event.dart';
part 'sign_in_state.dart';

@injectable
class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final IUserRepository _userRepository;

  SignInBloc(this._userRepository) : super(SignInState.initial());
  @override
  Stream<SignInState> mapEventToState(SignInEvent gEvent) async* {
    yield* gEvent.map(
      emailChanged: (e) async* {
        yield state.copyWith(
          email: e.email,
          failureOrSuccess: none(),
        );
      },
      passwordChanged: (e) async* {
        yield state.copyWith(
          password: e.password,
          failureOrSuccess: none(),
        );
      },
      signIn: (e) async* {
        yield state.copyWith(
          isLoading: true,
          failureOrSuccess: none(),
        );
        final emailIsValid = Validator.validateEmail(state.email).isRight();
        final passwordIsValid =
            Validator.validatePassWord(state.password).isRight();
        final userTest = User.test();
        // Test logic without http request
        if (userTest.preferredEmail.email == state.email) {
          if (userTest.password == state.password) {
            yield state.copyWith(
              failureOrSuccess: optionOf(right(User.test())),
            );
          } else {
            yield state.copyWith(
              failureOrSuccess: optionOf(
                left(
                  UserFailure.incorrectEmailOrPassword(),
                ),
              ),
            );
          }
        } else {
          // Logic with http request
          if (emailIsValid && passwordIsValid) {
            final failureOrSuccess = await _userRepository.signIn(
              email: state.email,
              password: state.password,
            );

            if (failureOrSuccess.isRight()) {
              LocalRepository.setIsLogged(isLogged: true);
            }

            yield state.copyWith(
              isLoading: false,
              failureOrSuccess: optionOf(
                failureOrSuccess,
              ),
            );
          } else {
            yield state.copyWith(
              validateErrors: true,
            );
          }
        }
      },
    );
  }
}
