import 'package:my_super_exchange_flutter/features/exchange/data/models/currency_model.dart';
import 'package:my_super_exchange_flutter/features/exchange/data/models/exchange_rate_model.dart';
import 'package:oxidized/oxidized.dart';

abstract class ExchangeRepository {
  /// Obtiene la tasa de cambio y calcula los montos
  /// [type] 0 -> Cambio de CRYPTO a FIAT, 1 -> Cambio de FIAT a CRYPTO
  /// [cryptoCurrencyId] ID de la moneda crypto
  /// [fiatCurrencyId] ID de la moneda fiat
  /// [amount] Cantidad a cambiar
  /// [amountCurrencyId] ID de la moneda del input
  Future<Result<ExchangeRateModel, String>> getExchangeRate({
    required int type,
    required String cryptoCurrencyId,
    required String fiatCurrencyId,
    required double amount,
    required String amountCurrencyId,
  });

  /// Obtiene las monedas disponibles
  Future<Result<List<CurrencyModel>, String>> getAvailableCurrencies();
}

