import 'package:buyme/bloc/auth_bloc/auth_bloc.dart';
import 'package:buyme/models/user_model.dart';
import 'package:buyme/pushNotification/notification_system.dart';
import 'package:buyme/repository/auth.dart';
import 'package:buyme/screens/complete_profile/update_info.dart';
import 'package:buyme/screens/home_screens/chat.dart';
import 'package:buyme/screens/home_screens/feeds.dart';
import 'package:buyme/screens/home_screens/matches.dart';
import 'package:buyme/screens/home_screens/profile.dart';
import 'package:buyme/service/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:motion_tab_bar_v2/motion-tab-bar.dart';

class HomePage extends StatefulWidget {
  MyUser user;
  HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final AuthRepository authRepository = AuthRepository();

  late List screens;
  int selected = 0;
  bool status = false;

  updateData() async {
    final Placemark? location = await getLocation();
    if (location != null) {
      await authRepository.updateLocation(
          "${location.administrativeArea!}, ${location.country}",
          widget.user.id);
    }
  }

  updateStatus() async {
    return await authRepository.updateStatus(status, widget.user.id);
  }

  getUserData() async {
    return await authRepository.getMyUser(widget.user.id);
  }

  getUser() async {
    widget.user = await getUserData();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setState(() {
        status = true;
      });
      updateStatus();
    } else {
      setState(() {
        status = false;
        updateStatus();
      });
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    updateData();
    getUser();
    PushNotoficationSystem notificationSystem = PushNotoficationSystem();
    notificationSystem.generateFCMToken();
    notificationSystem.notificationReceived(context);
    screens = [
      FeedsPage(user: widget.user),
      MatchesPage(user: widget.user),
      ChatPage(user: widget.user),
      ProfilePage(user: widget.user)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthSuccessState) {
          if (state.user.photo == "" || state.user.photo == " ") {
            setState(() {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => UpdateInfo(
                          user: state.user,
                        )),
              );
            });
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          shape: const RoundedRectangleBorder(),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: const [
              Icon(
                Icons.favorite_border_rounded,
                color: Colors.pinkAccent,
                size: 30,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                'Selam',
                style: TextStyle(
                    color: Colors.white, fontSize: 30, letterSpacing: 3),
              ),
            ],
          ),
          // centerTitle: true,
          elevation: 0,
        ),
        backgroundColor: Colors.grey.shade900,
        body: screens[selected],
        bottomNavigationBar: SafeArea(
          child: MotionTabBar(
            initialSelectedTab: "Nearby",
            labels: const ["Nearby", "Matches", "Chat", "Profile"],
            icons: const [
              Icons.map,
              Icons.group,
              Icons.chat_bubble,
              Icons.person
            ],
            tabSize: 50,
            tabBarHeight: 60,
            textStyle: const TextStyle(
              fontSize: 15,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
            tabIconColor: Colors.pinkAccent,
            tabIconSize: 30.0,
            tabIconSelectedSize: 26.0,
            tabSelectedColor: Colors.pink,
            tabIconSelectedColor: Colors.white,
            tabBarColor: Colors.grey[850],
            onTabItemSelected: (int value) {
              setState(() {
                selected = value;
              });
            },
          ),
        ),
      ),
    );
  }
}
