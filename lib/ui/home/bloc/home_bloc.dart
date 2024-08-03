import 'dart:core';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:online_shop/common/exception.dart';
import 'package:online_shop/data/model/category.dart';
import 'package:online_shop/data/model/product.dart';
import 'package:online_shop/data/repository/home_repository.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final IHomeRepository repository;

  HomeBloc({required this.repository}) : super(HomeLoading()) {
    on<HomeEvent>((event, emit) async {
      if (event is HomeStarted || event is HomeRefresh) {
        emit(HomeLoading());
        try {
          final dashboardItems = await repository.getAll();
          emit(HomeSuccess(
              banners: dashboardItems.sliders!,
              categories: dashboardItems.categories!,
              discountedProducts: dashboardItems.discountedProducts!,
              latestProducts: dashboardItems.latestProducts!));
        } catch (e) {
          emit(HomeError(exception: e is AppException ? e : AppException()));
        }
      }
    });
  }
}
