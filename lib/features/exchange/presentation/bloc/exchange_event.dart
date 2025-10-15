part of 'exchange_bloc.dart';

sealed class ExchangeEvent extends Equatable {
  const ExchangeEvent();

  @override
  List<Object> get props => [];
}

/// Evento para inicializar las monedas disponibles
class LoadAvailableCurrencies extends ExchangeEvent {
  const LoadAvailableCurrencies();
}

/// Evento para seleccionar la moneda origen
class SelectFromCurrency extends ExchangeEvent {
  final CurrencyModel currency;

  const SelectFromCurrency(this.currency);

  @override
  List<Object> get props => [currency];
}

/// Evento para seleccionar la moneda destino
class SelectToCurrency extends ExchangeEvent {
  final CurrencyModel currency;

  const SelectToCurrency(this.currency);

  @override
  List<Object> get props => [currency];
}

/// Evento para cambiar el monto origen
class ChangeFromAmount extends ExchangeEvent {
  final double amount;

  const ChangeFromAmount(this.amount);

  @override
  List<Object> get props => [amount];
}

/// Evento para cambiar el monto destino
class ChangeToAmount extends ExchangeEvent {
  final double amount;

  const ChangeToAmount(this.amount);

  @override
  List<Object> get props => [amount];
}

/// Evento para calcular la tasa de cambio
class CalculateExchangeRate extends ExchangeEvent {
  final double amount;
  final bool isFromAmount;

  const CalculateExchangeRate({
    required this.amount,
    required this.isFromAmount,
  });

  @override
  List<Object> get props => [amount, isFromAmount];
}

/// Evento para intercambiar las monedas
class SwapCurrencies extends ExchangeEvent {
  const SwapCurrencies();
}

/// Evento para realizar el intercambio
class ExecuteExchange extends ExchangeEvent {
  const ExecuteExchange();
}
