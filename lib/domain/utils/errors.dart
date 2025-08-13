String getFirebaseAuthErrorMessage(String code, String? message) {
  print('Error code : $code');
  switch (code) {
    case 'email-already-in-use':
      return 'This email is already in use.';
    case 'invalid-email':
      return 'The email address is invalid.';
    case 'operation-not-allowed':
      return 'Email/password sign-up is not enabled.';
    case 'weak-password':
      return 'Password is too weak. Try a stronger one.';
    case 'user-not-found':
      return 'No user found with this email.';
    case 'wrong-password':
      return 'The password is incorrect.';
    case 'user-disabled':
      return 'This user account has been disabled.';
    case 'too-many-requests':
      return 'Too many requests. Please try again later.';
    default:
      return 'Authentication failed. ${message ?? ''}';
  }
}
