import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';


class Authentication extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  bool _isSignout = false;

  bool get isLoading => _isLoading;
  bool get isSignout => _isSignout;

  Stream<User?> get statechange => _auth.authStateChanges();

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setSignout(bool value) {
    _isSignout = value;
    notifyListeners();
  }

  Future<void> signIn(
      String email, String password, BuildContext context) async {
    _setLoading(true);
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      await _showErrorDialog(context, e.message ?? 'Authentication error');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signUp(
      String email, String password, BuildContext context) async {
    _setLoading(true);
    try {
       await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      await _showErrorDialog(
          context, e.message ?? 'Error occurred during sign-up');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    _setSignout(true);
    try {
      await _auth.signOut();
      await GoogleSignIn().signOut();
      await GoogleSignIn().disconnect();
    } catch (e) {
      throw Exception('Error signing out: ${e.toString()}');
    } finally {
      _setSignout(false);
    }
  }

  Future<void> _showErrorDialog(BuildContext context, String message) async {
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<dynamic> signInUsingGoogle(BuildContext context) async {
    _setLoading(true);
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credentials = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      return await _auth.signInWithCredential(credentials);
    } on Exception catch (e) {
      await _showErrorDialog(context, e.toString());
    } finally {
      _setLoading(false);
    }
  }
}
