import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_super_exchange_flutter/features/exchange/data/repositories_impl/exchange_repository_impl.dart';
import 'package:my_super_exchange_flutter/features/exchange/presentation/bloc/exchange_bloc.dart';
import 'widgets/widgets.dart';

class ExchangeScreen extends StatelessWidget {
  const ExchangeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ExchangeBloc>(
      create: (context) =>
          ExchangeBloc(repository: ExchangeRepositoryImpl())
            ..add(const LoadAvailableCurrencies()),
      child: const _Page(),
    );
  }
}

class _Page extends StatelessWidget {
  const _Page();

  @override
  Widget build(BuildContext context) {
    return BlocListener<ExchangeBloc, ExchangeState>(
      listener: (context, state) {
        if (state is ExchangeError) {
          Fluttertoast.showToast(
            msg: state.message,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 3,
            backgroundColor: const Color(0xFFEF4444),
            textColor: Colors.white,
            fontSize: 16.0,
          );
        } else if (state is ExchangeSuccess) {
          Fluttertoast.showToast(
            msg: state.message,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 2,
            backgroundColor: const Color(0xFF10B981),
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      },
      child: const _Body(),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body();

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  final TextEditingController _fromAmountController = TextEditingController();
  final TextEditingController _toAmountController = TextEditingController();
  final FocusNode _fromAmountFocusNode = FocusNode();
  final FocusNode _toAmountFocusNode = FocusNode();

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
            child: BlocBuilder<ExchangeBloc, ExchangeState>(
              builder: (context, state) {
                if (state is ExchangeLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                }

                if (state is ExchangeLoaded) {
                  // Actualizar los controladores con los valores del estado
                  if (_fromAmountController.text !=
                      state.fromAmount.toStringAsFixed(2)) {
                    _fromAmountController.text = state.fromAmount
                        .toStringAsFixed(2);
                  }
                  if (_toAmountController.text !=
                      state.toAmount.toStringAsFixed(2)) {
                    _toAmountController.text = state.toAmount.toStringAsFixed(
                      2,
                    );
                  }

                  return Column(
                    children: [
                      const SizedBox(height: 8),
                      const ExchangeHeaderWidget(),
                      const SizedBox(height: 32),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24.0,
                                ),
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
                                      currencyCode:
                                          state.fromCurrency?.code ?? '',
                                      currencyIcon: Icons.attach_money,
                                      amountController: _fromAmountController,
                                      focusNode: _fromAmountFocusNode,
                                      backgroundColor: const Color(0xFF1E293B),
                                      onChanged: (value) {
                                        final amount =
                                            double.tryParse(value) ?? 0.0;
                                        context.read<ExchangeBloc>().add(
                                          ChangeFromAmount(amount),
                                        );
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
                                      currencyCode:
                                          state.toCurrency?.code ?? '',
                                      currencyIcon: Icons.currency_bitcoin,
                                      amountController: _toAmountController,
                                      focusNode: _toAmountFocusNode,
                                      backgroundColor: const Color(0xFF1E293B),
                                      onChanged: (value) {
                                        final amount =
                                            double.tryParse(value) ?? 0.0;
                                        context.read<ExchangeBloc>().add(
                                          ChangeToAmount(amount),
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 20),
                                    PlatformFeeWidget(
                                      fee: state.platformFee.toStringAsFixed(2),
                                    ),
                                    const SizedBox(height: 20),
                                    ExchangeButtonWidget(
                                      onTap: () {
                                        context.read<ExchangeBloc>().add(
                                          const ExecuteExchange(),
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 24),
                                    if (state.isCalculating)
                                      const Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }

                return const Center(
                  child: Text(
                    'Error al cargar',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              },
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
