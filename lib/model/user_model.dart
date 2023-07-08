



import 'package:cloud_firestore/cloud_firestore.dart';

class userCollectionFields{
  static const String userId='User Id';
  static const String userName = 'User Name';
  static const String userEmail = 'User Email';
  static const String userPassword = 'User Password';
  static const String signinType="Signin Type";
}

class UserCollectionModel{
  String userId;
  String userName;
  String userEmail;
  String userPassword;
  String signinType;

  UserCollectionModel({
    required this.userId,
  required this.userName,
    required this.userEmail,
    required this.userPassword,
    required this.signinType
  });

  Map<String, dynamic> toJson() {
    return {
      userCollectionFields.userId:userId,
    userCollectionFields.userName: userName,
    userCollectionFields.userEmail: userEmail,
    userCollectionFields.userPassword: userPassword,
      userCollectionFields.signinType:signinType
    };
  }

  factory UserCollectionModel.fromJson(DocumentSnapshot json)=>UserCollectionModel(
    userId: json[userCollectionFields.userId],
      userName: json[userCollectionFields.userName],
      userEmail: json[userCollectionFields.userEmail],
      userPassword: json[userCollectionFields.userPassword],
    signinType: json[userCollectionFields.signinType]
  );
}