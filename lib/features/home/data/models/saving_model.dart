import 'package:my_super_exchange_flutter/features/home/domain/entities/saving_entity.dart';

class SavingModel extends SavingEntity {
  const SavingModel({
    required super.id,
    required super.name,
    required super.amount,
    required super.target,
    required super.color,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'target': target,
      'color': color,
    };
  }

  factory SavingModel.fromJson(Map<String, dynamic> json) {
    return SavingModel(
      id: json['id'] as String,
      name: json['name'] as String,
      amount: json['amount'] as int,
      target: json['target'] as int,
      color: json['color'] as int,
    );
  }

  SavingModel copyWith({
    String? id,
    String? name,
    int? amount,
    int? target,
    int? color,
  }) {
    return SavingModel(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      target: target ?? this.target,
      color: color ?? this.color,
    );
  }
}

