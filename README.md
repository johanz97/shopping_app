# Maceio Shopping app

Mobile app using latest Flutter 2.8 and latest.

## UI Design

<img src="https://github.com/marcmacias96/flutter-parking-payment-web-app/blob/master/UI%26UX/home.png" alt="Home page">

<img src="https://github.com/marcmacias96/flutter-parking-payment-web-app/blob/master/UI%26UX/credit-card.png" alt="credit-card">

<img src="https://github.com/marcmacias96/flutter-parking-payment-web-app/blob/master/UI%26UX/success.png" alt="success">

## UX Experience

[UX Experience](https://www.figma.com/proto/GEgumMmiGCzk7pR4sp1KNO/Parking-Web-app?page-id=0%3A1&node-id=1%3A48&viewport=391%2C294%2C0.25380387902259827&scaling=scale-down)

<img src="https://github.com/marcmacias96/flutter-parking-payment-web-app/blob/master/UI%26UX/UX.gif" alt="UX">

# Development

* Code Design Standard: https://dart.dev/guides/language/effective-dart/documentation
* Lint: lint
* Tests: unit and integration tests

## Running Local

* Obtain necessary files from the flutter application

```console
$ flutter pub get
```
```console
$ flutter packages pub run build_runner build --delete-conflicting-outputs
```

* Run flutter application

enviroments = {

- main_dev.dart
- main_prd.dart
- main_stg.dart

} 

```console
$ flutter run lib/{enviroment}
```

## Linting

Before committing any code, make sure the code is as clean as possible without linting errors.

https://dart.dev/guides/language/analysis-options

```console
$ dart analyze {File_to_analyze}
```

Example: 

```console
$ dart analyze lib/infrastructure/user/user_repository.dart
Analyzing user_repository.dart...
No issues found!
```

## Testing

Make sure to include basic unit/integration tests where possible.

### Unit tests

SignIn an SignUp test
- Note: You must change the email in SignUp to create a new account.
```console
$ flutter test test/infrastructure/signin_signup_test.dart
00:03 +0: SignUp test
00:05 +1: SignIn test
00:06 +2: All tests passed!
```

User test
```console
$ flutter test test/infrastructure/user_repository_test.dart
00:03 +0: Get all genres test
00:03 +1: Get user test
00:04 +2: Patch phone number test
00:04 +3: Save user address test
00:06 +4: Patch user address test
00:07 +5: Delete user address test
00:09 +6: All tests passed!
```

Wallet test
```console
$ flutter test test/infrastructure/wallet_repository_test.dart 
00:03 +0: Save credit card test
00:03 +1: Patch credit card test
00:03 +2: Delete credit card test
00:03 +3: All tests passed!
```

Parkinglot test
```console
$ flutter test test/infrastructure/parking_lot_repository_test.dart 
00:05 +0: Ticket status test
00:06 +1: Save ticket status test
00:06 +2: Delete ticket status test
00:06 +3: Get service fee tes
00:07 +4: Ticket details test
00:07 +5: Get user tickets test
00:08 +6: All tests passed!
```

### Integration tests