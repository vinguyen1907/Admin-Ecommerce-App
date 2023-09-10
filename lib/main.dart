import 'package:admin_ecommerce_app/blocs/dashboard_bloc/dashboard_bloc.dart';
import 'package:admin_ecommerce_app/blocs/navigation_bloc/navigation_bloc.dart';
import 'package:admin_ecommerce_app/blocs/order_tracking_bloc/order_tracking_bloc.dart';
import 'package:admin_ecommerce_app/blocs/orders_bloc/orders_bloc.dart';
import 'package:admin_ecommerce_app/blocs/product_screen_bloc/product_screen_bloc.dart';
import 'package:admin_ecommerce_app/blocs/promotions_bloc/promotions_bloc.dart';
import 'package:admin_ecommerce_app/constants/app_colors.dart';
import 'package:admin_ecommerce_app/constants/app_routes.dart';
import 'package:admin_ecommerce_app/firebase_options.dart';
import 'package:admin_ecommerce_app/helpers/custom_scroll_behavior.dart';
import 'package:admin_ecommerce_app/screens/main_screen/main_screen.dart';
import 'package:admin_ecommerce_app/services/notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    NotificationService().sendNotification(
        "eVEQzZkQQVKb628OYslwc0:APA91bHIEuiiwz4-I4sew97EKYPUmx4mhgj6mixaZQsNDTX2mVLkrR-E9RPlZNYVVVfB4G98sQ4mS9EFgWcP2seJ54SnoCGGLe-VGhlRDRAUJTboB0fK4JdEdv3wo3QFIK7HDY40jbBz",
        "Test",
        "Test");
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => NavigationBloc()),
        BlocProvider(create: (_) => DashboardBloc()),
        BlocProvider(create: (_) => ProductScreenBloc()),
        BlocProvider(create: (_) => OrdersBloc()),
        BlocProvider(create: (_) => PromotionsBloc()),
        BlocProvider(
            create: (_) => OrderTrackingBloc(dashboardBloc: DashboardBloc())),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Admin Ecommerce App',
        theme: ThemeData(
          fontFamily: "Poppins",
          scaffoldBackgroundColor: AppColors.backgroundColor,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        onGenerateRoute: AppRoutes().onGenerateRoute,
        scrollBehavior: MyCustomScrollBehavior(),
        // builder: (_, child) => const MainScreen(),
        // initialRoute: DashboardScreen.routeName,
        home: const MainScreen(),
      ),
    );
  }
}
