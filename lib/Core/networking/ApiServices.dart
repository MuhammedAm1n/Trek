import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ApiServices {
  UserCredential? userCredential;
  final User? currentUser = FirebaseAuth.instance.currentUser;

  // lOGIN WITH email and password
  Future logiN(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        throw ('Worng Password/Email or Create new Account');
      } else if (e.code == "invalid-email") {
        throw ('Bad email format');
      } else {
        throw e.code;
      }
    }
  }

// Login with google
  Future loginWithGoogle() async {
    // Open the page of Google Signin
    try {
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
      // obtain auth details from request
      final GoogleSignInAuthentication gAuth = await gUser!.authentication;

      // create a new credential for user
      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );
      // lets Sign in
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } on Exception catch (e) {
      throw e.toString();
    }
  }

  Future registeR(String Email, String Password) async {
    try {
      userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: Email, password: Password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw ('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        throw ('The account already exists for that email.');
      } else {
        throw e.code;
      }
    }
  }

  Future createUser(String userName, {String photoUrl = " "}) async {
    if (userCredential != null && userCredential!.user != null) {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(userCredential!.user!.email)
          .set({
        "email": userCredential!.user!.email,
        "username": userName,
        "uid": userCredential!.user!.uid,
        "photo": photoUrl
      });
    } else {
      throw ("Error Return creation");
    }
  }
}
