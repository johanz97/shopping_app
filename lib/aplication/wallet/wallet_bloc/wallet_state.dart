part of 'wallet_bloc.dart';

@freezed
class WalletState with _$WalletState {
  const factory WalletState.initial() = Initial;
  const factory WalletState.loadInProgress() = LoadInProgress;
  const factory WalletState.success({
    required List<CreditCardInfo> creditCards,
    required List<Transaction> transaction,
  }) = Success;
  const factory WalletState.newUser() = NewUser;
  const factory WalletState.loadFailure() = LoadFailure;
}
