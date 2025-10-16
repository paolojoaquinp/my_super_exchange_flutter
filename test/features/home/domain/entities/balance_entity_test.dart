import 'package:flutter_test/flutter_test.dart';
import 'package:my_super_exchange_flutter/features/home/domain/entities/balance_entity.dart';

void main() {
  group('BalanceEntity', () {
    test('should have the correct properties', () {
      const balanceEntity = BalanceEntity(
        amount: 1500.50,
        currency: 'USD',
      );

      expect(balanceEntity.amount, 1500.50);
      expect(balanceEntity.currency, 'USD');
    });

    test('should handle zero balance', () {
      const balanceEntity = BalanceEntity(
        amount: 0.0,
        currency: 'PEN',
      );

      expect(balanceEntity.amount, 0.0);
      expect(balanceEntity.currency, 'PEN');
    });

    test('should handle large amounts', () {
      const balanceEntity = BalanceEntity(
        amount: 999999.99,
        currency: 'BTC',
      );

      expect(balanceEntity.amount, 999999.99);
    });

    test('should handle negative amounts', () {
      const balanceEntity = BalanceEntity(
        amount: -100.50,
        currency: 'EUR',
      );

      expect(balanceEntity.amount, -100.50);
    });
  });
}

