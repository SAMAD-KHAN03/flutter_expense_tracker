// ignore_for_file: prefer_const_constructors
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_expenses/models/user_profile.dart';
import 'package:my_expenses/providers/auth_provider.dart';
import 'package:my_expenses/providers/user_profile_provider.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePage();
}

class _ProfilePage extends ConsumerState<ProfilePage> {
  File? selectedImage;
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  // Function to pick and upload a profile image
  Future<void> pickImage() async {
    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        selectedImage = File(pickedImage.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    final uid = ref.read(authenticationProvider.notifier).uid();
    ref.read(userProfileProvider.notifier).fetchData(uid).then((_) {
      final userProfile = ref.read(userProfileProvider);

      if (userProfile != null) {
        name.text = userProfile.name;
        email.text = userProfile.email;
        phoneNumber.text = userProfile.phoneNumber;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    name.dispose();
    email.dispose();
    phoneNumber.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = ref.watch(userProfileProvider);
    ImageProvider<Object> avatarImage;
    if (selectedImage != null) {
      avatarImage = FileImage(selectedImage!);
    } else if (userProfile != null &&
        userProfile.profilePictureUrl.isNotEmpty) {
      avatarImage = NetworkImage(userProfile.profilePictureUrl);
    } else {
      avatarImage = AssetImage(
          'lib/assets/images/—Pngtree—man avatar image for profile_13001882.png');
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(radius: 60, backgroundImage: avatarImage),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 18,
                      child: IconButton(
                          onPressed: () {
                            pickImage();
                          },
                          icon: const Icon(Icons.edit))),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Name Field
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                'Name',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              subtitle: TextField(
                obscureText: false,
                autocorrect: false,
                keyboardType: TextInputType.numberWithOptions(),
                controller: name,
              ),
              trailing: Icon(Icons.chevron_right),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text(
                'Phone',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              subtitle: TextField(
                obscureText: false,
                autocorrect: false,
                keyboardType: TextInputType.numberWithOptions(),
                controller: phoneNumber,
              ),
              trailing: Icon(Icons.chevron_right),
            ),

            // Email Field
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                'Email',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              subtitle: TextField(
                obscureText: false,
                autocorrect: false,
                keyboardType: TextInputType.numberWithOptions(),
                controller: email,
              ),
              trailing: Icon(Icons.chevron_right),
            ),
            SizedBox(
              height: 8,
            ),
            TextButton.icon(
              onPressed: () {
                final uid = ref.read(authenticationProvider.notifier).uid();
                ref
                    .watch(userProfileProvider.notifier)
                    .createOrUpdateUserProfile(UserProfile(
                        uid: uid,
                        name: name.text,
                        email: email.text,
                        phoneNumber: phoneNumber.text));
                if (selectedImage != null) {
                  ref
                      .read(userProfileProvider.notifier)
                      .uploadProfilePic(selectedImage!, uid);
                }
              },
              label: Text('Create Profile'),
              icon: Icon(Icons.account_box),
            )
          ],
        ),
      ),
    );
  }
}
