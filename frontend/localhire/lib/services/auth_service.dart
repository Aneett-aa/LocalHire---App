import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 🔐 Hash password
  String hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // 📲 Send OTP
  Future<void> sendOTP({
    required String phone,
    required Function(String verificationId) onCodeSent,
  }) async {

    await _auth.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (PhoneAuthCredential credential) async {},
      verificationFailed: (FirebaseAuthException e) {
        print("OTP Failed: ${e.message}");
      },
      codeSent: (String verificationId, int? resendToken) {
        onCodeSent(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  // 🔢 Verify OTP
  Future<void> verifyOTP({
    required String verificationId,
    required String smsCode,
  }) async {

    PhoneAuthCredential credential =
        PhoneAuthProvider.credential(
          verificationId: verificationId,
          smsCode: smsCode,
        );

    await _auth.signInWithCredential(credential);
  }

  // 💾 Save User
  Future<void> saveUser({
    required String username,
    required String password,
    required String phone,
  }) async {

    final hashedPassword = hashPassword(password);

    await _firestore.collection('users').doc(username).set({
      'username': username,
      'password': hashedPassword,
      'phone': phone,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // 🔑 Login
  Future<bool> loginUser({
    required String username,
    required String password,
  }) async {

    final doc = await _firestore
        .collection('users')
        .doc(username)
        .get();

    if (!doc.exists) return false;

    final storedHash = doc['password'];
    final enteredHash = hashPassword(password);

    return storedHash == enteredHash;
  }
}
