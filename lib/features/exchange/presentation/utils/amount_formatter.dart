import 'package:decimal/decimal.dart';

class AmountFormatter {
  /// Formatea un monto Decimal a string, removiendo ceros innecesarios
  /// 
  /// Ejemplos:
  /// - Decimal.zero -> ''
  /// - Decimal.fromInt(100) -> '100'
  /// - Decimal.parse('100.50') -> '100.5'
  /// - Decimal.parse('100.123456') -> '100.123456'
  static String format(Decimal amount) {
    if (amount == Decimal.zero) return '';
    
    // Convertir a string y remover ceros innecesarios al final
    String formatted = amount.toString();
    
    // Si tiene punto decimal, remover ceros al final
    if (formatted.contains('.')) {
      formatted = formatted.replaceAll(RegExp(r'0*$'), '');
      // Si solo queda el punto, removerlo también
      formatted = formatted.replaceAll(RegExp(r'\.$'), '');
    }
    
    return formatted;
  }
  
  /// Parsea un string a Decimal de manera segura
  /// 
  /// Retorna Decimal.zero si el string está vacío o no es válido
  static Decimal parse(String value) {
    if (value.isEmpty) return Decimal.zero;
    try {
      return Decimal.parse(value);
    } catch (e) {
      return Decimal.zero;
    }
  }
  
  /// Valida si un string es un número válido
  static bool isValid(String value) {
    if (value.isEmpty) return true; // Vacío es válido (representa 0)
    try {
      Decimal.parse(value);
      return true;
    } catch (e) {
      return false;
    }
  }
  
  /// Formatea un monto para mostrar con decimales fijos
  /// 
  /// Útil para mostrar tarifas o montos finales
  static String formatFixed(Decimal amount, int decimals) {
    return amount.toStringAsFixed(decimals);
  }
}

