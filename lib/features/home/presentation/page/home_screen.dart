import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_super_exchange_flutter/core/widgets/animated_fade_in_widget.dart';
import 'package:my_super_exchange_flutter/features/exchange/presentation/page/exchange_screen.dart';
import 'package:my_super_exchange_flutter/features/home/data/repositories/home_repository_impl.dart';
import 'package:my_super_exchange_flutter/features/home/presentation/bloc/home_bloc.dart';
import 'widgets/header_widget.dart';
import 'widgets/balance_card_widget.dart';
import 'widgets/recent_recipients_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
      create: (context) => HomeBloc(homeRepository: HomeRepositoryImpl(),)
        ..add(const HomeInitialEvent(),),
      child: _Page(),
    );
  }
}

class _Page extends StatelessWidget {
  const _Page();

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        // if (state is HomeDataLoadedState) {
        //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
        // }
      },
      child: _Body(),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          SafeArea(
            child: BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                if (state is HomeLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  );
                }
      
                if (state is HomeErrorState) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 60,
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Text(
                            'Error: ${state.error}',
                            style: const TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context.read<HomeBloc>().add(const HomeLoadDataEvent());
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }
      
                if (state is HomeEmptyDataState) {
                  return const Center(
                    child: Text(
                      'No data available',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }
      
                if (state is HomeDataLoadedState) {
                  const int transitionDuration = 1500;
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        AnimatedFadeInWidget(
                          duration: const Duration(milliseconds: transitionDuration + 100),
                          child: HeaderWidget(
                            profileImage: state.user.profileImage,
                            userName: state.user.name,
                            notificationCount: state.user.notificationCount,
                          ),
                        ),
                        const SizedBox(height: 32),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AnimatedFadeInWidget(
                                duration: const Duration(milliseconds: transitionDuration + 300),
                                child: Text(
                                  'Welcome back!',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              AnimatedFadeInWidget(
                                duration: const Duration(milliseconds: transitionDuration + 450),
                                child: Text(
                                  'Hello, ${state.user.firstName}!',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        AnimatedFadeInWidget(
                          duration: const Duration(milliseconds: transitionDuration + 600),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                              context,
                              PageRouteBuilder(
                                transitionDuration: const Duration(milliseconds: 1200),
                                reverseTransitionDuration: const Duration(milliseconds: 1200),
                                pageBuilder: (context, animation, secondaryAnimation) {
                                  return const ExchangeScreen();
                                },
                                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  );
                                },
                              ));
                              },
                              child: Hero(
                                tag: 'balance_card',
                                child: Material(
                                  color: Colors.transparent,
                                  child: BalanceCardWidget(
                                    amount: state.balance.amount,
                                    currency: state.balance.currency,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        AnimatedFadeInWidget(
                          duration: const Duration(milliseconds: transitionDuration + 750),
                          child: RecentRecipientsWidget(recipients: state.recipients),
                        ),
                        const SizedBox(height: 32),
                        // SavingsSectionWidget(savings: state.savings),
                        // const SizedBox(height: 32),
                      ],
                    ),
                  );
                }
      
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
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