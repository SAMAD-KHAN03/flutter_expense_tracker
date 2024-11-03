import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_expenses/models/user_profile.dart';

class UserProfileProvider extends StateNotifier<UserProfile?> {
  UserProfileProvider() : super(null);

  Future<void> fetchData(String uid) async {
    try {
      final docsnapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (docsnapshot.exists) {
        state = UserProfile.fromMap(docsnapshot.data()!);
      } else {
        throw Exception('user Profile not found');
      }
    } catch (e) {
      throw Exception('Faile to fetch user profile ');
    }
  }

  Future<void> createOrUpdateUserProfile(UserProfile userProfile) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userProfile.uid)
          .set(userProfile.toMap(), SetOptions(merge: true));
      state = userProfile;
    } catch (e) {
      throw Exception('Failed to create or update user profile: $e');
    }
  }

  Future<void> uploadProfilePic(File pic, String uid) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profilePics/$uid/profile_picture.jpg');
      storageRef.putFile(pic);
      final downloadUrl = await storageRef.getDownloadURL();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({'profilePictureUrl': downloadUrl});
    } catch (e) {
      throw Exception("Error uploading profile picture: $e");
    } 
  }
}

final userProfileProvider =
    StateNotifierProvider<UserProfileProvider, UserProfile?>((ref) {
  return UserProfileProvider();
});
