import 'package:flutter/material.dart';
import '../../data/mocked_data.dart';
import 'widgets/header_widget.dart';
import 'widgets/balance_card_widget.dart';
import 'widgets/recent_recipients_widget.dart';
import 'widgets/savings_section_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userData = homeData['user'] as Map<String, dynamic>;
    final balanceData = homeData['balance'] as Map<String, dynamic>;
    final recipientsData =
        homeData['recentRecipients'] as List<Map<String, dynamic>>;
    final savingsData = homeData['savings'] as List<Map<String, dynamic>>;

    return Scaffold(
      backgroundColor: Colors.red,
      body: Stack(
        children: [
          _buildBackground(),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  HeaderWidget(
                    profileImage: userData['profileImage'] as String,
                    userName: userData['name'] as String,
                    notificationCount: userData['notificationCount'] as int,
                  ),
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome back!',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Hello, ${userData['firstName']}!',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  BalanceCardWidget(
                    amount: (balanceData['amount'] as num).toDouble(),
                    currency: balanceData['currency'] as String,
                  ),
                  const SizedBox(height: 32),
                  RecentRecipientsWidget(recipients: recipientsData),
                  const SizedBox(height: 32),
                  SavingsSectionWidget(savings: savingsData),
                  const SizedBox(height: 32),
                ],
              ),
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
