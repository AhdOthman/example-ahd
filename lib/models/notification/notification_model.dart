class NotificationModel {
  String? id;
  Payload? payload;
  String? category;
  String? createdAt;

  NotificationModel({this.id, this.payload, this.category, this.createdAt});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    payload =
        json['payload'] != null ? new Payload.fromJson(json['payload']) : null;
    category = json['category'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.payload != null) {
      data['payload'] = this.payload!.toJson();
    }
    data['category'] = this.category;
    data['createdAt'] = this.createdAt;
    return data;
  }
}

class Payload {
  String? tenantName;
  String? invitationId;

  Payload({this.tenantName, this.invitationId});

  Payload.fromJson(Map<String, dynamic> json) {
    tenantName = json['tenantName'];
    invitationId = json['invitationId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tenantName'] = this.tenantName;
    data['invitationId'] = this.invitationId;
    return data;
  }
}
