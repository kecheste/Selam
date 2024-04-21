// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';

import 'package:buyme/models/user_model.dart';
import 'package:buyme/repository/auth.dart';
import 'package:buyme/screens/home_page.dart';
import 'package:buyme/service/utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class UploadPicture extends StatefulWidget {
  UploadPicture({super.key, required this.user});

  MyUser user;

  @override
  State<UploadPicture> createState() => _UploadPictureState();
}

class _UploadPictureState extends State<UploadPicture> {
  Uint8List? image;

  final AuthRepository authRepository = AuthRepository();

  void selectImage() async {
    Uint8List? img = await pickImage(ImageSource.gallery);
    setState(() {
      image = img;
    });
  }

  Widget buttonChild = Text(
    "Upload picture",
    style: TextStyle(
        color: Colors.white, fontWeight: FontWeight.w300, fontSize: 20),
  );

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade900,
        elevation: 0,
        leading: Icon(
          Icons.arrow_back_ios,
          color: Colors.grey.shade900,
        ),
      ),
      body: Container(
        color: Colors.grey.shade900,
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Stack(children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: image != null
                      ? CircleAvatar(
                          radius: 100,
                          backgroundImage: MemoryImage(image!),
                        )
                      : Image.asset(
                          widget.user.photo == ""
                              ? "assets/user1.png"
                              : "assets/2.jpg",
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                        )),
              Positioned(
                  top: 70,
                  left: 70,
                  child: IconButton(
                      onPressed: () {
                        selectImage();
                      },
                      icon: Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.white,
                        size: 45,
                      )))
            ]),
            SizedBox(
              height: 30,
            ),
            Container(
              padding: EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Colors.pink,
                    padding: EdgeInsets.all(12),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                onPressed: () async {
                  String errMessage = "";
                  if (image != null) {
                    setState(() {
                      buttonChild = LoadingAnimationWidget.dotsTriangle(
                          color: Colors.white, size: 20);
                    });
                    try {
                      String url = await authRepository.uploadPicture(
                          image!, widget.user.id);
                      await authRepository.updateProfile(url, widget.user.id);
                    } catch (e) {
                      setState(() {
                        errMessage = e.toString();
                      });
                    } finally {
                      if (errMessage == "") {
                        MyUser updatedUser =
                            await authRepository.getMyUser(widget.user.id);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    HomePage(user: updatedUser)));
                      }
                    }
                    setState(() {
                      buttonChild = Text(
                        "Upload picture",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                            fontSize: 20),
                      );
                    });
                  }
                },
                child: buttonChild,
              ),
            )
          ],
        ),
      ),
    );
  }
}
