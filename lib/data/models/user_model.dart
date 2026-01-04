enum Gender { male, female, preferNotToSay }


class UserModel {
  final String uid;
  final String email;
  final String role;
  final String firstName;
  final String lastName;
  final String? phoneNumber;
  final String? profileImageUrl;
  final Gender? gender;
  final Map<String, dynamic> _data;

  UserModel({
    required this.uid,
    required this.email,
    required this.role,
    this.firstName = '',
    this.lastName = '',
    this.phoneNumber,
    this.profileImageUrl,
    this.gender,
    Map<String, dynamic>? data,
  }) : _data = data ?? {};

  Map<String, dynamic> getUserModelData() => Map<String, dynamic>.from(_data);

  factory UserModel.fromMap(Map<String, dynamic> data, {required String uid}) {
    // Parse gender
    Gender? gender;
    if (data['gender'] != null) {
      final genderString = data['gender'].toString().toLowerCase();
      switch (genderString) {
        case 'male':
          gender = Gender.male;
          break;
        case 'female':
          gender = Gender.female;
          break;
        case 'prefernottosay':
        case 'prefer_not_to_say':
          gender = Gender.preferNotToSay;
          break;
      }
    }


    return UserModel(
      uid: uid,
      email: data['email'] ?? '',
      role: data['role'] ?? 'user',
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      phoneNumber: data['phoneNumber'],
      profileImageUrl: data['profileImageUrl'],
      gender: gender,
      data: Map<String, dynamic>.from(data),
    );
  }

  UserModel copyWith({
    String? uid,
    String? email,
    String? role,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? profileImageUrl,
    Gender? gender,
    Map<String, dynamic>? data,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      role: role ?? this.role,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      gender: gender ?? this.gender,
      data: data ?? getUserModelData(),
    );
  }

  String get fullName => '$firstName $lastName'.trim();

  Map<String, dynamic> toMap() => {
    'email': email,
    'role': role,
    'firstName': firstName,
    'lastName': lastName,
    'phoneNumber': phoneNumber,
    'profileImageUrl': profileImageUrl,
    if (gender != null) 'gender': gender!.name,
  };

  /// Returns the display name of the user (full name or email as fallback)
  String get displayName => fullName.isNotEmpty ? fullName : email;
  
  /// Alias for displayName for backwards compatibility
  String get displayTitle => displayName;
}
