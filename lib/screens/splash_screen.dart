import 'package:buyme/bloc/auth_bloc/auth_bloc.dart';
import 'package:buyme/screens/complete_profile/update_info.dart';
import 'package:buyme/screens/home_page.dart';
import 'package:buyme/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            print(state);
            if (state is AuthSuccessState) {
              if (state.user.photo == "" || state.user.photo == " ") {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UpdateInfo(
                            user: state.user,
                          )),
                );
              } else {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomePage(
                            user: state.user,
                          )),
                );
              }
            } else if (state is AuthLoggedOutState) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.5,
                  child: Image.asset('assets/logo.png')),
              SizedBox(
                height: 40,
              ),
              Text(
                "SELAM",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 50,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              LoadingAnimationWidget.fourRotatingDots(
                color: Colors.pink,
                size: 30,
              )
            ],
          ),
        ),
      ),
    );
  }
}
