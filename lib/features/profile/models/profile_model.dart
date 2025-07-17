import '../../auth/models/user_model.dart';

class Profile {
  final String id;
  final String name;
  final String phone;
  final String? email;
  final String? dateOfBirth;
  final String? gender;
  final String? avatarUrl;
  final int points;
  final List<String>? addresses;

  Profile({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    this.dateOfBirth,
    this.gender,
    this.avatarUrl,
    this.points = 0,
    this.addresses,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
      'avatarUrl': avatarUrl,
      'points': points,
      'addresses': addresses,
    };
  }

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? 'User',
      phone: map['phone']?.toString() ?? '',
      email: map['email']?.toString(),
      dateOfBirth: map['dateOfBirth']?.toString(),
      gender: map['gender']?.toString(),
      avatarUrl: map['avatarUrl']?.toString(),
      points: map['points']?.toInt() ?? 0,
      addresses: map['addresses'] != null 
          ? List<String>.from(map['addresses']) 
          : null,
    );
  }

  factory Profile.fromUser(User user) {
    return Profile(
      id: user.id,
      name: user.name,
      phone: user.phone,
      email: user.email,
      dateOfBirth: user.dateOfBirth,
      gender: user.gender,
      avatarUrl: user.avatarUrl,
    );
  }

  User toUser() {
    return User(
      id: id,
      name: name,
      phone: phone,
      email: email,
      dateOfBirth: dateOfBirth,
      gender: gender,
      avatarUrl: avatarUrl,
    );
  }
}
