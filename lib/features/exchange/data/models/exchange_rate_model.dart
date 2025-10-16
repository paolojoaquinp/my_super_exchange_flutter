import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:my_super_exchange_flutter/features/exchange/domain/entities/exchange_rate_entity.dart';

class ExchangeRateModel extends ExchangeRateEntity {
  const ExchangeRateModel({
    required super.exchangeRate,
    required super.fromAmount,
    required super.toAmount,
    required super.platformFee,
    required super.fromCurrencyId,
    required super.toCurrencyId,
  });

  Map<String, dynamic> toJson() {
    return {
      'exchangeRate': exchangeRate.toString(),
      'fromAmount': fromAmount.toString(),
      'toAmount': toAmount.toString(),
      'platformFee': platformFee.toString(),
      'fromCurrencyId': fromCurrencyId,
      'toCurrencyId': toCurrencyId,
    };
  }

  factory ExchangeRateModel.fromJson(Map<String, dynamic> json) {
    return ExchangeRateModel(
      exchangeRate: Decimal.parse(json['exchangeRate'].toString()),
      fromAmount: Decimal.parse(json['fromAmount'].toString()),
      toAmount: Decimal.parse(json['toAmount'].toString()),
      platformFee: Decimal.parse(json['platformFee'].toString()),
      fromCurrencyId: json['fromCurrencyId'] as String,
      toCurrencyId: json['toCurrencyId'] as String,
    );
  }

  factory ExchangeRateModel.fromApiResponse({
    required Map<String, dynamic> apiData,
    required Decimal amount,
    required String amountCurrencyId,
    required String fromCurrencyId,
    required String toCurrencyId,
    required int type,
  }) {
    // Validar que exista el exchangeRate
    final exchangeRateValue = apiData['fiatToCryptoExchangeRate'];
    if (exchangeRateValue == null) {
      throw Exception('El API no devolvió la tasa de cambio (fiatToCryptoExchangeRate es null)');
    }

    // El API puede devolver el exchangeRate como String o como num
    final exchangeRate = Decimal.parse(exchangeRateValue.toString());
    
    // 🔍 LOG: Ver los parámetros de entrada
    debugPrint('═══════════════════════════════════');
    debugPrint('📊 CÁLCULO DE EXCHANGE RATE:');
    debugPrint('Type: $type (${type == 0 ? "CRYPTO→FIAT" : "FIAT→CRYPTO"})');
    debugPrint('Exchange Rate: $exchangeRate');
    debugPrint('Amount: $amount');
    debugPrint('Amount Currency: $amountCurrencyId');
    debugPrint('From Currency: $fromCurrencyId');
    debugPrint('To Currency: $toCurrencyId');
    
    Decimal fromAmount;
    Decimal toAmount;
    
    // type: 0 -> CRYPTO a FIAT, 1 -> FIAT a CRYPTO
    if (type == 0) {
      // De crypto a fiat
      if (amountCurrencyId == fromCurrencyId) {
        // La cantidad está en crypto
        fromAmount = amount;
        toAmount = amount * exchangeRate;
        debugPrint('✅ Caso: CRYPTO→FIAT, escribiendo en FROM');
        debugPrint('   Cálculo: $fromAmount $fromCurrencyId × $exchangeRate = $toAmount $toCurrencyId');
      } else {
        // La cantidad está en fiat
        toAmount = amount;
        fromAmount = (amount / exchangeRate).toDecimal(scaleOnInfinitePrecision: 8);
        debugPrint('✅ Caso: CRYPTO→FIAT, escribiendo en TO');
        debugPrint('   Cálculo: $toAmount $toCurrencyId ÷ $exchangeRate = $fromAmount $fromCurrencyId');
      }
    } else {
      // De fiat a crypto
      if (amountCurrencyId == fromCurrencyId) {
        // La cantidad está en fiat
        fromAmount = amount;
        toAmount = (amount / exchangeRate).toDecimal(scaleOnInfinitePrecision: 8);
        debugPrint('✅ Caso: FIAT→CRYPTO, escribiendo en FROM');
        debugPrint('   Cálculo: $fromAmount $fromCurrencyId ÷ $exchangeRate = $toAmount $toCurrencyId');
      } else {
        // La cantidad está en crypto
        toAmount = amount;
        fromAmount = amount * exchangeRate;
        debugPrint('✅ Caso: FIAT→CRYPTO, escribiendo en TO');
        debugPrint('   Cálculo: $toAmount $toCurrencyId × $exchangeRate = $fromAmount $fromCurrencyId');
      }
    }

    // Calcular el fee de plataforma (ejemplo: 0.5% del monto origen)
    final platformFee = fromAmount * Decimal.parse('0.005',);
    
    debugPrint('💰 Platform Fee: $platformFee (0.5% de $fromAmount)');
    debugPrint('📤 Resultado Final:');
    debugPrint('   FROM: $fromAmount $fromCurrencyId');
    debugPrint('   TO: $toAmount $toCurrencyId');
    debugPrint('═══════════════════════════════════');

    return ExchangeRateModel(
      exchangeRate: exchangeRate,
      fromAmount: fromAmount,
      toAmount: toAmount,
      platformFee: platformFee,
      fromCurrencyId: fromCurrencyId,
      toCurrencyId: toCurrencyId,
    );
  }

  ExchangeRateModel copyWith({
    Decimal? exchangeRate,
    Decimal? fromAmount,
    Decimal? toAmount,
    Decimal? platformFee,
    String? fromCurrencyId,
    String? toCurrencyId,
  }) {
    return ExchangeRateModel(
      exchangeRate: exchangeRate ?? this.exchangeRate,
      fromAmount: fromAmount ?? this.fromAmount,
      toAmount: toAmount ?? this.toAmount,
      platformFee: platformFee ?? this.platformFee,
      fromCurrencyId: fromCurrencyId ?? this.fromCurrencyId,
      toCurrencyId: toCurrencyId ?? this.toCurrencyId,
    );
  }
}

