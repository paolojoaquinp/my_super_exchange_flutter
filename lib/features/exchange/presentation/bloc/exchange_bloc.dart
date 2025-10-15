import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:my_super_exchange_flutter/features/exchange/data/models/currency_model.dart';
import 'package:my_super_exchange_flutter/features/exchange/domain/entities/currency_entity.dart';
import 'package:my_super_exchange_flutter/features/exchange/domain/repositories/exchange_repository.dart';

part 'exchange_event.dart';
part 'exchange_state.dart';

class ExchangeBloc extends Bloc<ExchangeEvent, ExchangeState> {
  final ExchangeRepository _repository;

  ExchangeBloc({required ExchangeRepository repository})
      : _repository = repository,
        super(ExchangeInitial()) {
    on<LoadAvailableCurrencies>(_onLoadAvailableCurrencies);
    on<SelectFromCurrency>(_onSelectFromCurrency);
    on<SelectToCurrency>(_onSelectToCurrency);
    on<ChangeFromAmount>(_onChangeFromAmount);
    on<ChangeToAmount>(_onChangeToAmount);
    on<CalculateExchangeRate>(_onCalculateExchangeRate);
    on<SwapCurrencies>(_onSwapCurrencies);
    on<ExecuteExchange>(_onExecuteExchange);
  }

  Future<void> _onLoadAvailableCurrencies(
    LoadAvailableCurrencies event,
    Emitter<ExchangeState> emit,
  ) async {
    emit(ExchangeLoading());

    final result = await _repository.getAvailableCurrencies();

    result.when(
      ok: (currencies) {
        // Seleccionar monedas por defecto (primera fiat y primera crypto)
        final fiatCurrency = currencies.firstWhere(
          (c) => c.type == CurrencyType.fiat,
          orElse: () => currencies.first,
        );
        final cryptoCurrency = currencies.firstWhere(
          (c) => c.type == CurrencyType.crypto,
          orElse: () => currencies.last,
        );

        emit(ExchangeLoaded(
          availableCurrencies: currencies,
          fromCurrency: fiatCurrency,
          toCurrency: cryptoCurrency,
          fromAmount: 320.0,
        ));

        // Calcular tasa inicial
        add(const CalculateExchangeRate(amount: 320.0, isFromAmount: true));
      },
      err: (error) {
        emit(ExchangeError(error));
      },
    );
  }

  Future<void> _onSelectFromCurrency(
    SelectFromCurrency event,
    Emitter<ExchangeState> emit,
  ) async {
    if (state is ExchangeLoaded) {
      final currentState = state as ExchangeLoaded;
      emit(currentState.copyWith(fromCurrency: event.currency));

      // Recalcular si hay un monto
      if (currentState.fromAmount > 0) {
        add(CalculateExchangeRate(
          amount: currentState.fromAmount,
          isFromAmount: true,
        ));
      }
    }
  }

  Future<void> _onSelectToCurrency(
    SelectToCurrency event,
    Emitter<ExchangeState> emit,
  ) async {
    if (state is ExchangeLoaded) {
      final currentState = state as ExchangeLoaded;
      emit(currentState.copyWith(toCurrency: event.currency));

      // Recalcular si hay un monto
      if (currentState.fromAmount > 0) {
        add(CalculateExchangeRate(
          amount: currentState.fromAmount,
          isFromAmount: true,
        ));
      }
    }
  }

  Future<void> _onChangeFromAmount(
    ChangeFromAmount event,
    Emitter<ExchangeState> emit,
  ) async {
    if (state is ExchangeLoaded) {
      final currentState = state as ExchangeLoaded;
      emit(currentState.copyWith(fromAmount: event.amount));

      if (event.amount > 0) {
        add(CalculateExchangeRate(amount: event.amount, isFromAmount: true));
      } else {
        emit(currentState.copyWith(
          fromAmount: 0.0,
          toAmount: 0.0,
          platformFee: 0.0,
        ));
      }
    }
  }

