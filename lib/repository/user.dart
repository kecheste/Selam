import 'dart:convert';

import 'package:buyme/entities/user_entity.dart';
import 'package:buyme/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class UserRepository {
  final usersCollection = FirebaseFirestore.instance.collection("Users");

  Future<List> getMatches() async {
    List<MyUser> results = [];
    final prevUser = await usersCollection
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) =>
            MyUser.fromEntity(MyUserEntity.fromDocument(value.data()!)));
    var desiredGender = prevUser.gender == 'Male' ? 'Female' : 'Male';

    try {
      final result = await usersCollection
          .where('gender', isEqualTo: desiredGender)
          .where('photo', isNotEqualTo: "")
          .where(
            'photo',
          )
          .get();
      results = result.docs
          .map((e) => MyUser.fromEntity(MyUserEntity.fromDocument(e.data())))
          .toList();
      return results;
    } catch (e) {
      rethrow;
    }
  }

  Future<List> getMatchesByLocation() async {
    List<MyUser> results = [];
    final prevUser = await usersCollection
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) =>
            MyUser.fromEntity(MyUserEntity.fromDocument(value.data()!)));
    var desiredGender = prevUser.gender == 'Male' ? 'Female' : 'Male';

    try {
      final result = await usersCollection
          .where('gender', isEqualTo: desiredGender)
          .where('photo', isNotEqualTo: "")
          .get();
      final unfiltered = result.docs
          .map((e) => MyUser.fromEntity(MyUserEntity.fromDocument(e.data())))
          .toList();
      results = unfiltered
          .where((element) => element.location! == prevUser.location!)
          .toList();
      return results;
    } catch (e) {
      rethrow;
    }
  }

  sendFavorite(String toUserId) async {
    final currentUserid = FirebaseAuth.instance.currentUser!.uid;
    var document = await usersCollection
        .doc(toUserId)
        .collection("favoritesRecieved")
        .doc(currentUserid)
        .get();
    if (document.exists) {
      // REMOVE Favorite
      await usersCollection
          .doc(toUserId)
          .collection("favoritesRecieved")
          .doc(currentUserid)
          .delete();
      await usersCollection
          .doc(currentUserid)
          .collection("favoritesSent")
          .doc(toUserId)
          .delete();
    } else {
      // ADD Favorite
      await usersCollection
          .doc(toUserId)
          .collection("favoritesRecieved")
          .doc(currentUserid)
          .set({});
      await usersCollection
          .doc(currentUserid)
          .collection("favoritesSent")
          .doc(toUserId)
          .set({});

      // SEND Notification
      sendNotificationToUser(toUserId, "Like", currentUserid);
    }
  }

  sendNotificationToUser(receiverId, featureType, senderId) async {
    String userDeviceToken = "";
    String senderName = "";
    await usersCollection.doc(receiverId).get().then((snapshot) {
      if (snapshot.data()!['fcmToken'] != null) {
        userDeviceToken = snapshot.data()!['fcmToken'].toString();
      }
    });

    await usersCollection.doc(senderId).get().then((snapshot) {
      if (snapshot.data()!['name'] != null) {
        senderName = snapshot.data()!['name'].toString();
      }
    });

    notificationFormat(userDeviceToken, receiverId, featureType, senderName);
  }

  notificationFormat(userDeviceToken, receiverid, featureType, senderName) {
    final currentUserid = FirebaseAuth.instance.currentUser!.uid;

    String serverKey =
        "key=AAAAcXo_SkI:APA91bEL1Vup7ubi89W1o77z2W4Tu-EQXcmpo4D0Wo2B5ocqLlr9ipsrGX5uWSC83hS9qR-ZkeTrAB4Y7bA3qtsDtisWd8XFI2wPamaT_OVMbqfznP1m2A7hCcQZ3H6DGahgBUb5VYdG";
    Map<String, String> headerNotification = {
      "Content-Type": "application/json",
      "Authorization": serverKey
    };

    Map notificationBody = {
      "body": "You have received a new $featureType from $senderName.",
      "title": "New $featureType",
    };

    Map dataMap = {
      "click_action": "FLUTTER_NOTIFICATION_CLICK",
      "id": "1",
      "status": "done",
      "userId": receiverid,
      "senderid": currentUserid,
    };

    Map notificationOfficialFormat = {
      "notification": notificationBody,
      "data": dataMap,
      "priority": "high",
      "to": userDeviceToken,
    };

    http.post(
      Uri.parse("https://fcm.googleapis.com/fcm/send"),
      headers: headerNotification,
      body: jsonEncode(notificationOfficialFormat),
    );
  }

  getFavoriteSenders() async {
    String? myId = FirebaseAuth.instance.currentUser!.uid;
    return usersCollection
        .doc(myId)
        .collection("favoritesRecieved")
        .snapshots();
  }
}
