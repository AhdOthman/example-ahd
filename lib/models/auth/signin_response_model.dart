class LoginResponseModel {
  String? token;
  User? user;
  UserMoreInfo? userMoreInfo;
  String? message;

  LoginResponseModel({this.token, this.user, this.userMoreInfo, this.message});

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    userMoreInfo = json['userMoreInfo'] != null
        ? new UserMoreInfo.fromJson(json['userMoreInfo'])
        : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.userMoreInfo != null) {
      data['userMoreInfo'] = this.userMoreInfo!.toJson();
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
  String? phone;

  User({this.id, this.email, this.username, this.role, this.mfa, this.phone});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    username = json['username'];
    role = json['role'];
    mfa = json['mfa'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['username'] = this.username;
    data['role'] = this.role;
    data['mfa'] = this.mfa;
    data['phone'] = this.phone;
    return data;
  }
}

class UserMoreInfo {
  String? id;
  String? fullName;
  String? picture;

  UserMoreInfo({this.id, this.fullName, this.picture});

  UserMoreInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['fullName'];
    picture = json['picture'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fullName'] = this.fullName;
    data['picture'] = this.picture;
    return data;
  }
}
