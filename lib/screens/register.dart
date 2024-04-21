// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:buyme/bloc/auth_bloc/auth_bloc.dart';
import 'package:buyme/models/user_model.dart';
import 'package:buyme/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String buttonText = "SIGNUP";
  String genderValue = 'Male';
  String errMsg = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: ListView(children: [
        Padding(
          padding: const EdgeInsets.only(top: 40, right: 20, left: 20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 2,
                ),
                Container(
                    width: 150,
                    height: 150,
                    child: Image.asset('assets/logo.png')),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Welcome Here",
                  style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 40,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "Sign up to join",
                  style: TextStyle(color: Colors.grey[600], fontSize: 18),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  width: MediaQuery.sizeOf(context).width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                          color: const Color.fromARGB(255, 240, 240, 240))),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.mail,
                          size: 25,
                          color: Colors.pink,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: MediaQuery.sizeOf(context).width * 0.6,
                              child: TextField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                    fillColor: Colors.pink,
                                    border: InputBorder.none,
                                    hintText: 'email@gmail.com',
                                    hintStyle: TextStyle(
                                        color: Colors.pink[200],
                                        fontWeight: FontWeight.w300)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  width: MediaQuery.sizeOf(context).width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                          color: const Color.fromARGB(255, 240, 240, 240))),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person,
                          size: 25,
                          color: Colors.pink,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: MediaQuery.sizeOf(context).width * 0.6,
                              child: TextField(
                                controller: _nameController,
                                decoration: InputDecoration(
                                    fillColor: Colors.pink,
                                    border: InputBorder.none,
                                    hintText: 'John Doe',
                                    hintStyle: TextStyle(
                                        color: Colors.pink[200],
                                        fontWeight: FontWeight.w300)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  width: MediaQuery.sizeOf(context).width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                          color: const Color.fromARGB(255, 240, 240, 240))),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.lock,
                          size: 25,
                          color: Colors.pink,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: MediaQuery.sizeOf(context).width * 0.6,
                              child: TextField(
                                obscureText: true,
                                controller: _passwordController,
                                decoration: InputDecoration(
                                    fillColor: Colors.pink,
                                    border: InputBorder.none,
                                    hintText: 'password',
                                    hintStyle: TextStyle(
                                        color: Colors.pink[200],
                                        fontWeight: FontWeight.w300)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  width: MediaQuery.sizeOf(context).width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                          color: const Color.fromARGB(255, 240, 240, 240))),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.male,
                          size: 25,
                          color: Colors.pink,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                                width: MediaQuery.sizeOf(context).width * 0.6,
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    value: genderValue,
                                    elevation: 2,
                                    icon: Icon(Icons.keyboard_arrow_down),
                                    borderRadius: BorderRadius.circular(10),
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.pink.shade400,
                                        fontWeight: FontWeight.w300),
                                    items: [
                                      DropdownMenuItem(
                                        value: 'Male',
                                        child: Text('Male'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'Female',
                                        child: Text('Female'),
                                      )
                                    ],
                                    dropdownColor: Colors.white,
                                    onChanged: (String? gender) {
                                      setState(() {
                                        genderValue = gender!;
                                      });
                                    },
                                  ),
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // Text(
                //   errorMessage == '' ? '' : '$errorMessage',
                //   style: TextStyle(
                //       color: Colors.red,
                //       fontWeight: FontWeight.w400,
                //       fontStyle: FontStyle.italic),
                // ),
                SizedBox(
                  height: 20,
                ),

                BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthSuccessState) {
                      setState(() {
                        buttonText = "SIGNUP";
                        errMsg = '';
                      });
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomePage(
                              user: state.user,
                            ),
                          ));
                    } else if (state is AuthFailureState) {
                      errMsg = state.errorMessage;
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: FittedBox(
                                fit: BoxFit.contain,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Icon(
                                      Icons.error_outline,
                                      color: Colors.red,
                                      size: 50,
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      'Error!',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      errMsg.split(']')[1],
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                      setState(() {
                        buttonText = "SIGNUP";
                      });
                    }
                  },
                  builder: (context, state) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink),
                      onPressed: () {
                        MyUser myUser = MyUser.empty;
                        myUser = myUser.copyWith(
                            phone: _emailController.text,
                            name: _nameController.text,
                            gender: genderValue);

                        setState(() {
                          buttonText = "....";
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)),
                        width: MediaQuery.sizeOf(context).width,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Center(
                            child: Text(
                              buttonText,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text('Already have account? '),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    child: Text(
                      'Login Here',
                      style: TextStyle(
                          color: Colors.pink, fontWeight: FontWeight.w500),
                    ),
                  )
                ]),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
