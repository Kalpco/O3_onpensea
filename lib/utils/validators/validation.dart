class U_Validator {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email id is required';
    }

    //Regular expression for email validation
    final emailRegExpression = RegExp('');

    if (!emailRegExpression.hasMatch(value)) {
      return 'Invalid Email Id';
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 6) {
      return 'Password must be atleast 6 characters long';
    }

    return null;
  }
}
