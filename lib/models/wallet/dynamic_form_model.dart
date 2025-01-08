class DynamicFormModel {
  String? createdAt;
  String? updatedAt;
  String? id;
  String? name;
  String? type;
  bool? isRequired;
  bool? isActivated;
  String? payoutMethodId;
  var value;

  DynamicFormModel(
      {this.createdAt,
      this.updatedAt,
      this.id,
      this.name,
      this.type,
      this.isRequired,
      this.isActivated,
      this.payoutMethodId,
      this.value});

  DynamicFormModel.fromJson(Map<String, dynamic> json) {
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    id = json['id'];
    name = json['name'];
    type = json['type'];
    isRequired = json['isRequired'];
    isActivated = json['isActivated'];
    payoutMethodId = json['payoutMethodId'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['id'] = this.id;
    data['name'] = this.name;
    data['type'] = this.type;
    data['isRequired'] = this.isRequired;
    data['isActivated'] = this.isActivated;
    data['payoutMethodId'] = this.payoutMethodId;
    data['value'] = this.value;
    return data;
  }
}
