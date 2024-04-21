import 'package:buyme/screens/onboarding_screens/onboarding_start.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  static const List<Tab> tabs = <Tab>[
    Tab(text: 'Start'),
    Tab(text: 'Email'),
    Tab(text: 'Demographics'),
    Tab(text: 'Pictures'),
    Tab(text: 'Biography'),
    Tab(text: 'Location')
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: tabs.length,
        child: Builder(builder: (BuildContext context) {
          final TabController tabController = DefaultTabController.of(context);

          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
            ),
            body: TabBarView(
              children: [
                Start(tabController: tabController),
                Start(tabController: tabController),
                Start(tabController: tabController),
                Start(tabController: tabController),
                Start(tabController: tabController),
                Start(tabController: tabController)
              ],
            ),
          );
        }));
  }
}
