import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:my_super_exchange_flutter/features/home/data/models/balance_model.dart';
import 'package:my_super_exchange_flutter/features/home/data/models/recipient_model.dart';
import 'package:my_super_exchange_flutter/features/home/data/models/saving_model.dart';
import 'package:my_super_exchange_flutter/features/home/data/models/user_model.dart';
import 'package:my_super_exchange_flutter/features/home/domain/repositories/home_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({required this.homeRepository}) : super(HomeInitial()) {
    on<HomeInitialEvent>(_onHomeInitialEvent);
    on<HomeLoadDataEvent>(_onHomeLoadDataEvent);
  }

  final HomeRepository homeRepository;

  Future<void> _onHomeInitialEvent(
    HomeInitialEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(const HomeLoadingState());

    final result = await homeRepository.getHomeData();

    result.when(
      ok: (data) {
        final user = data['user'] as UserModel;
        final balance = data['balance'] as BalanceModel;
        final recipients = data['recentRecipients'] as List<RecipientModel>;
        final savings = data['savings'] as List<SavingModel>;

        if (user.name.isNotEmpty) {
          emit(HomeDataLoadedState(
            user: user,
            balance: balance,
            recipients: recipients,
            savings: savings,
          ));
        } else {
          emit(const HomeEmptyDataState());
        }
      },
      err: (error) => emit(HomeErrorState(error: error)),
    );
  }

  Future<void> _onHomeLoadDataEvent(
    HomeLoadDataEvent event,
    Emitter<HomeState> emit,
  ) async {
    try {
      final result = await homeRepository.getHomeData();
      
      result.when(
        ok: (data) {
          final user = data['user'] as UserModel;
          final balance = data['balance'] as BalanceModel;
          final recipients = data['recentRecipients'] as List<RecipientModel>;
          final savings = data['savings'] as List<SavingModel>;

          if (user.name.isNotEmpty) {
            emit(HomeDataLoadedState(
              user: user,
              balance: balance,
              recipients: recipients,
              savings: savings,
            ));
          } else {
            emit(const HomeEmptyDataState());
          }
        },
        err: (error) {
          emit(HomeErrorState(error: error));
        },
      );
    } catch (e) {
      emit(HomeErrorState(error: e.toString()));
    }
  }
}
