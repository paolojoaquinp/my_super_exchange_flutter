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
      'exchangeRate': exchangeRate,
      'fromAmount': fromAmount,
      'toAmount': toAmount,
      'platformFee': platformFee,
      'fromCurrencyId': fromCurrencyId,
      'toCurrencyId': toCurrencyId,
    };
  }

  factory ExchangeRateModel.fromJson(Map<String, dynamic> json) {
    return ExchangeRateModel(
      exchangeRate: (json['exchangeRate'] as num).toDouble(),
      fromAmount: (json['fromAmount'] as num).toDouble(),
      toAmount: (json['toAmount'] as num).toDouble(),
      platformFee: (json['platformFee'] as num).toDouble(),
      fromCurrencyId: json['fromCurrencyId'] as String,
      toCurrencyId: json['toCurrencyId'] as String,
    );
  }

  factory ExchangeRateModel.fromApiResponse({
    required Map<String, dynamic> apiData,
    required double amount,
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
    final exchangeRate = exchangeRateValue is String 
        ? double.parse(exchangeRateValue) 
        : (exchangeRateValue as num).toDouble();
    
    // 🔍 LOG: Ver los parámetros de entrada
    debugPrint('═══════════════════════════════════');
    debugPrint('📊 CÁLCULO DE EXCHANGE RATE:');
    debugPrint('Type: $type (${type == 0 ? "CRYPTO→FIAT" : "FIAT→CRYPTO"})');
    debugPrint('Exchange Rate: $exchangeRate');
    debugPrint('Amount: $amount');
    debugPrint('Amount Currency: $amountCurrencyId');
    debugPrint('From Currency: $fromCurrencyId');
    debugPrint('To Currency: $toCurrencyId');
    
    double fromAmount;
    double toAmount;
    
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
        fromAmount = amount / exchangeRate;
        debugPrint('✅ Caso: CRYPTO→FIAT, escribiendo en TO');
        debugPrint('   Cálculo: $toAmount $toCurrencyId ÷ $exchangeRate = $fromAmount $fromCurrencyId');
      }
    } else {
      // De fiat a crypto
      if (amountCurrencyId == fromCurrencyId) {
        // La cantidad está en fiat
        fromAmount = amount;
        toAmount = amount / exchangeRate;
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
    final platformFee = fromAmount * 0.005;
    
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
    double? exchangeRate,
    double? fromAmount,
    double? toAmount,
    double? platformFee,
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

