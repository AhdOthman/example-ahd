class SocialLoginResponseModel {
  String? token;
  User? user;
  String? message;

  SocialLoginResponseModel({this.token, this.user, this.message});

  SocialLoginResponseModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class User {
  String? id;
  String? email;
  String? username;
  String? role;
  String? mfa;

  User({this.id, this.email, this.username, this.role, this.mfa});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    username = json['username'];
    role = json['role'];
    mfa = json['mfa'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['username'] = this.username;
    data['role'] = this.role;
    data['mfa'] = this.mfa;
    return data;
  }
}
