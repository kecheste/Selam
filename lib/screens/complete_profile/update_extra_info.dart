// ignore_for_file: use_build_context_synchronously

import 'package:buyme/models/user_model.dart';
import 'package:buyme/repository/auth.dart';
import 'package:buyme/screens/complete_profile/upload_picture.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class UpdateExtraInfo extends StatefulWidget {
  final MyUser user;

  const UpdateExtraInfo({Key? key, required this.user}) : super(key: key);

  @override
  State<UpdateExtraInfo> createState() => _UpdateExtraInfoState();
}

class _UpdateExtraInfoState extends State<UpdateExtraInfo> {
  final AuthRepository authRepository = AuthRepository();
  String bio = '';
  List<String> interests = [];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget buttonChild = Text(
    "Update info",
    style: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w300,
      fontSize: 20,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Icon(
          Icons.arrow_back_ios,
          color: Colors.grey.shade900,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bio',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade300),
                ),
                SizedBox(height: 5),
                TextFormField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Tell us about yourself',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey.shade400)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey.shade400)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.pink),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  maxLines: 3,
                  onChanged: (value) {
                    setState(() {
                      bio = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your bio';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),
                Text(
                  'Interests',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade300),
                ),
                SizedBox(height: 5),
                Wrap(
                  spacing: 10,
                  children: [
                    for (String interest in [
                      'Travel',
                      'Food',
                      'Movies',
                      'Music',
                      'Sports',
                      'Hiking',
                      'Gym',
                      'Yoga',
                      'Fashion',
                      'Games',
                      'Culture',
                      'Love',
                      'Romance'
                    ])
                      ChoiceChip(
                        label: Text(
                          interest,
                        ),
                        selected: interests.contains(interest),
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              interests.add(interest);
                            } else {
                              interests.remove(interest);
                            }
                          });
                        },
                        backgroundColor: Colors.pink.shade100,
                        selectedColor: Colors.pinkAccent,
                        elevation: 3,
                      ),
                  ],
                ),
                SizedBox(height: 30),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    onPressed: () async {
                      String errorMessage = "";
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          buttonChild = LoadingAnimationWidget.dotsTriangle(
                              color: Colors.white, size: 20);
                        });
                        try {
                          await authRepository.updateBio(bio, widget.user.id);
                          await authRepository.updateInterests(
                              interests, widget.user.id);
                        } catch (e) {
                          setState(() {
                            errorMessage = e.toString();
                            print(errorMessage);
                          });
                        } finally {
                          if (errorMessage == "") {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        UploadPicture(user: widget.user)));
                          }
                        }

                        setState(() {
                          buttonChild = Text(
                            "Update info",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w300,
                                fontSize: 20),
                          );
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      primary: Colors.pink,
                    ),
                    child: buttonChild,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
