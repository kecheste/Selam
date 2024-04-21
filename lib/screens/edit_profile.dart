// ignore_for_file: use_build_context_synchronously, unused_local_variable

import 'dart:typed_data';

import 'package:buyme/bloc/auth_bloc/auth_bloc.dart';
import 'package:buyme/models/user_model.dart';
import 'package:buyme/repository/auth.dart';
import 'package:buyme/screens/home_page.dart';
import 'package:buyme/service/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class EditProfilePage extends StatefulWidget {
  MyUser user;

  EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final AuthRepository authRepository = AuthRepository();

  Uint8List? image;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _jobController = TextEditingController();

  late List newInterest = widget.user.interestedIn!;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.user.name;
    _bioController.text = widget.user.bio!;
    _ageController.text = widget.user.age!;
    _jobController.text = widget.user.jobTitle!;
  }

  void selectImage() async {
    Uint8List? img = await pickImage(ImageSource.gallery);
    setState(() {
      image = img;
    });
  }

  Widget buttonChild = Text(
    "Save",
    style:
        TextStyle(fontWeight: FontWeight.w400, fontSize: 15, letterSpacing: 1),
  );

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context1, state) {
        if (state is AuthSuccessState) {
          setState(() {
            widget.user = state.user;
          });
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => HomePage(user: state.user)));
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade900,
        appBar: AppBar(
          backgroundColor: Colors.grey.shade900,
          elevation: 0,
          title: Text(
            "Edit Profile",
            style: TextStyle(color: Colors.grey.shade100, fontSize: 30),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            color: Colors.grey.shade900,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          Column(
                            children: [
                              Stack(children: [
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: image != null
                                        ? Image.memory(
                                            image!,
                                            width: 120,
                                            height: 120,
                                            fit: BoxFit.cover,
                                          )
                                        : widget.user.photo == ""
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
                                Positioned(
                                    top: 30,
                                    left: 30,
                                    child: IconButton(
                                        onPressed: () {
                                          selectImage();
                                        },
                                        icon: Icon(
                                          Icons.camera_alt_outlined,
                                          color: Colors.grey.shade50,
                                          size: 50,
                                        )))
                              ]),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Change photo",
                                style: TextStyle(
                                    fontSize: 15, color: Colors.grey.shade300),
                              )
                            ],
                          ),
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
                                height: 5,
                              ),
                              Text(
                                widget.user.location!,
                                style: TextStyle(
                                    fontSize: 15, color: Colors.grey.shade300),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[850],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade700)),
                      padding: EdgeInsets.only(
                          top: 10, bottom: 10, right: 10, left: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Full name',
                            style: TextStyle(
                                color: Colors.grey.shade300, fontSize: 18),
                          ),
                          TextField(
                            style: TextStyle(color: Colors.white, fontSize: 25),
                            controller: _nameController,
                            autocorrect: false,
                            decoration: InputDecoration(
                                hintText: "Edit your name",
                                border: InputBorder.none,
                                fillColor: Colors.white,
                                focusColor: Colors.white,
                                hintStyle: TextStyle(
                                    color: Colors.white, fontSize: 25)),
                          ),
                        ],
                      )),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[850],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade700)),
                      padding: EdgeInsets.only(
                          top: 10, bottom: 10, right: 10, left: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bio',
                            style: TextStyle(
                                color: Colors.grey.shade300, fontSize: 18),
                          ),
                          TextField(
                            style: TextStyle(color: Colors.white, fontSize: 25),
                            maxLines: 3,
                            controller: _bioController,
                            autocorrect: false,
                            decoration: InputDecoration(
                                hintText: "Edit your bio",
                                border: InputBorder.none,
                                hintStyle: TextStyle(color: Colors.white)),
                          ),
                        ],
                      )),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[850],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade700)),
                      padding: EdgeInsets.only(
                          top: 10, bottom: 10, right: 10, left: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Interests',
                            style: TextStyle(
                                color: Colors.grey.shade300, fontSize: 18),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Wrap(
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
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    selected: newInterest.contains(interest),
                                    onSelected: (selected) {
                                      setState(() {
                                        if (selected) {
                                          setState(() {
                                            newInterest.add(interest);
                                          });
                                        } else {
                                          setState(() {
                                            newInterest.remove(interest);
                                          });
                                        }
                                      });
                                    },
                                    backgroundColor: Colors.pink.shade200,
                                    selectedColor: Colors.pink,
                                    elevation: 0,
                                  ),
                              ],
                            ),
                          ),
                        ],
                      )),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[850],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade700)),
                      padding: EdgeInsets.only(
                          top: 10, bottom: 10, right: 10, left: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Job',
                            style: TextStyle(
                                color: Colors.grey.shade300, fontSize: 18),
                          ),
                          TextField(
                            style: TextStyle(color: Colors.white, fontSize: 25),
                            controller: _jobController,
                            autocorrect: false,
                            decoration: InputDecoration(
                                hintText: "Add your Job",
                                border: InputBorder.none,
                                fillColor: Colors.white,
                                focusColor: Colors.white,
                                hintStyle: TextStyle(
                                    color: Colors.white, fontSize: 25)),
                          ),
                        ],
                      )),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Container(
          margin: EdgeInsets.all(8),
          child: ElevatedButton(
              onPressed: () async {
                setState(() {
                  buttonChild = LoadingAnimationWidget.dotsTriangle(
                      color: Colors.white, size: 20);
                });
                if (image != null) {
                  String url = await authRepository.uploadPicture(
                      image!, widget.user.id);
                  await authRepository.updateProfile(url, widget.user.id);
                  await authRepository.updateName(
                      _nameController.text, widget.user.id);
                  await authRepository.updateBio(
                      _bioController.text, widget.user.id);
                  await authRepository.updateInterests(
                      newInterest, widget.user.id);
                  await authRepository.updateJob(
                      _jobController.text, widget.user.id);
                } else {
                  await authRepository.updateName(
                      _nameController.text, widget.user.id);
                  await authRepository.updateBio(
                      _bioController.text, widget.user.id);
                  await authRepository.updateInterests(
                      newInterest, widget.user.id);
                  await authRepository.updateJob(
                      _jobController.text, widget.user.id);
                }
                BlocProvider.of<AuthBloc>(context).add(CheckAuth());
                setState(() {
                  buttonChild = Text(
                    "Save",
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                        letterSpacing: 1),
                  );
                });
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 0,
                backgroundColor: Colors.pink,
                fixedSize: Size(MediaQuery.sizeOf(context).width, 50),
              ),
              child: buttonChild),
        ),
      ),
    );
  }
}
