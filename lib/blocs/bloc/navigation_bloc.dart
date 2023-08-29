import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'navigation_event.dart';
part 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(NavigationState()) {
    on<NavigateTo>(_onNavigateTo);
  }

  _onNavigateTo(NavigateTo event, Emitter<NavigationState> emit) {
    state.navigatorKey.currentState!.pushNamed(
      event.routeName,
      arguments: event.arguments,
    );
  }
}
