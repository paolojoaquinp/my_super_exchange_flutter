import 'package:my_super_exchange_flutter/features/home/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.name,
    required super.firstName,
    required super.profileImage,
    required super.notificationCount,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'firstName': firstName,
      'profileImage': profileImage,
      'notificationCount': notificationCount,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'] as String,
      firstName: json['firstName'] as String,
      profileImage: json['profileImage'] as String,
      notificationCount: json['notificationCount'] as int,
    );
  }

  UserModel copyWith({
    String? name,
    String? firstName,
    String? profileImage,
    int? notificationCount,
  }) {
    return UserModel(
      name: name ?? this.name,
      firstName: firstName ?? this.firstName,
      profileImage: profileImage ?? this.profileImage,
      notificationCount: notificationCount ?? this.notificationCount,
    );
  }
}

