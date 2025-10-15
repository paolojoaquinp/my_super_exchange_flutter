import 'package:flutter/material.dart';
import 'widgets/widgets.dart';

class ExchangeScreen extends StatelessWidget {
  const ExchangeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _Page();
  }
}

class _Page extends StatelessWidget {
  const _Page();

  @override
  Widget build(BuildContext context) {
    return _Body();
  }
}

class _Body extends StatefulWidget {
  const _Body();

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  final TextEditingController _fromAmountController = TextEditingController(text: '320');
  final TextEditingController _toAmountController = TextEditingController(text: '310.38');
  final FocusNode _fromAmountFocusNode = FocusNode();
  final FocusNode _toAmountFocusNode = FocusNode();
  String platformFee = '1.20';

  @override
  void dispose() {
    _fromAmountController.dispose();
    _toAmountController.dispose();
    _fromAmountFocusNode.dispose();
    _toAmountFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 8),
                const ExchangeHeaderWidget(),
                const SizedBox(height: 32),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'From',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 12),
                              CurrencyCardWidget(
                                currencyCode: 'USD',
                                currencyIcon: Icons.attach_money,
                                amountController: _fromAmountController,
                                focusNode: _fromAmountFocusNode,
                                backgroundColor: const Color(0xFF1E293B),
                                onChanged: (value) {
                                  // TODO: Calcular conversión
                                },
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'To',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 12),
                              CurrencyCardWidget(
                                currencyCode: 'EUR',
                                currencyIcon: Icons.euro,
                                amountController: _toAmountController,
                                focusNode: _toAmountFocusNode,
                                backgroundColor: const Color(0xFF1E293B),
                                onChanged: (value) {
                                  // TODO: Calcular conversión
                                },
                              ),
                              const SizedBox(height: 20),
                              PlatformFeeWidget(fee: platformFee),
                              const SizedBox(height: 20),
                              const ExchangeButtonWidget(),
                              const SizedBox(height: 24),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2D3E6F), Color(0xFF1E293B), Color(0xFF0F172A)],
        ),
      ),
    );
  }
}

