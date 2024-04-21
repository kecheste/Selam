import 'package:buyme/bloc/auth_bloc/auth_bloc.dart';
import 'package:buyme/bloc/matches/matches_bloc.dart';
import 'package:buyme/config/theme.dart';
import 'package:buyme/firebase_options.dart';
import 'package:buyme/repository/auth.dart';
import 'package:buyme/repository/user.dart';
import 'package:buyme/screens/login.dart';
import 'package:buyme/screens/register.dart';
import 'package:buyme/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Permission.notification.isDenied.then((value) {
    if (value) {
      Permission.notification.request();
    }
  });
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(authRepository: AuthRepository()),
        ),
        BlocProvider<MatchesBloc>(
          create: (context) => MatchesBloc(userRepository: UserRepository()),
        )
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(CheckAuth());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Selam',
      debugShowCheckedModeBanner: false,
      theme: theme(),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => SplashScreen(),
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
      },
    );
  }
}
