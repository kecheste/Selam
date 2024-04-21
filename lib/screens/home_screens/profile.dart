// ignore_for_file: must_be_immutable

import 'package:buyme/bloc/auth_bloc/auth_bloc.dart';
import 'package:buyme/models/user_model.dart';
import 'package:buyme/screens/edit_profile.dart';
import 'package:buyme/screens/login.dart';
import 'package:buyme/screens/my_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ProfilePage extends StatefulWidget {
  MyUser user;

  ProfilePage({super.key, required this.user});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Widget buttonChild = Text(
    "Log out",
    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
  );
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade900,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                SizedBox(
                  height: 5,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  decoration: BoxDecoration(
                      color: Colors.grey[850],
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: widget.user.photo == ""
                              ? Image.asset(
                                  "assets/user.jpg",
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                )
                              : Image.network(
                                  widget.user.photo!,
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                )),
                      SizedBox(
                        width: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.user.name,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 20),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            widget.user.location!,
                            style: TextStyle(
                                fontSize: 15, color: Colors.grey.shade200),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey[850],
                    padding: const EdgeInsets.all(20),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    backgroundColor: Colors.grey[850],
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                MyProfilePage(user: widget.user)));
                  },
                  child: Row(
                    children: const [
                      Icon(
                        Icons.person,
                        size: 25,
                        color: Colors.pinkAccent,
                      ),
                      SizedBox(width: 20),
                      Expanded(
                          child: Text(
                        "My profile",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      )),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 25,
                        color: Colors.pinkAccent,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey[850],
                    padding: const EdgeInsets.all(20),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    backgroundColor: Colors.grey[850],
                  ),
                  onPressed: () async {
                    final updatedUser = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                EditProfilePage(user: widget.user)));
                    if (updatedUser != null) {
                      setState(() {
                        widget.user = updatedUser;
                      });
                    }
                  },
                  child: Row(
                    children: const [
                      Icon(
                        Icons.edit_document,
                        size: 25,
                        color: Colors.pinkAccent,
                      ),
                      SizedBox(width: 20),
                      Expanded(
                          child: Text(
                        "Edit profile",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      )),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 25,
                        color: Colors.pinkAccent,
                      ),
                    ],
                  ),
                )
              ],
            ),
            BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthLoggedOutState) {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                }
              },
              builder: (context, state) {
                return Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          buttonChild = LoadingAnimationWidget.dotsTriangle(
                              color: Colors.white, size: 20);
                        });
                        BlocProvider.of<AuthBloc>(context).add(SignOutUser());
                        setState(() {
                          buttonChild = LoadingAnimationWidget.dotsTriangle(
                              color: Colors.white, size: 20);
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        elevation: 0,
                        backgroundColor: Colors.pink[600],
                        fixedSize: Size(MediaQuery.sizeOf(context).width, 55),
                      ),
                      child: buttonChild),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
