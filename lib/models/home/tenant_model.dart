class TenantModel {
  String? createdAt;
  String? updatedAt;
  String? tenantId;
  String? traineeId;
  Tenant? tenant;
  bool isSelected = false;

  TenantModel(
      {this.createdAt,
      this.updatedAt,
      this.tenantId,
      this.traineeId,
      this.tenant});

  TenantModel.fromJson(Map<String, dynamic> json) {
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    tenantId = json['tenantId'];
    traineeId = json['traineeId'];
    tenant =
        json['tenant'] != null ? new Tenant.fromJson(json['tenant']) : null;
    isSelected = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['tenantId'] = this.tenantId;
    data['traineeId'] = this.traineeId;
    if (this.tenant != null) {
      data['tenant'] = this.tenant!.toJson();
    }
    return data;
  }
}

class Tenant {
  String? id;
  String? fullName;

  Tenant({this.id, this.fullName});

  Tenant.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['fullName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fullName'] = this.fullName;
    return data;
  }
}
