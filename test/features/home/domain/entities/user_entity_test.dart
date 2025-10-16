import 'package:flutter_test/flutter_test.dart';
import 'package:my_super_exchange_flutter/features/home/domain/entities/user_entity.dart';

void main() {
  group('UserEntity', () {
    test('should have the correct properties', () {
      const userEntity = UserEntity(
        name: 'John Doe',
        firstName: 'John',
        profileImage: 'profile.jpg',
        notificationCount: 5,
      );

      expect(userEntity.name, 'John Doe');
      expect(userEntity.firstName, 'John');
      expect(userEntity.profileImage, 'profile.jpg');
      expect(userEntity.notificationCount, 5);
    });

    test('should handle zero notifications', () {
      const userEntity = UserEntity(
        name: 'Jane Smith',
        firstName: 'Jane',
        profileImage: 'jane.jpg',
        notificationCount: 0,
      );

      expect(userEntity.notificationCount, 0);
    });

    test('should handle multiple notifications', () {
      const userEntity = UserEntity(
        name: 'Bob Johnson',
        firstName: 'Bob',
        profileImage: 'bob.jpg',
        notificationCount: 99,
      );

      expect(userEntity.notificationCount, 99);
    });
  });
}

