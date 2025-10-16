part of 'exchange_bloc.dart';

sealed class ExchangeState extends Equatable {
  const ExchangeState();
  
  @override
  List<Object?> get props => [];
}

final class ExchangeInitial extends ExchangeState {}

final class ExchangeLoading extends ExchangeState {}

final class ExchangeLoaded extends ExchangeState {
  final List<CurrencyModel> availableCurrencies;
  final CurrencyModel? fromCurrency;
  final CurrencyModel? toCurrency;
  final Decimal fromAmount;
  final Decimal toAmount;
  final Decimal platformFee;
  final Decimal? exchangeRate;
  final bool isCalculating;
  final bool isExecutingExchange;

  ExchangeLoaded({
    required this.availableCurrencies,
    this.fromCurrency,
    this.toCurrency,
    Decimal? fromAmount,
    Decimal? toAmount,
    Decimal? platformFee,
    this.exchangeRate,
    this.isCalculating = false,
    this.isExecutingExchange = false,
  })  : fromAmount = fromAmount ?? Decimal.zero,
        toAmount = toAmount ?? Decimal.zero,
        platformFee = platformFee ?? Decimal.zero;

  ExchangeLoaded copyWith({
    List<CurrencyModel>? availableCurrencies,
    CurrencyModel? fromCurrency,
    CurrencyModel? toCurrency,
    Decimal? fromAmount,
    Decimal? toAmount,
    Decimal? platformFee,
    Decimal? exchangeRate,
    bool? isCalculating,
    bool? isExecutingExchange,
  }) {
    return ExchangeLoaded(
      availableCurrencies: availableCurrencies ?? this.availableCurrencies,
      fromCurrency: fromCurrency ?? this.fromCurrency,
      toCurrency: toCurrency ?? this.toCurrency,
      fromAmount: fromAmount ?? this.fromAmount,
      toAmount: toAmount ?? this.toAmount,
      platformFee: platformFee ?? this.platformFee,
      exchangeRate: exchangeRate ?? this.exchangeRate,
      isCalculating: isCalculating ?? this.isCalculating,
      isExecutingExchange: isExecutingExchange ?? this.isExecutingExchange,
    );
  }

  @override
  List<Object?> get props => [
        availableCurrencies,
        fromCurrency,
        toCurrency,
        fromAmount,
        toAmount,
        platformFee,
        exchangeRate,
        isCalculating,
        isExecutingExchange,
      ];
}

final class ExchangeError extends ExchangeState {
  final String message;

  const ExchangeError(this.message);

  @override
  List<Object> get props => [message];
}

final class ExchangeSuccess extends ExchangeState {
  final String message;

  const ExchangeSuccess(this.message);

  @override
  List<Object> get props => [message];
}
