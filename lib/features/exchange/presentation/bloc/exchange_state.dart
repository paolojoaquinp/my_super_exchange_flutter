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
  final double fromAmount;
  final double toAmount;
  final double platformFee;
  final double? exchangeRate;
  final bool isCalculating;

  const ExchangeLoaded({
    required this.availableCurrencies,
    this.fromCurrency,
    this.toCurrency,
    this.fromAmount = 0.0,
    this.toAmount = 0.0,
    this.platformFee = 0.0,
    this.exchangeRate,
    this.isCalculating = false,
  });

  ExchangeLoaded copyWith({
    List<CurrencyModel>? availableCurrencies,
    CurrencyModel? fromCurrency,
    CurrencyModel? toCurrency,
    double? fromAmount,
    double? toAmount,
    double? platformFee,
    double? exchangeRate,
    bool? isCalculating,
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
