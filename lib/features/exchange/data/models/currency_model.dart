import 'package:my_super_exchange_flutter/features/exchange/domain/entities/currency_entity.dart';

class CurrencyModel extends CurrencyEntity {
  const CurrencyModel({
    required super.id,
    required super.code,
    required super.name,
    required super.type,
    super.icon,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'type': type.toString().split('.').last,
      'icon': icon,
    };
  }

  factory CurrencyModel.fromJson(Map<String, dynamic> json) {
    return CurrencyModel(
      id: json['id'] as String,
      code: json['code'] as String,
      name: json['name'] as String,
      type: json['type'] == 'crypto' ? CurrencyType.crypto : CurrencyType.fiat,
      icon: json['icon'] as String?,
    );
  }

  CurrencyModel copyWith({
    String? id,
    String? code,
    String? name,
    CurrencyType? type,
    String? icon,
  }) {
    return CurrencyModel(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      type: type ?? this.type,
      icon: icon ?? this.icon,
    );
  }
}

