class KYCRequestModel {
  String? fullName;
  String? dateOfBirth;
  String? cardHolderId;
  String? cardType;
  String? cardImage;
  String? countryId;
  String? address;

  KYCRequestModel(
      {this.fullName,
      this.dateOfBirth,
      this.cardHolderId,
      this.cardType,
      this.cardImage,
      this.countryId,
      this.address});

  KYCRequestModel.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName'];
    dateOfBirth = json['dateOfBirth'];
    cardHolderId = json['cardHolderId'];
    cardType = json['cardType'];
    cardImage = json['cardImage'];
    countryId = json['countryId'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fullName'] = this.fullName;
    data['dateOfBirth'] = this.dateOfBirth;
    data['cardHolderId'] = this.cardHolderId;
    data['cardType'] = this.cardType;
    data['cardImage'] = this.cardImage;
    data['countryId'] = this.countryId;
    data['address'] = this.address;
    return data;
  }
}
