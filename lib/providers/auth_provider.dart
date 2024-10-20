import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_expenses/models/authentication.dart';

final authenticationProvider = ChangeNotifierProvider<Authentication>(
  (ref) => Authentication(),
);

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.read(authenticationProvider).statechange;
});