  Future<void> _onChangeToAmount(
    ChangeToAmount event,
    Emitter<ExchangeState> emit,
  ) async {
    if (state is ExchangeLoaded) {
      final currentState = state as ExchangeLoaded;
      emit(currentState.copyWith(toAmount: event.amount));

      if (event.amount > 0) {
        add(CalculateExchangeRate(amount: event.amount, isFromAmount: false));
      } else {
        emit(currentState.copyWith(
          fromAmount: 0.0,
          toAmount: 0.0,
          platformFee: 0.0,
        ));
      }
    }
  }

  Future<void> _onCalculateExchangeRate(
    CalculateExchangeRate event,
    Emitter<ExchangeState> emit,
  ) async {
    if (state is! ExchangeLoaded) return;

    final currentState = state as ExchangeLoaded;

    if (currentState.fromCurrency == null || currentState.toCurrency == null) {
      return;
    }

    emit(currentState.copyWith(isCalculating: true));

    // Determinar el tipo de conversión y las monedas
    final fromCurrency = currentState.fromCurrency!;
    final toCurrency = currentState.toCurrency!;

    String cryptoCurrencyId;
    String fiatCurrencyId;
    int type;

    if (fromCurrency.type == CurrencyType.crypto &&
        toCurrency.type == CurrencyType.fiat) {
      // Crypto a Fiat
      cryptoCurrencyId = fromCurrency.id;
      fiatCurrencyId = toCurrency.id;
      type = 0;
    } else if (fromCurrency.type == CurrencyType.fiat &&
        toCurrency.type == CurrencyType.crypto) {
      // Fiat a Crypto
      cryptoCurrencyId = toCurrency.id;
      fiatCurrencyId = fromCurrency.id;
      type = 1;
    } else {
      // Conversión no soportada (fiat a fiat o crypto a crypto)
      emit(currentState.copyWith(isCalculating: false));
      emit(const ExchangeError(
          'Conversión no soportada. Debe ser entre FIAT y CRYPTO'));
      return;
    }

    final amountCurrencyId = event.isFromAmount ? fromCurrency.id : toCurrency.id;

    final result = await _repository.getExchangeRate(
      type: type,
      cryptoCurrencyId: cryptoCurrencyId,
      fiatCurrencyId: fiatCurrencyId,
      amount: event.amount,
      amountCurrencyId: amountCurrencyId,
    );

    result.when(
      ok: (exchangeRateModel) {
        emit(currentState.copyWith(
          fromAmount: exchangeRateModel.fromAmount,
          toAmount: exchangeRateModel.toAmount,
          platformFee: exchangeRateModel.platformFee,
          exchangeRate: exchangeRateModel.exchangeRate,
          isCalculating: false,
        ));
      },
      err: (error) {
        emit(currentState.copyWith(isCalculating: false));
        emit(ExchangeError(error));
        // Volver al estado anterior
        emit(currentState);
      },
    );
  }

  Future<void> _onSwapCurrencies(
    SwapCurrencies event,
    Emitter<ExchangeState> emit,
  ) async {
    if (state is ExchangeLoaded) {
      final currentState = state as ExchangeLoaded;
      
      emit(currentState.copyWith(
        fromCurrency: currentState.toCurrency,
        toCurrency: currentState.fromCurrency,
        fromAmount: currentState.toAmount,
        toAmount: currentState.fromAmount,
      ));

      // Recalcular con las monedas intercambiadas
      if (currentState.toAmount > 0) {
        add(CalculateExchangeRate(
          amount: currentState.toAmount,
          isFromAmount: true,
        ));
      }
    }
  }

  Future<void> _onExecuteExchange(
    ExecuteExchange event,
    Emitter<ExchangeState> emit,
  ) async {
    if (state is ExchangeLoaded) {
      final currentState = state as ExchangeLoaded;
      
      if (currentState.fromAmount <= 0 || currentState.toAmount <= 0) {
        emit(const ExchangeError('Ingrese un monto válido'));
        emit(currentState);
        return;
      }

      emit(currentState.copyWith(isExecutingExchange: true));

      await Future.delayed(const Duration(seconds: 2));

      emit(currentState.copyWith(isExecutingExchange: false));

      emit(const ExchangeSuccess('¡Intercambio realizado con éxito!'));
      
      await Future.delayed(const Duration(milliseconds: 500));
      emit(currentState);
    }
  }
}
