enum CurrencyType {
  fiat,
  crypto,
}

class CurrencyEntity {
  final String id;
  final String code;
  final String name;
  final CurrencyType type;
  final String? icon;

  const CurrencyEntity({
    required this.id,
    required this.code,
    required this.name,
    required this.type,
    this.icon,
  });
}

