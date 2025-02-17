class SignupModelRequest {
  String? email;
  String? password;
  String? firstName;
  String? lastName;
  String? birthDate;
  String? phone;
  String? countryId;
  String? countryCode;
  String? nationalNumber;

  SignupModelRequest(
      {this.email,
      this.password,
      this.firstName,
      this.lastName,
      this.birthDate,
      this.phone,
      this.countryId,
      this.countryCode,
      this.nationalNumber});

  SignupModelRequest.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    password = json['password'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    birthDate = json['birthDate'];
    phone = json['phone'];
    countryId = json['countryId'];
    countryCode = json['countryCode'];
    nationalNumber = json['national_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['password'] = this.password;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['birthDate'] = this.birthDate;
    data['phone'] = this.phone;
    data['countryId'] = this.countryId;
    data['countryCode'] = this.countryCode;
    data['nationalNumber'] = this.nationalNumber;
    return data;
  }
}
