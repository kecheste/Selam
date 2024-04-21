import 'package:buyme/entities/user_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class MyUser extends Equatable {
  final String id;
  final String phone;
  final String name;
  final String? age;
  final String? bio;
  final String? gender;
  final String? photo;
  final List<dynamic>? interestedIn;
  final Timestamp createdAt;
  final String? location;
  final String? jobTitle;
  final bool? isOnline;

  const MyUser(
      {required this.id,
      required this.phone,
      required this.name,
      required this.gender,
      required this.bio,
      required this.age,
      required this.photo,
      required this.interestedIn,
      required this.createdAt,
      required this.location,
      required this.jobTitle,
      required this.isOnline});

  toJson() {
    return {
      'id': id,
      'phone': phone,
      'name': name,
      'gender': gender,
      'bio': bio,
      'age': age,
      'photo': photo,
      'interestedIn': interestedIn,
      'createdAt': createdAt,
      'location': location,
      'jobTitle': jobTitle,
      'status': isOnline
    };
  }

  static final empty = MyUser(
      id: "",
      phone: "",
      name: "",
      photo: "",
      gender: "",
      bio: "",
      age: "",
      interestedIn: [],
      createdAt: Timestamp.now(),
      location: "",
      jobTitle: "",
      isOnline: false);

  MyUser copyWith(
      {String? id,
      String? phone,
      String? name,
      String? photo,
      String? age,
      String? gender,
      String? bio,
      List<dynamic>? interestedIn,
      Timestamp? createdAt,
      String? location,
      String? jobTitle,
      bool? isOnline}) {
    return MyUser(
        id: id ?? this.id,
        phone: phone ?? this.phone,
        name: name ?? this.name,
        age: age ?? this.age,
        gender: gender ?? this.gender,
        bio: bio ?? this.bio,
        photo: photo ?? this.photo,
        interestedIn: interestedIn ?? this.interestedIn,
        createdAt: createdAt ?? this.createdAt,
        location: location ?? this.location,
        jobTitle: jobTitle ?? this.jobTitle,
        isOnline: isOnline ?? this.isOnline);
  }

  bool get isEmpty => this == MyUser.empty;
  bool get isNotEmpty => this != MyUser.empty;

  MyUserEntity toEntity() {
    return MyUserEntity(
        id: id,
        phone: phone,
        name: name,
        age: age,
        gender: gender,
        bio: bio,
        photo: photo,
        interestedIn: interestedIn,
        createdAt: createdAt,
        location: location,
        jobTitle: jobTitle,
        isOnline: isOnline);
  }

  static MyUser fromEntity(MyUserEntity entity) {
    return MyUser(
        id: entity.id,
        phone: entity.phone,
        name: entity.name,
        age: entity.age,
        gender: entity.gender,
        bio: entity.bio,
        photo: entity.photo,
        interestedIn: entity.interestedIn,
        createdAt: entity.createdAt,
        location: entity.location,
        jobTitle: entity.jobTitle,
        isOnline: entity.isOnline);
  }

  @override
  List<Object?> get props => [
        id,
        name,
        age,
        gender,
        phone,
        bio,
        photo,
        interestedIn,
        createdAt,
        location,
        jobTitle,
        isOnline
      ];
}
