import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'services/auth_service.dart';
import 'ui/screens/auth/login_screen.dart';
import 'blocs/auth/auth_bloc.dart';
import 'repositories/auth_repository.dart';
import 'repositories/site_repository.dart';
import 'services/api_client.dart';
import 'ui/screens/auth/signup_screen.dart';
import 'ui/screens/home_screen.dart';
import 'services/site_service.dart';
import 'blocs/site/site_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

final Logger logger = Logger();

void main() {
  Logger.level = Level.debug;
  setup();
  runApp(MyApp());
}

void setup() {
  final getIt = GetIt.instance;
  getIt.registerSingleton<AuthService>(AuthService());
  getIt.registerSingleton<ApiClient>(
      ApiClient(authService: getIt<AuthService>()));
  getIt.registerSingleton<AuthRepository>(
      AuthRepository(apiClient: getIt<ApiClient>()));
  getIt.registerFactory(() => AuthBloc(
      authRepository: getIt<AuthRepository>(),
      authService: getIt<AuthService>()));

  // Register SiteRepository and SiteBloc
  getIt.registerSingleton<SiteRepository>(
      SiteRepository(apiClient: getIt<ApiClient>()));
  getIt.registerSingleton<SiteService>(
      SiteService(siteRepository: getIt<SiteRepository>()));
  getIt.registerFactory(() => SiteBloc(siteService: getIt<SiteService>()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) {
            final authBloc = GetIt.instance<AuthBloc>();
            authBloc.add(CheckAuthEvent()); // Dispatch CheckAuthEvent here
            return authBloc;
          },
        ),
        BlocProvider<SiteBloc>(
          create: (context) => GetIt.instance<SiteBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Guard Client',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: AuthHandler(),
        routes: {
          '/login': (context) => LoginScreen(),
          '/signup': (context) => SignUpScreen(),
          '/home': (context) => HomeScreen(),
        },
      ),
    );
  }
}

class AuthHandler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthChecked) {
          if (state.isAuthenticated) {
            return HomeScreen();
          } else {
            return LoginScreen();
          }
        }
        return Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
