import '../../domain/entities/user.dart';

class UserModel extends CommunityUser {
  const UserModel({
    required super.id,
    required super.fullName,
    required super.email,
    super.photoBase64,
  });

  factory UserModel.fromJson(String id, Map<String, dynamic> json) => UserModel(
    id: id,
    fullName: json['fullName'] as String? ?? '',
    email: json['email'] as String? ?? '',
    photoBase64: json['photoBase64'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'fullName': fullName,
    'email': email,
    if (photoBase64 != null) 'photoBase64': photoBase64,
  };
}

// Builder sets only the profile fields supplied at registration.
class UserBuilder {
  UserBuilder(this.id);
  final String id;
  String? _fullName;
  String? _email;
  String? _photoBase64;

  UserBuilder withFullName(String value) {
    _fullName = value;
    return this;
  }

  UserBuilder withEmail(String value) {
    _email = value;
    return this;
  }

  UserBuilder withPhoto(String value) {
    _photoBase64 = value;
    return this;
  }

  UserModel build() => UserModel(
    id: id,
    fullName: _fullName ?? '',
    email: _email ?? '',
    photoBase64: _photoBase64,
  );
}
