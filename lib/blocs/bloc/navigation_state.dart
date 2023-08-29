part of 'navigation_bloc.dart';

class NavigationState extends Equatable {
  NavigationState();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  List<Object> get props => [navigatorKey];
}
