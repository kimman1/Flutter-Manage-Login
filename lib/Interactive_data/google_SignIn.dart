import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';

class supportSignInGoogle {
  GoogleSignInAccount? _currentUser;

  Future<void> handleSignIn(GoogleSignIn googleSignIn) async {
    await googleSignIn.signIn();
    //return _currentUser;
  }

  Future<void> handleSignOut(GoogleSignIn googleSignIn) async {
    googleSignIn.disconnect();
  }

  GoogleSignInAccount? returnCurrentUser() {
    return _currentUser;
  }
}
