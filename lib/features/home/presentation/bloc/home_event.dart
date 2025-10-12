part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class HomeInitialEvent extends HomeEvent {
  const HomeInitialEvent();
  
  @override
  List<Object> get props => [];
}

class HomeLoadDataEvent extends HomeEvent {
  const HomeLoadDataEvent();
  
  @override
  List<Object> get props => [];
}
