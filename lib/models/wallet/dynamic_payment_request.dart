class PaymentDetailsRequest {
  String? payoutMethodId;
  List<Fields>? fields;

  PaymentDetailsRequest({this.payoutMethodId, this.fields});

  PaymentDetailsRequest.fromJson(Map<String, dynamic> json) {
    payoutMethodId = json['payoutMethodId'];
    if (json['fields'] != null) {
      fields = <Fields>[];
      json['fields'].forEach((v) {
        fields!.add(new Fields.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['payoutMethodId'] = this.payoutMethodId;
    if (this.fields != null) {
      data['fields'] = this.fields!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Fields {
  String? fieldName;
  String? fieldValue;

  Fields({this.fieldName, this.fieldValue});

  Fields.fromJson(Map<String, dynamic> json) {
    fieldName = json['fieldName'];
    fieldValue = json['fieldValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fieldName'] = this.fieldName;
    data['fieldValue'] = this.fieldValue;
    return data;
  }
}
