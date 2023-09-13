part of 'navigation_bloc.dart';

class NavigationState extends Equatable {
  const NavigationState({required this.navigatorKey});

  final GlobalKey<NavigatorState> navigatorKey;

  @override
  List<Object> get props => [navigatorKey];
}
