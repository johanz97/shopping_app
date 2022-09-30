import 'package:cpf_cnpj_validator/cnpj_validator.dart';
import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:dartx/dartx.dart';
import 'package:dartz/dartz.dart';

import 'value_failures.dart';

Either<ValueFailure<String>, String> validateMaxStringLength(
  String input,
  int maxLength,
) {
  if (input.length <= maxLength) {
    return right(input);
  } else {
    return left(
      ValueFailure.exceedingStringLength(
        failedValue: input,
        max: maxLength,
      ),
    );
  }
}

Either<ValueFailure<String>, String> validateMinStringLength(
  String input,
  int minLength,
) {
  if (input.length >= minLength) {
    return right(input);
  } else {
    return left(
      ValueFailure.withOutMinStringLength(
        failedValue: input,
        min: minLength,
      ),
    );
  }
}

Either<ValueFailure<String>, String> validateStringNotEmpty(String input) {
  if (input.isEmpty) {
    return left(ValueFailure.empty(failedValue: input));
  } else {
    return right(input);
  }
}

Either<ValueFailure<String>, String> validateSingleLine(String input) {
  if (input.contains('\n')) {
    return left(ValueFailure.multiline(failedValue: input));
  } else {
    return right(input);
  }
}

Either<ValueFailure<int>, int> validateMaxIntLength(
  int input,
  int maxLength,
) {
  if (input.toString().length <= maxLength) {
    return right(input);
  } else {
    return left(
      ValueFailure.exceedingIntLength(
        failedValue: input,
        max: maxLength,
      ),
    );
  }
}

Either<ValueFailure<String>, String> isOnlyString(String input) {
  if (RegExp('[A-Za-z ]').hasMatch(input)) {
    return right(input);
  } else {
    return left(
      ValueFailure.notIsOnlyString(
        failedValue: input,
      ),
    );
  }
}

Either<ValueFailure<String>, String> isOnlyNumber(String input) {
  if (RegExp('[0-9]').hasMatch(input)) {
    return right(input);
  } else {
    return left(
      ValueFailure.notIsOnlyString(
        failedValue: input,
      ),
    );
  }
}

Either<ValueFailure<String>, String> isDate(String input) {
  if (RegExp('[0-9]/[0-9]').hasMatch(input)) {
    return right(input);
  } else {
    return left(
      ValueFailure.notIsOnlyString(
        failedValue: input,
      ),
    );
  }
}

Either<ValueFailure<String>, String> validateMinCardNumberLength(
  String input,
) {
  if (input.contains(" ")) {
    if (input.length == 19) {
      return right(input);
    } else {
      return left(
        ValueFailure.missingStringLength(
          failedValue: input,
        ),
      );
    }
  } else {
    if (input.length == 16) {
      return right(input);
    } else {
      return left(
        ValueFailure.missingStringLength(
          failedValue: input,
        ),
      );
    }
  }
}

Either<ValueFailure<int>, int> validateIntNotEmpty(int input) {
  if (input.toString().isEmpty || input == 0) {
    return left(ValueFailure.empty(failedValue: input.toString()));
  } else {
    return right(input);
  }
}

Either<ValueFailure<String>, String> validateMonth(String input) {
  int? month;
  if (input.length >= 2) {
    month = input.substring(0, 2).toIntOrNull();
    if (month != null) {
      if (month != 0 && month <= 12) {
        return right(input);
      } else {
        return left(ValueFailure.invalidMonth(failedValue: input));
      }
    } else {
      return left(ValueFailure.invalidMonth(failedValue: input));
    }
  } else {
    return left(ValueFailure.invalidMonth(failedValue: input));
  }
}

Either<ValueFailure<String>, String> validateYear(String input) {
  int? year;
  if (input.length > 3) {
    year = input.substring(3).toIntOrNull();
    if (year != null) {
      final actualYear = DateTime.now().year;
      if (year != 0 && year >= actualYear) {
        return right(input);
      } else {
        return left(ValueFailure.invalidYear(failedValue: input));
      }
    } else {
      return left(ValueFailure.invalidYear(failedValue: input));
    }
  } else {
    return right(input);
  }
}

Either<ValueFailure<String>, String> validateIsEmail(String input) {
  if (input.contains('@') && input.contains('.')) {
    return right(input);
  } else {
    return left(ValueFailure.invalidEmail(failedValue: input));
  }
}

Either<ValueFailure<String>, String> validateIsCpfOrCnpj(String input) {
  if (CPFValidator.isValid(input) || CNPJValidator.isValid(input)) {
    return right(input);
  } else {
    return left(ValueFailure.invalidCpfOrCnpj(failedValue: input));
  }
}
