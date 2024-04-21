// ignore_for_file: sized_box_for_whitespace

import 'package:buyme/bloc/auth_bloc/auth_bloc.dart';
import 'package:buyme/helper/keyboard.dart';
import 'package:buyme/screens/onboarding_screens/otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Widget buttonChild = Text(
    "LOGIN",
    style: TextStyle(
        color: Colors.white, fontSize: 20, fontWeight: FontWeight.w400),
  );
  String errorMsg = '';

  final List<String?> errors = [];

  void addError({String? error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({String? error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  String countryCode = "";
  bool isPhoneValidated = false;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.only(top: 30, right: 20, left: 20),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                              width: 140,
                              height: 140,
                              child: Image.asset('assets/logo.png')),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            "Welcome Back",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Sign in to continue",
                            style: TextStyle(
                                color: Colors.grey[300], fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                    IntlPhoneField(
                      dropdownIcon: Icon(
                        Icons.arrow_drop_down,
                        color: Colors.white,
                      ),
                      dropdownTextStyle: TextStyle(color: Colors.white),
                      keyboardType: TextInputType.phone,
                      initialCountryCode: 'ET',
                      disableLengthCheck: true,
                      cursorColor: Colors.white,
                      onChanged: (value) {
                        if (value.number.isNotEmpty) {
                          setState(() {
                            countryCode = value.countryCode;
                            print(countryCode);
                          });
                          removeError(error: "Phone number not entered");
                        }
                      },
                      validator: (value) {
                        if (value!.number == "") {
                          setState(() {
                            isPhoneValidated = false;
                          });
                        } else {
                          setState(() {
                            isPhoneValidated = true;
                          });
                        }
                      },
                      controller: _phoneController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          focusColor: Colors.grey.shade300,
                          fillColor: Colors.grey[850],
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey.shade700)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: isPhoneValidated
                                      ? Colors.grey.shade300
                                      : Colors.grey.shade300)),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: isPhoneValidated
                                      ? Colors.grey.shade300
                                      : Colors.grey.shade300)),
                          hintText: '000-000-0000',
                          hintStyle: TextStyle(
                              color: Colors.grey[500],
                              fontWeight: FontWeight.w300)),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink),
                      onPressed: () {
                        if (isPhoneValidated) {
                          _formKey.currentState!.save();
                          KeyboardUtil.hideKeyboard(context);
                          BlocProvider.of<AuthBloc>(context).add(
                              SendOtp(countryCode + _phoneController.text, () {
                            Navigator.pop(context);
                          }, () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => OtpScreen(
                                    phone:
                                        countryCode + _phoneController.text)));
                            setState(() {
                              buttonChild = Text(
                                "LOGIN",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400),
                              );
                            });
                          }));
                          setState(() {
                            buttonChild =
                                LoadingAnimationWidget.prograssiveDots(
                              color: Colors.white,
                              size: 20,
                            );
                          });
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Center(
                          child: buttonChild,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
