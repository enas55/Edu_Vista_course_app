import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String? profile_Picture;
  String? user_name;
  String? email;
  String? uid;


  User({
    required this.uid,
    required this.user_name,
    required this.email,
    this.profile_Picture,
  });

  // Convert the UserModel to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': user_name,
      'email': email,
      'profilePictureUrl': profile_Picture,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
  
  User.fromJson(Map<String, dynamic> data) {
    profile_Picture = data['profile_Picture'];
    user_name = data['user_name'];
    email = data['email'];
    uid = data['uid'];
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = <String, dynamic>{};
  //   data['profile_Picture'] = profile_Picture;
  //   data['user_name'] = user_name;
  //   data['email'] = email;
  //   data['uid'] = uid;
  //   return data;
  // }
}
