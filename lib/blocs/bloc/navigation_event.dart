part of 'navigation_bloc.dart';

sealed class NavigationEvent extends Equatable {
  const NavigationEvent();

  @override
  List<Object?> get props => [];
}

class NavigateTo extends NavigationEvent {
  final String routeName;
  final Object? arguments;

  const NavigateTo({
    required this.routeName,
    this.arguments,
  });

  @override
  List<Object?> get props => [routeName, arguments];
}
