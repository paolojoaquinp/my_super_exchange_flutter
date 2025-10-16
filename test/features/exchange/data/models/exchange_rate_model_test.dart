import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_super_exchange_flutter/features/exchange/data/models/exchange_rate_model.dart';

void main() {
  group('ExchangeRateModel', () {
    final exchangeRate = Decimal.parse('3.75');
    final fromAmount = Decimal.parse('100');
    final toAmount = Decimal.parse('375');
    final platformFee = Decimal.parse('0.5');
    const fromCurrencyId = 'PEN';
    const toCurrencyId = 'USDT';

    final jsonMap = {
      'exchangeRate': '3.75',
      'fromAmount': '100',
      'toAmount': '375',
      'platformFee': '0.5',
      'fromCurrencyId': fromCurrencyId,
      'toCurrencyId': toCurrencyId,
    };

    test('should return a valid model from JSON', () {
      final result = ExchangeRateModel.fromJson(jsonMap);

      expect(result, isA<ExchangeRateModel>());
      expect(result.exchangeRate, exchangeRate);
      expect(result.fromAmount, fromAmount);
      expect(result.toAmount, toAmount);
      expect(result.platformFee, platformFee);
      expect(result.fromCurrencyId, fromCurrencyId);
      expect(result.toCurrencyId, toCurrencyId);
    });

    test('should return a JSON map containing the proper data', () {
      final model = ExchangeRateModel(
        exchangeRate: exchangeRate,
        fromAmount: fromAmount,
        toAmount: toAmount,
        platformFee: platformFee,
        fromCurrencyId: fromCurrencyId,
        toCurrencyId: toCurrencyId,
      );

      final result = model.toJson();

      expect(result, jsonMap);
    });

    test('copyWith should return a new instance with updated values', () {
      final model = ExchangeRateModel(
        exchangeRate: exchangeRate,
        fromAmount: fromAmount,
        toAmount: toAmount,
        platformFee: platformFee,
        fromCurrencyId: fromCurrencyId,
        toCurrencyId: toCurrencyId,
      );

      final updatedModel = model.copyWith(
        fromAmount: Decimal.parse('200'),
        toAmount: Decimal.parse('750'),
      );

      expect(updatedModel.fromAmount, Decimal.parse('200'));
      expect(updatedModel.toAmount, Decimal.parse('750'));
      expect(updatedModel.exchangeRate, exchangeRate);
      expect(updatedModel.platformFee, platformFee);
    });

    test('fromApiResponse should calculate correctly for CRYPTO to FIAT (type 0) with FROM amount', () {
      final apiData = {
        'fiatToCryptoExchangeRate': '50000',
      };

      final result = ExchangeRateModel.fromApiResponse(
        apiData: apiData,
        amount: Decimal.parse('0.5'),
        amountCurrencyId: 'BTC',
        fromCurrencyId: 'BTC',
        toCurrencyId: 'USD',
        type: 0,
      );

      expect(result.fromAmount, Decimal.parse('0.5'));
      expect(result.toAmount, Decimal.parse('25000')); // 0.5 * 50000
      expect(result.exchangeRate, Decimal.parse('50000'));
      expect(result.platformFee, Decimal.parse('0.0025')); // 0.5% of 0.5
    });

    test('fromApiResponse should calculate correctly for CRYPTO to FIAT (type 0) with TO amount', () {
      final apiData = {
        'fiatToCryptoExchangeRate': '50000',
      };

      final result = ExchangeRateModel.fromApiResponse(
        apiData: apiData,
        amount: Decimal.parse('25000'),
        amountCurrencyId: 'USD',
        fromCurrencyId: 'BTC',
        toCurrencyId: 'USD',
        type: 0,
      );

      expect(result.toAmount, Decimal.parse('25000'));
      expect(result.fromAmount, Decimal.parse('0.5')); // 25000 / 50000
      expect(result.exchangeRate, Decimal.parse('50000'));
    });

    test('fromApiResponse should calculate correctly for FIAT to CRYPTO (type 1) with FROM amount', () {
      final apiData = {
        'fiatToCryptoExchangeRate': '50000',
      };

      final result = ExchangeRateModel.fromApiResponse(
        apiData: apiData,
        amount: Decimal.parse('25000'),
        amountCurrencyId: 'USD',
        fromCurrencyId: 'USD',
        toCurrencyId: 'BTC',
        type: 1,
      );

      expect(result.fromAmount, Decimal.parse('25000'));
      expect(result.toAmount, Decimal.parse('0.5')); // 25000 / 50000
      expect(result.exchangeRate, Decimal.parse('50000'));
      expect(result.platformFee, Decimal.parse('125')); // 0.5% of 25000
    });

    test('fromApiResponse should calculate correctly for FIAT to CRYPTO (type 1) with TO amount', () {
      final apiData = {
        'fiatToCryptoExchangeRate': '50000',
      };

      final result = ExchangeRateModel.fromApiResponse(
        apiData: apiData,
        amount: Decimal.parse('0.5'),
        amountCurrencyId: 'BTC',
        fromCurrencyId: 'USD',
        toCurrencyId: 'BTC',
        type: 1,
      );

      expect(result.toAmount, Decimal.parse('0.5'));
      expect(result.fromAmount, Decimal.parse('25000')); // 0.5 * 50000
      expect(result.exchangeRate, Decimal.parse('50000'));
    });

    test('fromApiResponse should throw exception when exchangeRate is null', () {
      final apiData = <String, dynamic>{};

      expect(
        () => ExchangeRateModel.fromApiResponse(
          apiData: apiData,
          amount: Decimal.parse('100'),
          amountCurrencyId: 'USD',
          fromCurrencyId: 'USD',
          toCurrencyId: 'BTC',
          type: 1,
        ),
        throwsException,
      );
    });
  });
}

