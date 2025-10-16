import 'package:flutter_test/flutter_test.dart';
import 'package:my_super_exchange_flutter/features/exchange/data/models/currency_model.dart';
import 'package:my_super_exchange_flutter/features/exchange/domain/entities/currency_entity.dart';

void main() {
  group('CurrencyModel', () {
    const id = '1';
    const code = 'USD';
    const name = 'US Dollar';
    const type = CurrencyType.fiat;
    const icon = 'usd_icon.png';

    final jsonMap = {
      'id': id,
      'code': code,
      'name': name,
      'type': 'fiat',
      'icon': icon,
    };

    test('should return a valid model from JSON with fiat type', () {
      final result = CurrencyModel.fromJson(jsonMap);

      expect(result, isA<CurrencyModel>());
      expect(result.id, id);
      expect(result.code, code);
      expect(result.name, name);
      expect(result.type, type);
      expect(result.icon, icon);
    });

    test('should return a valid model from JSON with crypto type', () {
      final cryptoJsonMap = {
        'id': '2',
        'code': 'BTC',
        'name': 'Bitcoin',
        'type': 'crypto',
        'icon': 'btc_icon.png',
      };

      final result = CurrencyModel.fromJson(cryptoJsonMap);

      expect(result, isA<CurrencyModel>());
      expect(result.type, CurrencyType.crypto);
      expect(result.code, 'BTC');
    });

    test('should return a JSON map containing the proper data', () {
      const model = CurrencyModel(
        id: id,
        code: code,
        name: name,
        type: type,
        icon: icon,
      );

      final result = model.toJson();

      expect(result, jsonMap);
    });

    test('copyWith should return a new instance with updated values', () {
      const model = CurrencyModel(
        id: id,
        code: code,
        name: name,
        type: type,
        icon: icon,
      );

      final updatedModel = model.copyWith(
        code: 'EUR',
        name: 'Euro',
      );

      expect(updatedModel.code, 'EUR');
      expect(updatedModel.name, 'Euro');
      expect(updatedModel.id, id);
      expect(updatedModel.type, type);
      expect(updatedModel.icon, icon);
    });

    test('copyWith should handle null icon', () {
      const model = CurrencyModel(
        id: id,
        code: code,
        name: name,
        type: type,
      );

      final updatedModel = model.copyWith(icon: 'new_icon.png');

      expect(updatedModel.icon, 'new_icon.png');
    });

    test('should handle JSON without icon', () {
      final jsonWithoutIcon = {
        'id': '3',
        'code': 'ETH',
        'name': 'Ethereum',
        'type': 'crypto',
        'icon': null,
      };

      final result = CurrencyModel.fromJson(jsonWithoutIcon);

      expect(result.icon, isNull);
    });
  });
}

