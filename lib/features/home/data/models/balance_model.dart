import 'package:my_super_exchange_flutter/features/home/domain/entities/balance_entity.dart';

class BalanceModel extends BalanceEntity {
  const BalanceModel({
    required super.amount,
    required super.currency,
  });

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'currency': currency,
    };
  }

  factory BalanceModel.fromJson(Map<String, dynamic> json) {
    return BalanceModel(
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
    );
  }

  BalanceModel copyWith({
    double? amount,
    String? currency,
  }) {
    return BalanceModel(
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
    );
  }
}

