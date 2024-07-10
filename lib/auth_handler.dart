import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'services/auth_service.dart';
import 'ui/screens/auth/login_screen.dart';
import 'blocs/auth/auth_bloc.dart';
import 'ui/screens/home_screen.dart';
import 'ui/screens/splash/splash_screen.dart';

class AuthHandler extends StatefulWidget {
  @override
  _AuthHandlerState createState() => _AuthHandlerState();
}

class _AuthHandlerState extends State<AuthHandler> {
  bool _isTimerComplete = false;
  bool _isAuthChecked = false;
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () {
      setState(() {
        _isTimerComplete = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthSuccess) {
            _isAuthChecked = true;
            _isAuthenticated = true;
          } else if (state is AuthChecked) {
            _isAuthChecked = true;
            _isAuthenticated = state.isAuthenticated;
          } else {
            return SplashScreen();
          }

          if (_isAuthChecked && _isTimerComplete) {
            return _isAuthenticated ? HomeScreen() : LoginScreen();
          }

          return SplashScreen();
        },
      ),
    );
  }
}
