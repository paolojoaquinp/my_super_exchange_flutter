import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_super_exchange_flutter/core/widgets/animated_fade_in_widget.dart';
import 'package:my_super_exchange_flutter/features/exchange/data/repositories_impl/exchange_repository_impl.dart';
import 'package:my_super_exchange_flutter/features/exchange/presentation/bloc/exchange_bloc.dart';
import 'package:my_super_exchange_flutter/features/exchange/presentation/utils/amount_formatter.dart';
import 'package:my_super_exchange_flutter/features/home/presentation/page/widgets/balance_card_widget.dart';
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
  
  bool _isUserTyping = false;

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
    const int transitionDuration = 1500;
    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 8),
                const AnimatedFadeInWidget(
                  duration: Duration(milliseconds: transitionDuration + 100),
                  child: ExchangeHeaderWidget(),
                ),
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
                              AnimatedFadeInWidget(
                                duration: const Duration(milliseconds: transitionDuration + 250),
                                child: Hero(
                                  tag: 'balance_card',
                                  child: Material(
                                    color: Colors.transparent,
                                    child: BalanceCardWidget(
                                      amount: 24000.97,
                                      currency: 'USD',
                                      showButton: false,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              // Resto del contenido con BlocBuilder
                              BlocBuilder<ExchangeBloc, ExchangeState>(
                                builder: (context, state) {
                                  if (state is! ExchangeLoaded) {
                                    return const Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(32.0),
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      ),
                                    );
                                  }

                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const AnimatedFadeInWidget(
                                        duration: Duration(milliseconds: transitionDuration + 400),
                                        child: Text(
                                          'From',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      AnimatedFadeInWidget(
                                        duration: const Duration(milliseconds: transitionDuration + 500),
                                        child: CurrencyCardWidget(
                                          currencyCode:
                                              state.fromCurrency?.code ?? '',
                                          currencyIcon: Icons.attach_money,
                                          amountController: _fromAmountController,
                                          focusNode: _fromAmountFocusNode,
                                          backgroundColor: const Color(0xFF1E293B),
                                          onChanged: (value) {
                                            setState(() {
                                              _isUserTyping = true;
                                            });
                                            
                                            // Si está vacío, enviar 0
                                            if (value.isEmpty) {
                                              context.read<ExchangeBloc>().add(
                                                ChangeFromAmount(Decimal.zero),
                                              );
                                              setState(() {
                                                _isUserTyping = false;
                                              });
                                              return;
                                            }
                                            
                                            final amount = AmountFormatter.parse(value);
                                            context.read<ExchangeBloc>().add(
                                              ChangeFromAmount(amount),
                                            );
                                            
                                            // Marcar que terminó de escribir después de un momento
                                            Future.delayed(const Duration(milliseconds: 1100), () {
                                              if (mounted) {
                                                setState(() {
                                                  _isUserTyping = false;
                                                });
                                              }
                                            });
                                          },
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      const AnimatedFadeInWidget(
                                        duration: Duration(milliseconds: transitionDuration + 600),
                                        child: Text(
                                          'To',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      AnimatedFadeInWidget(
                                        duration: const Duration(milliseconds: transitionDuration + 700),
                                        child: CurrencyCardWidget(
                                          currencyCode:
                                              state.toCurrency?.code ?? '',
                                          currencyIcon: Icons.currency_bitcoin,
                                          amountController: _toAmountController,
                                          focusNode: _toAmountFocusNode,
                                          backgroundColor: const Color(0xFF1E293B),
                                          onChanged: (value) {
                                            final amount = AmountFormatter.parse(value);
                                            context.read<ExchangeBloc>().add(
                                              ChangeToAmount(amount),
                                            );
                                          },
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      AnimatedFadeInWidget(
                                        duration: const Duration(milliseconds: transitionDuration + 800),
                                        child: PlatformFeeWidget(
                                          fee: AmountFormatter.formatFixed(state.platformFee, 2),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      AnimatedFadeInWidget(
                                        duration: const Duration(milliseconds: transitionDuration + 900),
                                        child: ExchangeButtonWidget(
                                          isLoading: state.isExecutingExchange || (state is ExchangeLoading) || state.isCalculating,
                                          onTap: () {
                                            context.read<ExchangeBloc>().add(
                                              const ExecuteExchange(),
                                            );
                                          },
                                        ),
                                      ),
                                      const SizedBox(height: 24),
                                    ],
                                  );
                                },
                              ),
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
