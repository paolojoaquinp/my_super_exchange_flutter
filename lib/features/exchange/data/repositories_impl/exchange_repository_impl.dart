import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
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
    required Decimal amount,
    required String amountCurrencyId,
  }) async {
    try {
      final response = await _apiDataSource.getOrderbookRecommendations(
        type: type,
        cryptoCurrencyId: cryptoCurrencyId,
        fiatCurrencyId: fiatCurrencyId,
        amount: amount.toDouble(), // Convertir a double para el API
        amountCurrencyId: amountCurrencyId,
      );

      // Validar la estructura del response antes de hacer cualquier cast
      final dataRaw = response['data'];
      
      // Si data es null o no es un Map, retornar error amigable
      if (dataRaw == null || dataRaw is! Map<String, dynamic>) {
        return const Err('Monto no disponible. Por favor, ingresa una cantidad menor.');
      }
      
      final data = dataRaw;
      
      // Validar que exista byPrice antes de intentar accederlo
      final byPriceRaw = data['byPrice'];
      
      if (byPriceRaw == null || byPriceRaw is! Map<String, dynamic>) {
        return const Err('Monto no disponible. Por favor, ingresa una cantidad menor.');
      }
      
      final byPrice = byPriceRaw;

      // 🔍 LOG: Ver qué devuelve el API
      debugPrint('📡 API Response - byPrice:');
      debugPrint(byPrice.toString());
      debugPrint('fiatToCryptoExchangeRate: ${byPrice['fiatToCryptoExchangeRate']}');

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
    } on FormatException catch (_) {
      return const Err('Error al procesar la tasa de cambio. Intenta nuevamente.');
    } on TypeError catch (_) {
      return const Err('Monto no disponible. Por favor, ingresa una cantidad menor.');
    } catch (e) {
      // Para cualquier otro error, retornar mensaje genérico
      return const Err('No se pudo obtener la tasa de cambio. Intenta nuevamente.');
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

