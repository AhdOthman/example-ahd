class GetAllAccountsForPaymentMethod {
  String? id;
  bool? isDefault;
  bool? isClicked;
  Method? method;
  Details? details;

  GetAllAccountsForPaymentMethod(
      {this.id, this.isDefault, this.method, this.details});

  GetAllAccountsForPaymentMethod.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isDefault = json['isDefault'];
    method =
        json['method'] != null ? new Method.fromJson(json['method']) : null;
    details =
        json['details'] != null ? new Details.fromJson(json['details']) : null;
    isClicked = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['isDefault'] = this.isDefault;
    if (this.method != null) {
      data['method'] = this.method!.toJson();
    }
    if (this.details != null) {
      data['details'] = this.details!.toJson();
    }
    return data;
  }
}

class Method {
  String? id;
  String? name;
  String? image;

  Method({this.id, this.name, this.image});

  Method.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    return data;
  }
}

class Details {
  String? iBAN;
  String? email;
  String? fullName;

  Details({this.iBAN, this.email, this.fullName});

  Details.fromJson(Map<String, dynamic> json) {
    iBAN = json['IBAN'];
    email = json['email'];
    fullName = json['full Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IBAN'] = this.iBAN;
    data['email'] = this.email;
    data['full Name'] = this.fullName;
    return data;
  }
}
