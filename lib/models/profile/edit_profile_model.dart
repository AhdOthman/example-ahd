class EditProfileModel {
  String? firstName;
  String? lastName;
  String? birthDate;
  String? phone;
  String? email;
  String? countryId;

  EditProfileModel(
      {this.firstName,
      this.lastName,
      this.birthDate,
      this.phone,
      this.email,
      this.countryId});

  EditProfileModel.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    birthDate = json['birthDate'];
    phone = json['phone'];
    email = json['email'];
    countryId = json['countryId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['birthDate'] = this.birthDate;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['countryId'] = this.countryId;
    return data;
  }
}
