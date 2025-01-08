class GetCountryList {
  String? id;
  String? nameEn;
  String? nameAr;

  GetCountryList({this.id, this.nameEn, this.nameAr});

  GetCountryList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nameEn = json['nameEn'];
    nameAr = json['nameAr'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['id'] = this.id;
    data['nameEn'] = this.nameEn;
    data['nameAr'] = this.nameAr;
    return data;
  }
}
