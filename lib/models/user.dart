
class User {
  String? profile_Picture;
  String? user_name;
  String? email;
  String? uid;

  User({
    this.profile_Picture,
    this.user_name,
    this.email,
    this.uid,
  });
 
  
  User.fromJson(Map<String, dynamic> data) {
    profile_Picture = data['profile_Picture'];
    user_name = data['user_name'];
    email = data['email'];
    uid = data['uid'];
  }

   Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['profile_Picture'] = profile_Picture;
    data['user_name'] = user_name;
    data['email'] = email;
    data['uid'] = uid;
    return data;
  }

}

