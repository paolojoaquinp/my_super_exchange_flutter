import 'package:flutter/material.dart';
import 'package:my_super_exchange_flutter/features/home/domain/entities/saving_entity.dart';
import 'savings_card_widget.dart';

class SavingsSectionWidget extends StatelessWidget {
  final List<SavingEntity> savings;

  const SavingsSectionWidget({
    super.key,
    required this.savings,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            'Savings',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 110,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            itemCount: savings.length,
            itemBuilder: (context, index) {
              final saving = savings[index];
              return Container(
                margin: EdgeInsets.only(
                  right: index < savings.length - 1 ? 12 : 0,
                ),
                child: SavingsCardWidget(
                  name: saving.name,
                  amount: saving.amount,
                  target: saving.target,
                  color: saving.color,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

