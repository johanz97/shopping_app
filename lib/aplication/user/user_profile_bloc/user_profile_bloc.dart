import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/user/i_user_repository.dart';
import '../../../domain/user/user.dart';
import '../../../domain/user/user_failure.dart';

part 'user_profile_bloc.freezed.dart';
part 'user_profile_event.dart';
part 'user_profile_state.dart';

@injectable
class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final IUserRepository _userRepository;
  UserProfileBloc(this._userRepository) : super(UserProfileState.initial());
  @override
  Stream<UserProfileState> mapEventToState(UserProfileEvent gEvent) async* {
    yield* gEvent.map(
      initialize: (e) async* {
        yield state.copyWith(
          isLoading: true,
        );

        add(_UserRecived(await _userRepository.getUser()));
      },
      userRecived: (e) async* {
        yield e.failureOrUser.fold(
          (failure) => state.copyWith(
            isLoading: false,
            hasErrors: true,
          ),
          (user) => state.copyWith(
            user: user,
            isLoading: false,
          ),
        );
      },
      deleteAddress: (e) async* {
        final falureOrUser =
            await _userRepository.deleteUserAddress(addressId: e.id);

        add(_UserRecived(falureOrUser));

        yield state.copyWith(
          isLoading: true,
          failureOrSuccess: optionOf(falureOrUser),
        );
      },
    );
  }
}
