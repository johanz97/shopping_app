import 'package:dartz/dartz.dart';
import 'value_failures.dart';
import 'value_validators.dart';

class Validator {
  Validator._();

  static Either<ValueFailure<String>, String> validateCardNumber(String value) {
    var maxLength = 16;
    if (value.contains(" ")) {
      maxLength = 19;
    }
    return validateMaxStringLength(value, maxLength)
        .flatMap(validateStringNotEmpty)
        .flatMap(validateMinCardNumberLength);
  }

  static Either<ValueFailure<String>, String> validateTicketId(String value) {
    return validateMinStringLength(value, 12).flatMap(validateStringNotEmpty);
  }

  static Either<ValueFailure<String>, String> validateDateExp(String value) {
    return validateStringNotEmpty(value)
        .flatMap(validateMonth)
        .flatMap(validateYear);
  }

  static Either<ValueFailure<String>, String> validateCvvCode(String value) {
    return validateStringNotEmpty(value);
  }

  static Either<ValueFailure<String>, String> validateName(String value) {
    return validateMaxStringLength(value, 30)
        .flatMap(validateStringNotEmpty)
        .flatMap(validateSingleLine);
  }

  static Either<ValueFailure<String>, String> validateEmail(String value) {
    return validateStringNotEmpty(value)
        .flatMap(validateSingleLine)
        .flatMap(validateIsEmail);
  }

  static Either<ValueFailure<String>, String> validateOtp(String value) {
    return validateStringNotEmpty(value).flatMap(validateSingleLine);
  }

  static Either<ValueFailure<String>, String> validatePassWord(String value) {
    return validateMinStringLength(value, 8)
        .flatMap(validateStringNotEmpty)
        .flatMap(validateSingleLine);
  }

  static Either<ValueFailure<String>, String> validatePhoneNumber(
    String value,
  ) {
    return validateMinStringLength(value, 15)
        .flatMap(validateStringNotEmpty)
        .flatMap(validateSingleLine);
  }

  static Either<ValueFailure<String>, String> validateBirth(
    String value,
  ) {
    return validateMinStringLength(value, 10)
        .flatMap(validateStringNotEmpty)
        .flatMap(validateSingleLine);
  }

  static Either<ValueFailure<String>, String> validateCpfOrCnpj(
    String value,
  ) {
    return validateIsCpfOrCnpj(value)
        .flatMap(validateStringNotEmpty)
        .flatMap(validateSingleLine);
  }

  static Either<ValueFailure<String>, String> validateCep(
    String value,
  ) {
    return validateMinStringLength(value, 8).flatMap(validateStringNotEmpty);
  }

  static Either<ValueFailure<String>, String> validateAddressProperties(
    String value,
  ) {
    return validateStringNotEmpty(value).flatMap(validateSingleLine);
  }
}
