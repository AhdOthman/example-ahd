// class PayoutMethodModel {
//   // String? payoutMethodId;
//   PayoutMethod? payoutMethod;
//   bool isClicked = false;

//   PayoutMethodModel({ this.payoutMethod});

//   PayoutMethodModel.fromJson(Map<String, dynamic> json) {
//     // payoutMethodId = json['payoutMethodId'];
//     payoutMethod = json['payoutMethod'] != null
//         ? new PayoutMethod.fromJson(json['payoutMethod'])
//         : null;
//     isClicked = false;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     // data['payoutMethodId'] = this.payoutMethodId;
//     if (this.payoutMethod != null) {
//       data['payoutMethod'] = this.payoutMethod!.toJson();
//     }
//     return data;
//   }
// }

class PayoutMethodModel {
  String? id;
  String? name;
  String? image;
  bool isClicked = false;

  PayoutMethodModel({this.id, this.name});

  PayoutMethodModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    isClicked = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
