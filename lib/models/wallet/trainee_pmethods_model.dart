class TraineePaymentMethodModel {
  String? id;
  String? name;
  bool isClicked = false;

  TraineePaymentMethodModel({this.id, this.name});

  TraineePaymentMethodModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    isClicked = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
