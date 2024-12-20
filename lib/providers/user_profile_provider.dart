import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_expenses/models/user_profile.dart';

class UserProfileProvider extends StateNotifier<UserProfile?> {
  UserProfileProvider() : super(null);
  bool isUploading = false;
  bool isFetching = false;
  void toggleState(String subject, bool key) {
    switch (subject) {
      case "isUploading":
        isUploading = key;
        break;
      case "isFetching":
        isFetching = key;
      default:
    }
    state = state == null ? null : UserProfile.fromMap(state!.toMap());
  }

  bool get uploading => isUploading;
  bool get fetching => isFetching;
  Future<void> fetchData(String uid) async {
    try {
      toggleState("isFetching", true);
      final docsnapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (docsnapshot.exists) {
        state = UserProfile.fromMap(docsnapshot.data()!);
      } else {
        throw Exception('user Profile not found');
      }
    } catch (e) {
      throw Exception('Failed to fetch user profile ');
    } finally {
      toggleState("isFetching", false);
    }
  }

  Future<void> createOrUpdateUserProfile(UserProfile userProfile) async {
    try {
      toggleState("isUploading", true);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userProfile.uid)
          .set(userProfile.toMap(), SetOptions(merge: true));
      // print(response);
      state = userProfile;
    } catch (e) {
      throw Exception('Failed to create or update user profile: $e');
    } finally {
      toggleState("isUploading", false);
    }
  }

  Future<void> uploadProfilePic(File pic, String uid) async {
    try {
      toggleState("isUploading", true);
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profilePics/$uid/profile_picture.jpg');
      await storageRef.putFile(pic);
      final downloadUrl = await storageRef.getDownloadURL();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({'profilePictureUrl': downloadUrl});
    } catch (e) {
      throw Exception("Error uploading profile picture: $e");
    } finally {
      toggleState("isUploading", false);
    }
  }
}

final userProfileProvider =
    StateNotifierProvider<UserProfileProvider, UserProfile?>((ref) {
  return UserProfileProvider();
});
