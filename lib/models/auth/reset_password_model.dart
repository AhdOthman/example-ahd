class ResetPasswordModel {
  String? email;
  String? code;
  String? newPassword;

  ResetPasswordModel({this.email, this.code, this.newPassword});

  ResetPasswordModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    code = json['code'];
    newPassword = json['newPassword'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['code'] = this.code;
    data['newPassword'] = this.newPassword;
    return data;
  }
}
