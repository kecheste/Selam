// ignore_for_file: unnecessary_null_comparison

import 'dart:typed_data';

import 'package:buyme/entities/user_entity.dart';
import 'package:buyme/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:xid/xid.dart';

class AuthRepository {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final usersCollection = FirebaseFirestore.instance.collection("Users");

  Stream<User?> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      final user = firebaseUser;
      return user;
    });
  }

  static String verifyId = "";

  Future sendOtp(
      {required String phone,
      required Function errorStep,
      required Function nextStep}) async {
    await _firebaseAuth
        .verifyPhoneNumber(
      timeout: const Duration(seconds: 120),
      phoneNumber: phone,
      verificationCompleted: (phoneAuthCredential) async {
        return;
      },
      verificationFailed: (error) async {
        return;
      },
      codeSent: (verificationId, forceResendingToken) async {
        verifyId = verificationId;
        nextStep();
      },
      codeAutoRetrievalTimeout: (verificationId) async {
        return;
      },
    )
        .onError((error, stackTrace) {
      errorStep();
    });
  }

  Future loginWithOtp({required String otp, required String phone}) async {
    final PhoneAuthCredential credential =
        PhoneAuthProvider.credential(verificationId: verifyId, smsCode: otp);
    try {
      final user = await _firebaseAuth.signInWithCredential(credential);
      if (user != null) {
        final checkUserFound = await usersCollection.doc(user.user!.uid).get();
        if (!checkUserFound.exists) {
          MyUser addedUser = MyUser(
            id: user.user!.uid,
            phone: phone,
            name: "",
            gender: "",
            bio: "",
            age: "",
            photo: "",
            interestedIn: const [],
            createdAt: Timestamp.now(),
            location: "",
            jobTitle: "",
            isOnline: false,
          );
          await usersCollection
              .doc(user.user!.uid)
              .set(addedUser.toEntity().toDocument());
          return addedUser;
        } else {
          final MyUser existingUser = await getMyUser(user.user!.uid);
          return existingUser;
        }
      }
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<MyUser> getMyUser(String myUserId) async {
    try {
      return usersCollection.doc(myUserId).get().then((value) =>
          MyUser.fromEntity(MyUserEntity.fromDocument(value.data()!)));
    } catch (e) {
      rethrow;
    }
  }

  Future<String> uploadPicture(Uint8List file, String userId) async {
    try {
      Xid xid = Xid();
      Reference firebaseStoreRef = FirebaseStorage.instance
          .ref()
          .child('$userId/PP/${xid.toString()}_lead');
      await firebaseStoreRef.putData(file);
      String url = await firebaseStoreRef.getDownloadURL();
      return url;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateProfile(String url, String userId) async {
    try {
      String currentUserid = FirebaseAuth.instance.currentUser!.uid;
      if (currentUserid == userId) {
        await usersCollection.doc(userId).update({'photo': url});
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateName(String name, String userId) async {
    try {
      String currentUserid = FirebaseAuth.instance.currentUser!.uid;
      if (currentUserid == userId) {
        await usersCollection.doc(userId).update({'name': name});
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateGender(String gender, String userId) async {
    try {
      String currentUserid = FirebaseAuth.instance.currentUser!.uid;
      if (currentUserid == userId) {
        await usersCollection.doc(userId).update({'gender': gender});
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateAge(String age, String userId) async {
    try {
      String currentUserid = FirebaseAuth.instance.currentUser!.uid;
      if (currentUserid == userId) {
        await usersCollection.doc(userId).update({'age': age});
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateBio(String bio, String userId) async {
    try {
      String currentUserid = FirebaseAuth.instance.currentUser!.uid;
      if (currentUserid == userId) {
        await usersCollection.doc(userId).update({'bio': bio});
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateLocation(String place, String userId) async {
    try {
      String currentUserid = FirebaseAuth.instance.currentUser!.uid;
      if (currentUserid == userId) {
        await usersCollection.doc(userId).update({'location': place});
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateJob(String job, String userId) async {
    try {
      String currentUserid = FirebaseAuth.instance.currentUser!.uid;
      if (currentUserid == userId) {
        await usersCollection.doc(userId).update({'jobTitle': job});
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateStatus(bool status, String userId) async {
    try {
      String currentUserId = FirebaseAuth.instance.currentUser!.uid;
      if (currentUserId == userId) {
        await usersCollection.doc(userId).update({'isOnline': status});
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateInterests(List interests, String userId) async {
    try {
      String currentUserid = FirebaseAuth.instance.currentUser!.uid;
      if (currentUserid == userId) {
        await usersCollection.doc(userId).update({'interestedIn': interests});
      }
    } catch (e) {
      rethrow;
    }
  }
}
