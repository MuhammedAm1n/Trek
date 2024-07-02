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

//Get User Details
  Future<DocumentSnapshot<Map<String, dynamic>>> GetUserDetails() async {
    try {
      // Get the current user from FirebaseAuth
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception("User not authenticated");
      }

      // Fetch the latest user details from Firestore
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection("Users")
          .doc(currentUser.email)
          .get();

      // Return the document snapshot containing user details
      return snapshot;
    } catch (e) {
      // Handle any errors here
      print("Error fetching user details: $e");
      throw e; // Optionally rethrow the error for upstream handling
    }
  }

// Login with google
  Future<void> loginWithGoogle() async {
    // Sign in with Google
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    if (gUser == null) {
      throw Exception("Google Sign-In aborted by user");
    }

    // Obtain auth details from the request
    final GoogleSignInAuthentication gAuth = await gUser.authentication;

    // Create a new credential
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    // Sign in to Firebase with the Google credential
    userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    // Create or update user in Firestore
  }

  Future<void> _createOrUpdateUser(
      UserCredential userCredential, String userName,
      {String photoUrl = ""}) async {
    if (userCredential.user == null) {
      throw Exception("User is not signed in");
    }

    final User user = userCredential.user!;
    final DocumentReference userDoc =
        FirebaseFirestore.instance.collection("Users").doc(user.email);

    final Map<String, dynamic> userData = {
      "email": user.email,
      "username": userName,
      "uid": user.uid,
      "photo": photoUrl.isEmpty ? "s" : photoUrl,
    };

    await userDoc.set(userData);
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
        "photo": "s"
      });
    } else {
      throw ("Error Return creation");
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
}
