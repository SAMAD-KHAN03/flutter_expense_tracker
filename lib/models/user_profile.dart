class UserProfile {
  final String uid;
  final String name;
  final String email;
  final String phoneNumber; // Add phone number as a String
  final String profilePictureUrl;

  UserProfile({
    required this.uid,
    required this.name,
    required this.email,
    required this.phoneNumber, // Make it required
    this.profilePictureUrl = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber, // Include phone number in the map
      'profilePictureUrl': profilePictureUrl,
    };
  }

  static UserProfile fromMap(Map<String, dynamic> map) {
    return UserProfile(
      uid: map['uid'],
      name: map['name'],
      email: map['email'],
      phoneNumber: map['phoneNumber'] ?? '', // Handle null gracefully
      profilePictureUrl: map['profilePictureUrl'] ?? '',
    );
  }
}
