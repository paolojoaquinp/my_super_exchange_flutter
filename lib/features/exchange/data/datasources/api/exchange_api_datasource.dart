import 'package:dio/dio.dart';

class ExchangeApiDataSource {
  final Dio _dio;
  static const String _baseUrl = 'https://74j6q7lg6a.execute-api.eu-west-1.amazonaws.com/stage';

  ExchangeApiDataSource({Dio? dio}) : _dio = dio ?? Dio(BaseOptions(
    baseUrl: _baseUrl,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ));

  /// Obtiene las recomendaciones del orderbook
  /// [type] 0 -> Cambio de CRYPTO a FIAT, 1 -> Cambio de FIAT a CRYPTO
  /// [cryptoCurrencyId] ID de la moneda crypto
  /// [fiatCurrencyId] ID de la moneda fiat
  /// [amount] Cantidad a cambiar
  /// [amountCurrencyId] ID de la moneda del input
  Future<Map<String, dynamic>> getOrderbookRecommendations({
    required int type,
    required String cryptoCurrencyId,
    required String fiatCurrencyId,
    required double amount,
    required String amountCurrencyId,
  }) async {
    try {
      final response = await _dio.get(
        '/orderbook/public/recommendations',
        queryParameters: {
          'type': type,
          'cryptoCurrencyId': cryptoCurrencyId,
          'fiatCurrencyId': fiatCurrencyId,
          'amount': amount.toString(),
          'amountCurrencyId': amountCurrencyId,
        },
      );

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: 'Error: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw Exception('Error al obtener las recomendaciones: ${e.message}');
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }
}

