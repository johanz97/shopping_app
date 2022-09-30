part of 'user_profile_bloc.dart';

@freezed
class UserProfileEvent with _$UserProfileEvent {
  const factory UserProfileEvent.initialize() = Initialize;
  const factory UserProfileEvent.userRecived(
    Either<UserFailure, User> failureOrUser,
  ) = _UserRecived;

  const factory UserProfileEvent.deleteAddress(int id) = DeleteAddress;
}
