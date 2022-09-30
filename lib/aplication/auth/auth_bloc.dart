import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import '../../domain/user/i_user_repository.dart';
import '../../domain/user/user_failure.dart';
import '../../infrastructure/core/local_repository.dart';

part 'auth_bloc.freezed.dart';
part 'auth_event.dart';
part 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final IUserRepository _userRepository;
  AuthBloc(this._userRepository) : super(const AuthState.initial());

  @override
  Stream<AuthState> mapEventToState(AuthEvent gEvent) async* {
    yield* gEvent.map(
      checkSession: (e) async* {
        yield const AuthState.loading();
        await Future.delayed(const Duration(milliseconds: 200));
        final failureOrUser = _userRepository.checkSession();
        final failureOrSesion = await _userRepository.refreshAuthToken();

        if (failureOrUser.isRight() && failureOrSesion.isRight()) {
          final user = LocalRepository.getUserSerializer();
          final isNew =
              LocalRepository.getIsNewUser(user!.emailsSerializer.first.email);
          yield AuthState.authenticated(isNewUser: isNew);
        } else {
          yield const AuthState.unauthenticated();
        }
      },
      signedOut: (e) async* {
        LocalRepository.setIsLogged(isLogged: false);
        LocalRepository.deleteUser();
      },
    );
  }
}
