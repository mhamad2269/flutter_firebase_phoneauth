import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../api/sharedPref.dart';
import '../constants/string.dart';
import '../models/person.dart';

class FirebaseMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<User?> getCurrentUser() async {
    return _auth.currentUser;
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return await _auth.signInWithCredential(credential);
  }

  Future<bool> authenticateUser(UserCredential userCredential) async {
    QuerySnapshot result = await firestore
        .collection(USERS_COLLECTION)
        .where(EMAIL_FIELD, isEqualTo: userCredential.user?.email)
        .get();

    final List<DocumentSnapshot> docs = result.docs;
    return docs.length == 0 ? true : false;
  }

  Future<void> addDataToDb(UserCredential userCred) async {
    print(userCred.user);
    Person user = Person(
        uid: userCred.user?.uid,
        name: userCred.user?.displayName,
        email: userCred.user?.email,
        profilePhoto: userCred.user?.photoURL);
    return firestore.collection(USERS_COLLECTION).doc(userCred.user?.uid).set(
          user.toMap(user),
        );
  }

  Future verifyOtp(
      {required String verificationId, required String smsCode}) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: smsCode);
    await _auth.signInWithCredential(credential);
  }

  Future<void> signOut() async {
    SharedPref.clearSharedPref();
    _googleSignIn.disconnect();
    _googleSignIn.signOut();
    return _auth.signOut();
  }
}
