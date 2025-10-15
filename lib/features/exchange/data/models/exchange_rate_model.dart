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
    final exchangeRate = (apiData['fiatToCryptoExchangeRate'] as num).toDouble();
    
    double fromAmount;
    double toAmount;
    
    // type: 0 -> CRYPTO a FIAT, 1 -> FIAT a CRYPTO
    if (type == 0) {
      // De crypto a fiat
      if (amountCurrencyId == fromCurrencyId) {
        // La cantidad está en crypto
        fromAmount = amount;
        toAmount = amount * exchangeRate;
      } else {
        // La cantidad está en fiat
        toAmount = amount;
        fromAmount = amount / exchangeRate;
      }
    } else {
      // De fiat a crypto
      if (amountCurrencyId == fromCurrencyId) {
        // La cantidad está en fiat
        fromAmount = amount;
        toAmount = amount / exchangeRate;
      } else {
        // La cantidad está en crypto
        toAmount = amount;
        fromAmount = amount * exchangeRate;
      }
    }

    // Calcular el fee de plataforma (ejemplo: 0.5% del monto origen)
    final platformFee = fromAmount * 0.005;

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

