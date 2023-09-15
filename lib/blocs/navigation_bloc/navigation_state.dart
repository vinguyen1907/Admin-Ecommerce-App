part of 'navigation_bloc.dart';

class NavigationState extends Equatable {
  NavigationState({required this.navigatorKey});

  final GlobalKey<NavigatorState> navigatorKey;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  List<Object> get props => [navigatorKey];
}
