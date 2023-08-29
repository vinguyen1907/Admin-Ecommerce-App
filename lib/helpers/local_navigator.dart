import 'package:admin_ecommerce_app/blocs/bloc/navigation_bloc.dart';
import 'package:admin_ecommerce_app/constants/app_routes.dart';
import 'package:admin_ecommerce_app/screens/dashboard_screen/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Navigator localNavigator(BuildContext context) => Navigator(
      key: context.read<NavigationBloc>().state.navigatorKey,
      onGenerateRoute: AppRoutes().onGenerateRoute,
      initialRoute: DashboardScreen.routeName,
    );
