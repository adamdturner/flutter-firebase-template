# Data Models

## Purpose
Data model files define the structure of data objects in the application, particularly for Firestore documents. Each model provides type-safe conversion between app data and database documents.

## Key Requirements
- A new `*_model.dart` file must be created for every new type of firestore document that can be created
- This enforces good read/write from database methods in repositories and enforces consistent data types for document fields
- There must be `fromMap` and `toMap` methods for easy conversion between firestore document and the app
- Include a `copyWith` method for immutable updates
- Use named parameters with required/optional as appropriate
- Consider using enums for fields with fixed values

## Model Structure
1. **Properties**: Final fields representing the data
2. **Constructor**: Named parameters with required/optional fields
3. **fromMap**: Factory constructor to create model from Firestore data
4. **toMap**: Convert model to Map for Firestore writes
5. **copyWith**: Create modified copy of the model
6. **Computed Properties**: Getters for derived values

## Example

```dart
// Enum for type-safe field values
enum Gender { male, female, preferNotToSay }

class UserModel {
  final String uid;
  final String email;
  final String role;
  final String firstName;
  final String lastName;
  final String? phoneNumber;
  final Gender? gender;

  UserModel({
    required this.uid,
    required this.email,
    required this.role,
    this.firstName = '',
    this.lastName = '',
    this.phoneNumber,
    this.gender,
  });

  // Create model from Firestore document
  factory UserModel.fromMap(Map<String, dynamic> data, {required String uid}) {
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
      }
    }

    return UserModel(
      uid: uid,
      email: data['email'] ?? '',
      role: data['role'] ?? 'user',
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      phoneNumber: data['phoneNumber'],
      gender: gender,
    );
  }

  // Convert model to Map for Firestore
  Map<String, dynamic> toMap() => {
    'email': email,
    'role': role,
    'firstName': firstName,
    'lastName': lastName,
    'phoneNumber': phoneNumber,
    if (gender != null) 'gender': gender!.name,
  };

  // Immutable updates
  UserModel copyWith({
    String? firstName,
    String? lastName,
    String? phoneNumber,
  }) {
    return UserModel(
      uid: uid,
      email: email,
      role: role,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      gender: gender,
    );
  }

  // Computed property
  String get fullName => '$firstName $lastName'.trim();
}
```
