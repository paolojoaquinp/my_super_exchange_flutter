import 'package:bloc_test/bloc_test.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_super_exchange_flutter/features/exchange/data/models/currency_model.dart';
import 'package:my_super_exchange_flutter/features/exchange/data/models/exchange_rate_model.dart';
import 'package:my_super_exchange_flutter/features/exchange/domain/entities/currency_entity.dart';
import 'package:my_super_exchange_flutter/features/exchange/domain/repositories/exchange_repository.dart';
import 'package:my_super_exchange_flutter/features/exchange/presentation/bloc/exchange_bloc.dart';
import 'package:oxidized/oxidized.dart';

class MockExchangeRepository extends Mock implements ExchangeRepository {}

void main() {
  late ExchangeRepository mockRepository;
  late ExchangeBloc exchangeBloc;

  final mockCurrencies = [
    const CurrencyModel(
      id: 'PEN',
      code: 'PEN',
      name: 'Peruvian Sol',
      type: CurrencyType.fiat,
      icon: 'pen_icon.png',
    ),
    const CurrencyModel(
      id: 'USD',
      code: 'USD',
      name: 'US Dollar',
      type: CurrencyType.fiat,
      icon: 'usd_icon.png',
    ),
    const CurrencyModel(
      id: 'USDT',
      code: 'USDT',
      name: 'Tether',
      type: CurrencyType.crypto,
      icon: 'usdt_icon.png',
    ),
    const CurrencyModel(
      id: 'BTC',
      code: 'BTC',
      name: 'Bitcoin',
      type: CurrencyType.crypto,
      icon: 'btc_icon.png',
    ),
  ];

  final mockExchangeRate = ExchangeRateModel(
    exchangeRate: Decimal.parse('3.75'),
    fromAmount: Decimal.parse('100'),
    toAmount: Decimal.parse('375'),
    platformFee: Decimal.parse('0.5'),
    fromCurrencyId: 'PEN',
    toCurrencyId: 'USDT',
  );

  setUpAll(() {
    registerFallbackValue(Decimal.zero);
  });

  setUp(() {
    mockRepository = MockExchangeRepository();
    exchangeBloc = ExchangeBloc(repository: mockRepository);
  });

  tearDown(() {
    exchangeBloc.close();
  });

  group('ExchangeBloc', () {
    test('initial state is ExchangeInitial', () {
      expect(exchangeBloc.state, isA<ExchangeInitial>());
    });

    blocTest<ExchangeBloc, ExchangeState>(
      'emits [ExchangeLoading, ExchangeLoaded] when LoadAvailableCurrencies succeeds',
      build: () {
        when(() => mockRepository.getAvailableCurrencies()).thenAnswer(
          (_) async => Result.ok(mockCurrencies),
        );
        return exchangeBloc;
      },
      act: (bloc) => bloc.add(const LoadAvailableCurrencies()),
      expect: () => [
        isA<ExchangeLoading>(),
        isA<ExchangeLoaded>()
            .having((state) => state.availableCurrencies.length, 'currencies length', 4)
            .having((state) => state.fromCurrency?.type, 'from currency type', CurrencyType.fiat)
            .having((state) => state.toCurrency?.type, 'to currency type', CurrencyType.crypto),
      ],
      verify: (_) {
        verify(() => mockRepository.getAvailableCurrencies()).called(1);
      },
    );

    blocTest<ExchangeBloc, ExchangeState>(
      'emits [ExchangeLoading, ExchangeError] when LoadAvailableCurrencies fails',
      build: () {
        when(() => mockRepository.getAvailableCurrencies()).thenAnswer(
          (_) async => const Result.err('Error al cargar monedas'),
        );
        return exchangeBloc;
      },
      act: (bloc) => bloc.add(const LoadAvailableCurrencies()),
      expect: () => [
        isA<ExchangeLoading>(),
        isA<ExchangeError>().having((state) => state.message, 'error message', 'Error al cargar monedas'),
      ],
    );

    blocTest<ExchangeBloc, ExchangeState>(
      'emits updated state when SelectFromCurrency is added',
      build: () {
        when(() => mockRepository.getAvailableCurrencies()).thenAnswer(
          (_) async => Result.ok(mockCurrencies),
        );
        return exchangeBloc;
      },
      seed: () => ExchangeLoaded(
        availableCurrencies: mockCurrencies,
        fromCurrency: mockCurrencies[0],
        toCurrency: mockCurrencies[2],
      ),
      act: (bloc) => bloc.add(SelectFromCurrency(mockCurrencies[1])),
      expect: () => [
        isA<ExchangeLoaded>().having(
          (state) => state.fromCurrency?.code,
          'from currency code',
          'USD',
        ),
      ],
    );

    blocTest<ExchangeBloc, ExchangeState>(
      'emits updated state when SelectToCurrency is added',
      build: () {
        when(() => mockRepository.getAvailableCurrencies()).thenAnswer(
          (_) async => Result.ok(mockCurrencies),
        );
        return exchangeBloc;
      },
      seed: () => ExchangeLoaded(
        availableCurrencies: mockCurrencies,
        fromCurrency: mockCurrencies[0],
        toCurrency: mockCurrencies[2],
      ),
      act: (bloc) => bloc.add(SelectToCurrency(mockCurrencies[3])),
      expect: () => [
        isA<ExchangeLoaded>().having(
          (state) => state.toCurrency?.code,
          'to currency code',
          'BTC',
        ),
      ],
    );

    blocTest<ExchangeBloc, ExchangeState>(
      'emits updated state with zero amounts when ChangeFromAmount with zero',
      build: () => exchangeBloc,
      seed: () => ExchangeLoaded(
        availableCurrencies: mockCurrencies,
        fromCurrency: mockCurrencies[0],
        toCurrency: mockCurrencies[2],
        fromAmount: Decimal.parse('100'),
      ),
      act: (bloc) => bloc.add(ChangeFromAmount(Decimal.zero)),
      expect: () => [
        isA<ExchangeLoaded>()
            .having((state) => state.fromAmount, 'from amount', Decimal.zero)
            .having((state) => state.toAmount, 'to amount', Decimal.zero)
            .having((state) => state.platformFee, 'platform fee', Decimal.zero),
      ],
    );

    blocTest<ExchangeBloc, ExchangeState>(
      'calculates exchange rate when ChangeFromAmount with valid amount',
      build: () {
        when(() => mockRepository.getExchangeRate(
              type: any(named: 'type'),
              cryptoCurrencyId: any(named: 'cryptoCurrencyId'),
              fiatCurrencyId: any(named: 'fiatCurrencyId'),
              amount: any(named: 'amount'),
              amountCurrencyId: any(named: 'amountCurrencyId'),
            )).thenAnswer((_) async => Result.ok(mockExchangeRate));
        return exchangeBloc;
      },
      seed: () => ExchangeLoaded(
        availableCurrencies: mockCurrencies,
        fromCurrency: mockCurrencies[0], // PEN (fiat)
        toCurrency: mockCurrencies[2], // USDT (crypto)
      ),
      act: (bloc) => bloc.add(ChangeFromAmount(Decimal.parse('100'))),
      wait: const Duration(milliseconds: 1100), // Wait for debounce
      expect: () => [
        isA<ExchangeLoaded>().having(
          (state) => state.fromAmount,
          'from amount',
          Decimal.parse('100'),
        ),
        isA<ExchangeLoaded>().having(
          (state) => state.isCalculating,
          'is calculating',
          true,
        ),
        isA<ExchangeLoaded>()
            .having((state) => state.fromAmount, 'from amount', Decimal.parse('100'))
            .having((state) => state.toAmount, 'to amount', Decimal.parse('375'))
            .having((state) => state.isCalculating, 'is calculating', false),
      ],
    );

    blocTest<ExchangeBloc, ExchangeState>(
      'emits error when calculating exchange rate fails',
      build: () {
        when(() => mockRepository.getExchangeRate(
              type: any(named: 'type'),
              cryptoCurrencyId: any(named: 'cryptoCurrencyId'),
              fiatCurrencyId: any(named: 'fiatCurrencyId'),
              amount: any(named: 'amount'),
              amountCurrencyId: any(named: 'amountCurrencyId'),
            )).thenAnswer((_) async => const Result.err('Error en el cálculo'));
        return exchangeBloc;
      },
      seed: () => ExchangeLoaded(
        availableCurrencies: mockCurrencies,
        fromCurrency: mockCurrencies[0],
        toCurrency: mockCurrencies[2],
      ),
      act: (bloc) => bloc.add(ChangeFromAmount(Decimal.parse('100'))),
      wait: const Duration(milliseconds: 1100),
      expect: () => [
        isA<ExchangeLoaded>().having(
          (state) => state.fromAmount,
          'from amount',
          Decimal.parse('100'),
        ),
        isA<ExchangeLoaded>().having(
          (state) => state.isCalculating,
          'is calculating',
          true,
        ),
        isA<ExchangeLoaded>().having(
          (state) => state.isCalculating,
          'is calculating',
          false,
        ),
        isA<ExchangeError>().having(
          (state) => state.message,
          'error message',
          'Error en el cálculo',
        ),
        isA<ExchangeLoaded>(),
      ],
    );

    blocTest<ExchangeBloc, ExchangeState>(
      'swaps currencies when SwapCurrencies is added',
      build: () {
        when(() => mockRepository.getExchangeRate(
              type: any(named: 'type'),
              cryptoCurrencyId: any(named: 'cryptoCurrencyId'),
              fiatCurrencyId: any(named: 'fiatCurrencyId'),
              amount: any(named: 'amount'),
              amountCurrencyId: any(named: 'amountCurrencyId'),
            )).thenAnswer((_) async => Result.ok(mockExchangeRate));
        return exchangeBloc;
      },
      seed: () => ExchangeLoaded(
        availableCurrencies: mockCurrencies,
        fromCurrency: mockCurrencies[0], // PEN
        toCurrency: mockCurrencies[2], // USDT
        fromAmount: Decimal.parse('100'),
        toAmount: Decimal.parse('375'),
      ),
      act: (bloc) => bloc.add(const SwapCurrencies()),
      wait: const Duration(milliseconds: 1100),
      expect: () => [
        isA<ExchangeLoaded>()
            .having((state) => state.fromCurrency?.code, 'from currency', 'USDT')
            .having((state) => state.toCurrency?.code, 'to currency', 'PEN')
            .having((state) => state.fromAmount, 'from amount', Decimal.parse('375'))
            .having((state) => state.toAmount, 'to amount', Decimal.parse('100')),
        isA<ExchangeLoaded>().having(
          (state) => state.isCalculating,
          'is calculating',
          true,
        ),
        isA<ExchangeLoaded>().having(
          (state) => state.isCalculating,
          'is calculating',
          false,
        ),
      ],
    );

    blocTest<ExchangeBloc, ExchangeState>(
      'executes exchange successfully',
      build: () => exchangeBloc,
      seed: () => ExchangeLoaded(
        availableCurrencies: mockCurrencies,
        fromCurrency: mockCurrencies[0],
        toCurrency: mockCurrencies[2],
        fromAmount: Decimal.parse('100'),
        toAmount: Decimal.parse('375'),
      ),
      act: (bloc) => bloc.add(const ExecuteExchange()),
      wait: const Duration(seconds: 3),
      expect: () => [
        isA<ExchangeLoaded>().having(
          (state) => state.isExecutingExchange,
          'is executing',
          true,
        ),
        isA<ExchangeLoaded>().having(
          (state) => state.isExecutingExchange,
          'is executing',
          false,
        ),
        isA<ExchangeSuccess>().having(
          (state) => state.message,
          'success message',
          '¡Intercambio realizado con éxito!',
        ),
        isA<ExchangeLoaded>(),
      ],
    );

    blocTest<ExchangeBloc, ExchangeState>(
      'emits error when executing exchange with zero amounts',
      build: () => exchangeBloc,
      seed: () => ExchangeLoaded(
        availableCurrencies: mockCurrencies,
        fromCurrency: mockCurrencies[0],
        toCurrency: mockCurrencies[2],
      ),
      act: (bloc) => bloc.add(const ExecuteExchange()),
      expect: () => [
        isA<ExchangeError>().having(
          (state) => state.message,
          'error message',
          'Ingrese un monto válido',
        ),
        isA<ExchangeLoaded>(),
      ],
    );
  });
}

