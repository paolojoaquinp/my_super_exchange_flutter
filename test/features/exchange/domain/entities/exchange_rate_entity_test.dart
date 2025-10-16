import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_super_exchange_flutter/features/exchange/domain/entities/exchange_rate_entity.dart';

void main() {
  group('ExchangeRateEntity', () {
    test('should have the correct properties', () {
      final exchangeRateEntity = ExchangeRateEntity(
        exchangeRate: Decimal.parse('3.75'),
        fromAmount: Decimal.parse('100'),
        toAmount: Decimal.parse('375'),
        platformFee: Decimal.parse('0.5'),
        fromCurrencyId: 'PEN',
        toCurrencyId: 'USDT',
      );

      expect(exchangeRateEntity.exchangeRate, Decimal.parse('3.75'));
      expect(exchangeRateEntity.fromAmount, Decimal.parse('100'));
      expect(exchangeRateEntity.toAmount, Decimal.parse('375'));
      expect(exchangeRateEntity.platformFee, Decimal.parse('0.5'));
      expect(exchangeRateEntity.fromCurrencyId, 'PEN');
      expect(exchangeRateEntity.toCurrencyId, 'USDT');
    });

    test('should work with zero values', () {
      final exchangeRateEntity = ExchangeRateEntity(
        exchangeRate: Decimal.zero,
        fromAmount: Decimal.zero,
        toAmount: Decimal.zero,
        platformFee: Decimal.zero,
        fromCurrencyId: 'USD',
        toCurrencyId: 'BTC',
      );

      expect(exchangeRateEntity.exchangeRate, Decimal.zero);
      expect(exchangeRateEntity.fromAmount, Decimal.zero);
      expect(exchangeRateEntity.toAmount, Decimal.zero);
      expect(exchangeRateEntity.platformFee, Decimal.zero);
    });

    test('should handle large decimal values', () {
      final exchangeRateEntity = ExchangeRateEntity(
        exchangeRate: Decimal.parse('0.000025'),
        fromAmount: Decimal.parse('1000000'),
        toAmount: Decimal.parse('25'),
        platformFee: Decimal.parse('5000'),
        fromCurrencyId: 'USD',
        toCurrencyId: 'BTC',
      );

      expect(exchangeRateEntity.exchangeRate, Decimal.parse('0.000025'));
      expect(exchangeRateEntity.toAmount, Decimal.parse('25'));
    });
  });
}

