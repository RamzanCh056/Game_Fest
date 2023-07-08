
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_sign_in_web/google_sign_in_web.dart';

class FirebaseAuthServices{
  static Future<User?> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
    await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
        await auth.signInWithCredential(credential);

        user = userCredential.user;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          // handle the error here
          Fluttertoast.showToast(msg: 'The account already exists with a different credential');
          // Fluttertoast
        }
        else if (e.code == 'invalid-credential') {
          Fluttertoast.showToast(msg: 'Error occurred while accessing credentials');
          // handle the error here
        }
      } catch (e) {
        // handle the error here 'Error occurred using Google Sign In. Try again.'
        Fluttertoast.showToast(msg: 'Error occurred using Google Sign In. Try again.');
      }
    }

    return user;
  }

  Future<User?> signInWithGoogleWeb() async {
    FirebaseAuth _auth=FirebaseAuth.instance;
    // Initialize Firebase
    // await Firebase.initializeApp();
    User? user;

    // The `GoogleAuthProvider` can only be used while running on the web
    GoogleAuthProvider authProvider = GoogleAuthProvider();

    try {
      final UserCredential userCredential =
      await _auth.signInWithPopup(authProvider);

      user = userCredential.user;
    } catch (e) {
      print(e);
    }

    String uid;
    String? name;
    String? userEmail;
    String? password;
    String? signinType;

    if (user != null) {
      uid = user.uid;
      name = user.displayName;
      userEmail = user.email;
      password = "Not Applicable";
      signinType="Google Sign in";

    }

    return user;
  }
}