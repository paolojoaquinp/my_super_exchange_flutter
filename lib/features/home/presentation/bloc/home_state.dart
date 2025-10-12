part of 'home_bloc.dart';

sealed class HomeState extends Equatable {
  const HomeState();
  
  @override
  List<Object> get props => [];
}

final class HomeInitial extends HomeState {
  @override
  List<Object> get props => [];
}

class HomeLoadingState extends HomeState {
  const HomeLoadingState();
  
  @override
  List<Object> get props => [];  
}

class HomeDataLoadedState extends HomeState {
  final UserModel user;
  final BalanceModel balance;
  final List<RecipientModel> recipients;
  final List<SavingModel> savings;

  const HomeDataLoadedState({
    required this.user,
    required this.balance,
    required this.recipients,
    required this.savings,
  });

  HomeDataLoadedState copyWith({
    UserModel? user,
    BalanceModel? balance,
    List<RecipientModel>? recipients,
    List<SavingModel>? savings,
  }) {
    return HomeDataLoadedState(
      user: user ?? this.user,
      balance: balance ?? this.balance,
      recipients: recipients ?? this.recipients,
      savings: savings ?? this.savings,
    );
  }

  @override
  List<Object> get props => [user, balance, recipients, savings];
}

class HomeEmptyDataState extends HomeState {
  const HomeEmptyDataState();

  @override
  List<Object> get props => [];
}

class HomeErrorState extends HomeState {
  const HomeErrorState({required this.error});

  final String error;

  @override
  List<Object> get props => [error];
}
