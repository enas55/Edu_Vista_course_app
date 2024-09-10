class User {
  String? profile_Picture;
  String? user_name;
  String? email;

  User.fromJson(Map<String, dynamic> data) {
    profile_Picture = data['profile_Picture'];
    user_name = data['user_name'];
    email = data['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['profile_Picture'] = profile_Picture;
    data['user_name'] = user_name;
    data['email'] = email;
    return data;
  }
}
