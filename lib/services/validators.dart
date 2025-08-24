class Validators {
  static final _emailRegex = RegExp(
    r"^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$",
  );

  /// "Temporary/throwaway" email quick check (common disposable domains).
  static const _tempDomains = {
    'mailinator.com',
    'tempmail.com',
    'guerrillamail.com',
    '10minutemail.com',
  };

  static String? email(String? value) {
    final v = (value ?? '').trim();
    if (v.isEmpty) return 'Email is required';
    if (!_emailRegex.hasMatch(v)) return 'Invalid email format';
    final domain = v.split('@').last.toLowerCase();
    if (_tempDomains.contains(domain)) {
      return 'Temporary emails are not allowed';
    }
    return null;
  }

  /// At least 8 chars, 1 letter, 1 number
  static String? strongPassword(String? value) {
    final v = (value ?? '');
    if (v.isEmpty) return 'Password is required';
    if (v.length < 8) return 'Use 8+ characters';
    if (!RegExp(r'[A-Za-z]').hasMatch(v)) return 'Include at least one letter';
    if (!RegExp(r'\d').hasMatch(v)) return 'Include at least one number';
    return null;
  }

  /// Ensure confirm password matches the original password
  static String? confirmPassword(String? value, String original) {
    final v = (value ?? '');
    if (v.isEmpty) return 'Please confirm your password';
    if (v != original) return 'Passwords do not match';
    return null;
  }
}
