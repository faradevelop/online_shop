part of 'home_bloc.dart';

@immutable
sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class HomeStarted extends HomeEvent {}

class HomeRefresh extends HomeEvent {}
