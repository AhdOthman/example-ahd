class ProfileModel {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? countryId;
  String? phone;
  String? birthDate;
  String? picture;
  Country? country;

  ProfileModel(
      {this.id,
      this.firstName,
      this.lastName,
      this.email,
      this.countryId,
      this.phone,
      this.birthDate,
      this.country});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    countryId = json['countryId'];
    phone = json['phone'];
    birthDate = json['birthDate'];
    picture = json['picture'];
    country =
        json['country'] != null ? new Country.fromJson(json['country']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['email'] = this.email;
    data['countryId'] = this.countryId;
    data['phone'] = this.phone;
    data['birthDate'] = this.birthDate;
    if (this.country != null) {
      data['country'] = this.country!.toJson();
    }
    return data;
  }
}

class Country {
  String? id;
  String? nameAr;

  Country({this.id, this.nameAr});

  Country.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nameAr = json['nameAr'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nameAr'] = this.nameAr;
    return data;
  }
}
