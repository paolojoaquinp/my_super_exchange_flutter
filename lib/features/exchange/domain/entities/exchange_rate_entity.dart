import 'package:decimal/decimal.dart';

class ExchangeRateEntity {
  final Decimal exchangeRate;
  final Decimal fromAmount;
  final Decimal toAmount;
  final Decimal platformFee;
  final String fromCurrencyId;
  final String toCurrencyId;

  const ExchangeRateEntity({
    required this.exchangeRate,
    required this.fromAmount,
    required this.toAmount,
    required this.platformFee,
    required this.fromCurrencyId,
    required this.toCurrencyId,
  });
}

