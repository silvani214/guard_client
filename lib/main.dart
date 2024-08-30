import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guard_client/ui/screens/chat/chat_screen.dart';
import 'package:guard_client/ui/screens/sites/map_screen.dart';
import 'package:guard_client/ui/screens/event/event_screen.dart';
import 'services/auth_service.dart';
import 'ui/screens/auth/login_screen.dart';
import 'blocs/auth/auth_bloc.dart';
import 'repositories/auth_repository.dart';
import 'repositories/site_repository.dart';
import 'repositories/guard_repository.dart';
import 'repositories/event_repository.dart';
import 'repositories/visitor_repository.dart';
import 'repositories/report_repository.dart';
import 'repositories/photo_repository.dart';
import 'repositories/schedule_repository.dart';
import 'services/api_client.dart';
import 'ui/screens/auth/signup_screen.dart';
import 'ui/screens/home_screen.dart';
import 'services/site_service.dart';
import 'services/guard_service.dart';
import 'services/event_service.dart';
import 'blocs/site/site_bloc.dart';
import 'blocs/guard/guard_bloc.dart';
import 'blocs/event/event_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:firebase_core/firebase_core.dart';
import 'ui/screens/sitemap/map.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'firebase_options.dart';
import 'utils/app_theme.dart';
import 'utils/route_observer.dart';
import 'ui/screens/splash/splash_screen.dart';
import './auth_handler.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

final Logger logger = Logger();

void main() async {
  Logger.level = Level.debug;
  setup();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAppCheck.instance.activate(
    webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.appAttest,
  );

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');

      if (message.data.containsKey('siteId')) {
        int siteId = int.parse(message.data['siteId']);
        navigatorKey.currentState?.pushNamed(
          '/event',
          arguments: {'siteId': siteId},
        );
      }
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('A new onMessageOpenedApp event was published!');
    // Handle message tap here
    if (message.data.containsKey('siteId')) {
      int siteId = int.parse(message.data['siteId']);
      navigatorKey.currentState?.pushNamed(
        '/event',
        arguments: {'siteId': siteId},
      );
    }
  });

  String? token = await messaging.getToken();
  print("******************************************** Device Token: $token");

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

  getIt.registerSingleton<GuardRepository>(
      GuardRepository(apiClient: getIt<ApiClient>()));
  getIt.registerSingleton<GuardService>(
      GuardService(guardRepository: getIt<GuardRepository>()));
  getIt.registerFactory(() => GuardBloc(guardService: getIt<GuardService>()));

  getIt.registerSingleton<EventRepository>(
      EventRepository(apiClient: getIt<ApiClient>()));

  getIt.registerSingleton<EventService>(
      EventService(eventRepository: getIt<EventRepository>()));
  getIt.registerFactory(() => EventBloc(eventService: getIt<EventService>()));

  // Register SiteRepository and SiteBloc
  getIt.registerSingleton<SiteRepository>(
      SiteRepository(apiClient: getIt<ApiClient>()));
  getIt.registerSingleton<SiteService>(
      SiteService(siteRepository: getIt<SiteRepository>()));
  getIt.registerFactory(() => SiteBloc(siteService: getIt<SiteService>()));

  getIt.registerSingleton<VisitorRepository>(
      VisitorRepository(apiClient: getIt<ApiClient>()));
  getIt.registerSingleton<ReportRepository>(
      ReportRepository(apiClient: getIt<ApiClient>()));
  getIt.registerSingleton<PhotoRepository>(
      PhotoRepository(apiClient: getIt<ApiClient>()));
  getIt.registerSingleton<ScheduleRepository>(
      ScheduleRepository(apiClient: getIt<ApiClient>()));
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

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
        BlocProvider<EventBloc>(
          create: (context) => GetIt.instance<EventBloc>(),
        ),
        BlocProvider<GuardBloc>(
          create: (context) => GetIt.instance<GuardBloc>(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Guard Client',
        theme: AppThemeData.defaultTheme,
        navigatorObservers: <NavigatorObserver>[routeObserver],
        home: AuthHandler(),
        navigatorKey: navigatorKey,
        onGenerateRoute: (settings) {
          print('event event event');

          if (settings.name == '/event') {
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (context) {
                return EventScreen(siteId: args['siteId']);
              },
            );
          }
          // Handle other routes if necessary
          return null;
        },
        routes: {
          '/login': (context) => LoginScreen(),
          '/signup': (context) => SignUpScreen(),
          '/home': (context) => HomeScreen(),
        },
      ),
    );
  }
}
