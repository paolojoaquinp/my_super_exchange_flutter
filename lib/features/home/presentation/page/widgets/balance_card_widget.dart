import 'package:flutter/material.dart';
import 'package:my_super_exchange_flutter/features/exchange/presentation/page/exchange_screen.dart';

class BalanceCardWidget extends StatelessWidget {
  final double amount;
  final String currency;
  final bool showButton;

  const BalanceCardWidget({
    super.key,
    required this.amount,
    required this.currency,
    this.showButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF6366F1),
            Color(0xFF8B5CF6),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total Balance',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currency,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                  ),
                  Text(
                    amount.toStringAsFixed(0).replaceAllMapped(
                          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                          (Match m) => '${m[1]},',
                        ),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                  ),
                  Text(
                    '.${(amount % 1 * 100).toInt().toString().padLeft(2, '0')}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ],
          ),
          if(showButton)
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.arrow_forward,
                color: Color(0xFF6366F1),
                size: 24,
              ),
            ),
        ],
      ),
    );
  }
}

