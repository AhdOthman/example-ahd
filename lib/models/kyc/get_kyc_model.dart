class GetKYCModel {
  KycDetails? kycDetails;
  Statuses? statuses;

  GetKYCModel({this.kycDetails, this.statuses});

  GetKYCModel.fromJson(Map<String, dynamic> json) {
    kycDetails = json['kycDetails'] != null
        ? new KycDetails.fromJson(json['kycDetails'])
        : null;
    statuses = json['statuses'] != null
        ? new Statuses.fromJson(json['statuses'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.kycDetails != null) {
      data['kycDetails'] = this.kycDetails!.toJson();
    }
    if (this.statuses != null) {
      data['statuses'] = this.statuses!.toJson();
    }
    return data;
  }
}

class KycDetails {
  String? id;
  String? cardImage;
  String? requestNumber;
  String? fullName;
  String? dateOfBirth;
  String? cardHolderId;
  String? cardType;
  String? status;

  KycDetails(
      {this.id,
      this.cardImage,
      this.requestNumber,
      this.fullName,
      this.dateOfBirth,
      this.cardHolderId,
      this.cardType,
      this.status});

  KycDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cardImage = json['cardImage'];
    requestNumber = json['requestNumber'];
    fullName = json['fullName'];
    dateOfBirth = json['dateOfBirth'];
    cardHolderId = json['cardHolderId'];
    cardType = json['cardType'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['cardImage'] = this.cardImage;
    data['requestNumber'] = this.requestNumber;
    data['fullName'] = this.fullName;
    data['dateOfBirth'] = this.dateOfBirth;
    data['cardHolderId'] = this.cardHolderId;
    data['cardType'] = this.cardType;
    data['status'] = this.status;
    return data;
  }
}

class Statuses {
  String? pending;
  String? unverified;
  String? verified;
  String? rejected;

  Statuses({this.pending, this.unverified, this.verified, this.rejected});

  Statuses.fromJson(Map<String, dynamic> json) {
    pending = json['PENDING'];
    unverified = json['UNVERIFIED'];
    verified = json['VERIFIED'];
    rejected = json['REJECTED'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PENDING'] = this.pending;
    data['UNVERIFIED'] = this.unverified;
    data['VERIFIED'] = this.verified;
    data['REJECTED'] = this.rejected;
    return data;
  }
}
