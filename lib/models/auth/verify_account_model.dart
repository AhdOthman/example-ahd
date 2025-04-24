class VerifyAccountModel {
  String? identifier;
  String? code;

  VerifyAccountModel({this.identifier, this.code});

  VerifyAccountModel.fromJson(Map<String, dynamic> json) {
    identifier = json['identifier'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['identifier'] = this.identifier;
    data['code'] = this.code;
    return data;
  }
}
