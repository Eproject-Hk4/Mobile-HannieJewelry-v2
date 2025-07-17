class User {
  final String id;
  final String name;
  final String phone;
  final String? email;
  final String? dateOfBirth;
  final String? gender;
  final String? avatarUrl;

  User({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    this.dateOfBirth,
    this.gender,
    this.avatarUrl,
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
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? 'User',
      phone: map['phone']?.toString() ?? '',
      email: map['email']?.toString(),
      dateOfBirth: map['dateOfBirth']?.toString(),
      gender: map['gender']?.toString(),
      avatarUrl: map['avatarUrl']?.toString(),
    );
  }

  User copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    String? dateOfBirth,
    String? gender,
    String? avatarUrl,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}