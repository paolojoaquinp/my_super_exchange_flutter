import 'package:flutter_test/flutter_test.dart';
import 'package:my_super_exchange_flutter/features/exchange/domain/entities/currency_entity.dart';

void main() {
  group('CurrencyEntity', () {
    test('should have the correct properties', () {
      const currencyEntity = CurrencyEntity(
        id: '1',
        code: 'USD',
        name: 'US Dollar',
        type: CurrencyType.fiat,
        icon: 'usd_icon.png',
      );

      expect(currencyEntity.id, '1');
      expect(currencyEntity.code, 'USD');
      expect(currencyEntity.name, 'US Dollar');
      expect(currencyEntity.type, CurrencyType.fiat);
      expect(currencyEntity.icon, 'usd_icon.png');
    });

    test('should support crypto currency type', () {
      const currencyEntity = CurrencyEntity(
        id: '2',
        code: 'BTC',
        name: 'Bitcoin',
        type: CurrencyType.crypto,
        icon: 'btc_icon.png',
      );

      expect(currencyEntity.type, CurrencyType.crypto);
      expect(currencyEntity.code, 'BTC');
    });

    test('should allow null icon', () {
      const currencyEntity = CurrencyEntity(
        id: '3',
        code: 'ETH',
        name: 'Ethereum',
        type: CurrencyType.crypto,
      );

      expect(currencyEntity.icon, isNull);
    });
  });
}

