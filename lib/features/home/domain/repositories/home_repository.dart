import 'package:my_super_exchange_flutter/features/home/data/models/balance_model.dart';
import 'package:my_super_exchange_flutter/features/home/data/models/recipient_model.dart';
import 'package:my_super_exchange_flutter/features/home/data/models/saving_model.dart';
import 'package:my_super_exchange_flutter/features/home/data/models/user_model.dart';
import 'package:oxidized/oxidized.dart';

abstract class HomeRepository {
  Future<Result<UserModel, String>> getUser();
  Future<Result<BalanceModel, String>> getBalance();
  Future<Result<List<RecipientModel>, String>> getRecentRecipients();
  Future<Result<List<SavingModel>, String>> getSavings();
  Future<Result<Map<String, dynamic>, String>> getHomeData();
}

