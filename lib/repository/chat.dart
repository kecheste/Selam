import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:xid/xid.dart';
import 'package:http/http.dart' as http;

class ChatRepository {
  final chatCollection = FirebaseFirestore.instance.collection("ChatRooms");
  final usersCollection = FirebaseFirestore.instance.collection("Users");

  createChatRoom(
      String chatRoomId, Map<String, dynamic> chatRoomInfoMap) async {
    final snapshot = await chatCollection.doc(chatRoomId).get();
    if (snapshot.exists) {
      return true;
    } else {
      return chatCollection.doc(chatRoomId).set(chatRoomInfoMap);
    }
  }

  sendMessage(
      String chatRoomId, Map<String, dynamic> messageInfoMap, String toUserId) {
    String messageId = Xid().toString();
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    try {
      return chatCollection
          .doc(chatRoomId)
          .collection("chats")
          .doc(messageId)
          .set(messageInfoMap);
    } catch (e) {
      print(e.toString());
    } finally {
      // SEND NOTIFICATION
      sendNotificationToUser(toUserId, "message", currentUserId);
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

  updateLastMessageSent(
      String chatRoomId, Map<String, dynamic> lastMessageInfoMap) {
    return chatCollection.doc(chatRoomId).update(lastMessageInfoMap);
  }

  Future<Stream<QuerySnapshot>> getChatMessages(chatRoomId) async {
    return chatCollection
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("sentDate", descending: true)
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getChatRooms() async {
    String? myId = FirebaseAuth.instance.currentUser!.uid;
    return chatCollection
        .orderBy("dateSent", descending: true)
        .where("users", arrayContains: myId)
        .snapshots();
  }
}
