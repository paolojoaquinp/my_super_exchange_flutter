import 'package:my_super_exchange_flutter/features/home/domain/entities/recipient_entity.dart';

class RecipientModel extends RecipientEntity {
  const RecipientModel({
    required super.id,
    required super.name,
    required super.image,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
    };
  }

  factory RecipientModel.fromJson(Map<String, dynamic> json) {
    return RecipientModel(
      id: json['id'] as String,
      name: json['name'] as String,
      image: json['image'] as String,
    );
  }

  RecipientModel copyWith({
    String? id,
    String? name,
    String? image,
  }) {
    return RecipientModel(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
    );
  }
}

