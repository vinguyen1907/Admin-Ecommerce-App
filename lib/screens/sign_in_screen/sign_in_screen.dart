import 'dart:async';

import 'package:admin_ecommerce_app/blocs/user_bloc/user_bloc.dart';
import 'package:admin_ecommerce_app/common_widgets/loading_manager.dart';
import 'package:admin_ecommerce_app/common_widgets/my_elevated_button.dart';
import 'package:admin_ecommerce_app/common_widgets/my_icon.dart';
import 'package:admin_ecommerce_app/common_widgets/my_text_field.dart';
import 'package:admin_ecommerce_app/common_widgets/screen_name_section.dart';
import 'package:admin_ecommerce_app/constants/app_assets.dart';
import 'package:admin_ecommerce_app/constants/app_colors.dart';
import 'package:admin_ecommerce_app/constants/app_styles.dart';
import 'package:admin_ecommerce_app/screens/main_screen/main_screen.dart';
import 'package:admin_ecommerce_app/services/firebase_auth_service.dart';
import 'package:admin_ecommerce_app/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  static const String routeName = "/sign-in-screen";

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  String? message;
  StreamSubscription<User?>? _authStateChangesSubscription;

  @override
  void initState() {
    super.initState();

    Utils.getSignInState().then((isSignedIn) {
      if (isSignedIn) {
        context.read<UserBloc>().add(const LoadUser());
        if (_authStateChangesSubscription != null) {
          _authStateChangesSubscription!.cancel();
        }
      }
    });
    _authStateChangesSubscription =
        FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        context.read<UserBloc>().add(const LoadUser());
        Utils.changeSignInState(true);
        _authStateChangesSubscription!.cancel();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _authStateChangesSubscription!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return BlocConsumer<UserBloc, UserState>(listener: (context, state) {
      if (state is UserLoading) {
        setState(() {
          isLoading = true;
        });
      } else if (state is UserLoaded) {
        setState(() {
          isLoading = false;
        });
        Navigator.pushNamed(context, MainScreen.routeName);
      } else if (state is UserError) {
        setState(() {
          isLoading = false;
          message = state.message;
        });
      }
    }, builder: (context, state) {
      return Scaffold(
        body: SafeArea(
          child: LoadingManager(
            isLoading: isLoading,
            child: Center(
              child: Container(
                width: size.width * 0.4,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      )
                    ]),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ScreenNameSection("Log in"),
                      MyTextField(
                        controller: _emailController,
                        hintText: "Email",
                        prefixIcon: const MyIcon(
                          icon: AppAssets.icEmail,
                          colorFilter: ColorFilter.mode(
                              AppColors.greyColor, BlendMode.srcIn),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Email is required.";
                          } else if (!Utils.isEmailValid(value)) {
                            return "Please enter valid email.";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      MyTextField(
                        controller: _passwordController,
                        hintText: "Password",
                        obscureText: true,
                        prefixIcon: const MyIcon(
                          icon: AppAssets.icLock,
                          colorFilter: ColorFilter.mode(
                              AppColors.greyColor, BlendMode.srcIn),
                        ),
                        onSubmitted: (value) => _onLogIn(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Password is required.";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      MyElevatedButton(
                          onPressed: _onLogIn,
                          widget: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Log In",
                                  style: AppStyles.labelMedium.copyWith(
                                      color: AppColors.whiteColor,
                                      fontFamily: "Poppins")),
                            ],
                          )),
                      if (message != null) const SizedBox(height: 12),
                      if (message != null)
                        Text(message!,
                            style: AppStyles.bodySmall
                                .copyWith(color: Colors.red)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  void _onLogIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      try {
        await FirebaseAuthService().signInWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text);
      } on FirebaseAuthException catch (e) {
        setState(() {
          message = e.message;
        });
      }

      setState(() {
        isLoading = false;
      });
    }
  }
}
