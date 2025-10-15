class ExchangeRateEntity {
  final double exchangeRate;
  final double fromAmount;
  final double toAmount;
  final double platformFee;
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

