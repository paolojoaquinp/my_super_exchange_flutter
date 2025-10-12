import 'package:my_super_exchange_flutter/features/home/data/mocked_data.dart';
import 'package:my_super_exchange_flutter/features/home/data/models/balance_model.dart';
import 'package:my_super_exchange_flutter/features/home/data/models/recipient_model.dart';
import 'package:my_super_exchange_flutter/features/home/data/models/saving_model.dart';
import 'package:my_super_exchange_flutter/features/home/data/models/user_model.dart';
import 'package:my_super_exchange_flutter/features/home/domain/repositories/home_repository.dart';
import 'package:oxidized/oxidized.dart';

class HomeRepositoryImpl implements HomeRepository {

  @override
  Future<Result<UserModel, String>> getUser() async {
    try {
      await _simulateNetworkDelay();

      final response = MockedHomeData.homeDataResponse;
      final userData = response['user'] as Map<String, dynamic>;

      final user = UserModel.fromJson(userData);
      return Ok(user);
    } catch (e) {
      return Err('Failed to fetch user data: $e');
    }
  }

  @override
  Future<Result<BalanceModel, String>> getBalance() async {
    try {
      await _simulateNetworkDelay();

      final response = MockedHomeData.homeDataResponse;
      final balanceData = response['balance'] as Map<String, dynamic>;

      final balance = BalanceModel.fromJson(balanceData);
      return Ok(balance);
    } catch (e) {
      return Err('Failed to fetch balance data: $e');
    }
  }

  @override
  Future<Result<List<RecipientModel>, String>> getRecentRecipients() async {
    try {
      await _simulateNetworkDelay();

      final response = MockedHomeData.homeDataResponse;
      final recipientsData = response['recentRecipients'] as List<dynamic>;

      final recipients = recipientsData
          .map((json) => RecipientModel.fromJson(json as Map<String, dynamic>))
          .toList();

      return Ok(recipients);
    } catch (e) {
      return Err('Failed to fetch recipients data: $e');
    }
  }

  @override
  Future<Result<List<SavingModel>, String>> getSavings() async {
    try {
      await _simulateNetworkDelay();

      final response = MockedHomeData.homeDataResponse;
      final savingsData = response['savings'] as List<dynamic>;

      final savings = savingsData
          .map((json) => SavingModel.fromJson(json as Map<String, dynamic>))
          .toList();

      return Ok(savings);
    } catch (e) {
      return Err('Failed to fetch savings data: $e');
    }
  }

  @override
  Future<Result<Map<String, dynamic>, String>> getHomeData() async {
    try {
      await _simulateNetworkDelay();

      final response = MockedHomeData.homeDataResponse;

      // Parse all data
      final userData = response['user'] as Map<String, dynamic>;
      final balanceData = response['balance'] as Map<String, dynamic>;
      final recipientsData = response['recentRecipients'] as List<dynamic>;
      final savingsData = response['savings'] as List<dynamic>;

      final user = UserModel.fromJson(userData);
      final balance = BalanceModel.fromJson(balanceData);
      final recipients = recipientsData
          .map((json) => RecipientModel.fromJson(json as Map<String, dynamic>))
          .toList();
      final savings = savingsData
          .map((json) => SavingModel.fromJson(json as Map<String, dynamic>))
          .toList();

      return Ok({
        'user': user,
        'balance': balance,
        'recentRecipients': recipients,
        'savings': savings,
      });
    } catch (e) {
      return Err('Failed to fetch home data: $e');
    }
  }

  // Simulate network delay
  Future<void> _simulateNetworkDelay() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}

