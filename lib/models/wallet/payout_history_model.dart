class PayoutHistoryModel {
  String? id;
  int? points;
  String? status;
  String? createdAt;

  PayoutHistoryModel({this.id, this.points, this.status, this.createdAt});

  PayoutHistoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    points = json['points'];
    status = json['status'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['points'] = this.points;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    return data;
  }
}
