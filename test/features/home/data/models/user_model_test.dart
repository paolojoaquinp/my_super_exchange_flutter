import 'package:flutter_test/flutter_test.dart';
import 'package:my_super_exchange_flutter/features/home/data/models/user_model.dart';

void main() {
  group('UserModel', () {
    const name = 'John Doe';
    const firstName = 'John';
    const profileImage = 'profile.jpg';
    const notificationCount = 5;

    const jsonMap = {
      'name': name,
      'firstName': firstName,
      'profileImage': profileImage,
      'notificationCount': notificationCount,
    };

    test('should return a valid model from JSON', () {
      final result = UserModel.fromJson(jsonMap);

      expect(result, isA<UserModel>());
      expect(result.name, name);
      expect(result.firstName, firstName);
      expect(result.profileImage, profileImage);
      expect(result.notificationCount, notificationCount);
    });

    test('should return a JSON map containing the proper data', () {
      const model = UserModel(
        name: name,
        firstName: firstName,
        profileImage: profileImage,
        notificationCount: notificationCount,
      );

      final result = model.toJson();

      expect(result, jsonMap);
    });

    test('copyWith should return a new instance with updated values', () {
      const model = UserModel(
        name: name,
        firstName: firstName,
        profileImage: profileImage,
        notificationCount: notificationCount,
      );

      final updatedModel = model.copyWith(
        name: 'Jane Doe',
        notificationCount: 10,
      );

      expect(updatedModel.name, 'Jane Doe');
      expect(updatedModel.notificationCount, 10);
      expect(updatedModel.firstName, firstName);
      expect(updatedModel.profileImage, profileImage);
    });

    test('should handle zero notifications', () {
      const model = UserModel(
        name: name,
        firstName: firstName,
        profileImage: profileImage,
        notificationCount: 0,
      );

      expect(model.notificationCount, 0);
    });

    test('should handle large notification counts', () {
      const model = UserModel(
        name: name,
        firstName: firstName,
        profileImage: profileImage,
        notificationCount: 999,
      );

      expect(model.notificationCount, 999);
    });
  });
}

