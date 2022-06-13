import 'package:form_field_validator/form_field_validator.dart';

//this Regular expression is for validate the password field
//- using Mayus[A-Z] minus[a-z] numbers [0-9] and simbols[!@#\$&*~]
//and minlenght is 8 characters
class PasswordValidator extends TextFieldValidator {
  final Pattern _passwordRegExp =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
  PasswordValidator({required String errorText}) : super(errorText);
  @override
  bool isValid(String? value) =>
      hasMatch(_passwordRegExp.toString(), value!, caseSensitive: false);
}

//this Regular expression is for validate string's
class StringValidator extends TextFieldValidator {
  final Pattern _stringRegExp = r'[a-zA-Z]';
  final Pattern _numberRegExp = r'[0-9]';
  StringValidator({required String errorText}) : super(errorText);

  @override
  bool isValid(String? value) {
    bool isValidString =
        hasMatch(_stringRegExp.toString(), value!, caseSensitive: false);
    bool isValidNumber =
        hasMatch(_numberRegExp.toString(), value, caseSensitive: false);

    if (isValidNumber) {
      return false;
    }
    if (isValidString) {
      return true;
    }

    return false;
  }
}

//this Regular expression is for validate numbers
class NumberValidator extends TextFieldValidator {
  final Pattern _stringRegExp = r'[a-zA-Z]';
  final Pattern _numberRegExp = r'[0-9]';

  NumberValidator({required String errorText}) : super(errorText);
  @override
  bool isValid(String? value) {
    bool isValidString =
        hasMatch(_stringRegExp.toString(), value!, caseSensitive: false);
    bool isValidNumber =
        hasMatch(_numberRegExp.toString(), value, caseSensitive: false);

    if (isValidString) {
      return false;
    } else if (isValidNumber) {
      return true;
    }
    return false;
  }
}

class NumberValidatorZero extends TextFieldValidator {
  final Pattern _stringRegExp = r'[a-zA-Z]';
  final Pattern _numberRegExp = r'[0-9]';

  NumberValidatorZero({required String errorText}) : super(errorText);
  @override
  bool isValid(String? value) {
    bool isValidString =
        hasMatch(_stringRegExp.toString(), value!, caseSensitive: false);
    bool isValidNumber =
        hasMatch(_numberRegExp.toString(), value, caseSensitive: false);

    if (int.parse(value) <= 0) {
      return false;
    }
    return true;
  }
}
