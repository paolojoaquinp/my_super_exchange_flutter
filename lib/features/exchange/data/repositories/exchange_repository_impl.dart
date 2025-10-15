import 'package:my_super_exchange_flutter/features/exchange/data/datasources/api/exchange_api_datasource.dart';
import 'package:my_super_exchange_flutter/features/exchange/data/models/currency_model.dart';
import 'package:my_super_exchange_flutter/features/exchange/data/models/exchange_rate_model.dart';
import 'package:my_super_exchange_flutter/features/exchange/domain/entities/currency_entity.dart';
import 'package:my_super_exchange_flutter/features/exchange/domain/repositories/exchange_repository.dart';
import 'package:oxidized/oxidized.dart';

class ExchangeRepositoryImpl implements ExchangeRepository {
  final ExchangeApiDataSource _apiDataSource;

  ExchangeRepositoryImpl({
    ExchangeApiDataSource? apiDataSource,
  }) : _apiDataSource = apiDataSource ?? ExchangeApiDataSource();

  @override
  Future<Result<ExchangeRateModel, String>> getExchangeRate({
    required int type,
    required String cryptoCurrencyId,
    required String fiatCurrencyId,
    required double amount,
    required String amountCurrencyId,
  }) async {
    try {
      final response = await _apiDataSource.getOrderbookRecommendations(
        type: type,
        cryptoCurrencyId: cryptoCurrencyId,
        fiatCurrencyId: fiatCurrencyId,
        amount: amount,
        amountCurrencyId: amountCurrencyId,
      );

      // Extraer data.byPrice.fiatToCryptoExchangeRate
      final data = response['data'] as Map<String, dynamic>;
      final byPrice = data['byPrice'] as Map<String, dynamic>;

      // Determinar las monedas origen y destino basado en el tipo
      final fromCurrencyId = type == 0 ? cryptoCurrencyId : fiatCurrencyId;
      final toCurrencyId = type == 0 ? fiatCurrencyId : cryptoCurrencyId;

      final exchangeRateModel = ExchangeRateModel.fromApiResponse(
        apiData: byPrice,
        amount: amount,
        amountCurrencyId: amountCurrencyId,
        fromCurrencyId: fromCurrencyId,
        toCurrencyId: toCurrencyId,
        type: type,
      );

      return Ok(exchangeRateModel);
    } catch (e) {
      return Err('Error al obtener la tasa de cambio: $e');
    }
  }

  @override
  Future<Result<List<CurrencyModel>, String>> getAvailableCurrencies() async {
    try {
      // Lista hardcodeada basada en los assets disponibles
      final currencies = [
        const CurrencyModel(
          id: 'TATUM-TRON-USDT',
          code: 'USDT',
          name: 'Tether',
          type: CurrencyType.crypto,
          icon: 'assets/cripto_currencies/TATUM-TRON-USDT.png',
        ),
        const CurrencyModel(
          id: 'BRL',
          code: 'BRL',
          name: 'Real Brasileño',
          type: CurrencyType.fiat,
          icon: 'assets/fiat_currencies/BRL.png',
        ),
        const CurrencyModel(
          id: 'COP',
          code: 'COP',
          name: 'Peso Colombiano',
          type: CurrencyType.fiat,
          icon: 'assets/fiat_currencies/COP.png',
        ),
        const CurrencyModel(
          id: 'PEN',
          code: 'PEN',
          name: 'Sol Peruano',
          type: CurrencyType.fiat,
          icon: 'assets/fiat_currencies/PEN.png',
        ),
        const CurrencyModel(
          id: 'VES',
          code: 'VES',
          name: 'Bolívar Venezolano',
          type: CurrencyType.fiat,
          icon: 'assets/fiat_currencies/VES.png',
        ),
      ];

      return Ok(currencies);
    } catch (e) {
      return Err('Error al obtener las monedas disponibles: $e');
    }
  }
}

