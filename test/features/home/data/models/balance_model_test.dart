import 'package:flutter_test/flutter_test.dart';
import 'package:my_super_exchange_flutter/features/home/data/models/balance_model.dart';

void main() {
  group('BalanceModel', () {
    const amount = 1500.50;
    const currency = 'USD';

    const jsonMap = {
      'amount': amount,
      'currency': currency,
    };

    test('should return a valid model from JSON', () {
      final result = BalanceModel.fromJson(jsonMap);

      expect(result, isA<BalanceModel>());
      expect(result.amount, amount);
      expect(result.currency, currency);
    });

    test('should return a JSON map containing the proper data', () {
      const model = BalanceModel(
        amount: amount,
        currency: currency,
      );

      final result = model.toJson();

      expect(result, jsonMap);
    });

    test('copyWith should return a new instance with updated values', () {
      const model = BalanceModel(
        amount: amount,
        currency: currency,
      );

      final updatedModel = model.copyWith(
        amount: 2000.75,
        currency: 'EUR',
      );

      expect(updatedModel.amount, 2000.75);
      expect(updatedModel.currency, 'EUR');
    });

    test('should handle zero balance', () {
      const model = BalanceModel(
        amount: 0.0,
        currency: 'PEN',
      );

      expect(model.amount, 0.0);
    });

    test('should handle integer amounts from JSON', () {
      final jsonWithInt = {
        'amount': 1500,
        'currency': 'BRL',
      };

      final result = BalanceModel.fromJson(jsonWithInt);

      expect(result.amount, 1500.0);
      expect(result.currency, 'BRL');
    });

    test('should handle large amounts', () {
      const model = BalanceModel(
        amount: 999999.99,
        currency: 'BTC',
      );

      expect(model.amount, 999999.99);
    });
  });
}

