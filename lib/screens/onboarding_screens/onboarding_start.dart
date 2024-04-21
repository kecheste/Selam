import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Start extends StatelessWidget {
  final TabController tabController;

  const Start({
    Key? key,
    required this.tabController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              SizedBox(
                height: 300,
                width: 300,
                child: SvgPicture.asset(
                  'assets/couple.svg',
                ),
              ),
              SizedBox(height: 5),
              Text('Welcome to SELAM',
                  style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 114, 116, 121))),
              SizedBox(height: 10),
              Text(
                'A place where you can find your soulmate.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  padding: EdgeInsets.symmetric(vertical: 10)),
              onPressed: () => {
                    if (tabController.index == 5)
                      {Navigator.pushNamed(context, "/")}
                    else
                      {Navigator.pushNamed(context, '/login')}
                    // {tabController.animateTo(tabController.index + 1)}
                  },
              child: SizedBox(
                width: double.infinity,
                child: Center(
                  child: Text(
                    'Start',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
