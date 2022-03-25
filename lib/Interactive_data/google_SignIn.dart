import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';

class supportSignInGoogle {
  final GoogleSignIn googleSignIn = GoogleSignIn(
    // Optional clientId
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );
  Future<void> handleSignIn() async {
    try {
      await googleSignIn.signIn();
    } catch (error) {
      print(error);
    }

    Future<void> handleSignOut() async {
      googleSignIn.disconnect();
    }

    GoogleSignInAccount? rgturnCurrentUser() {
      GoogleSignInAccount? _currentUser;
      googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
        _currentUser = account;
      });
      return _currentUser;
    }
  }
}
