class SubmitTaskModel {
  String? taskSubmissionId;
  String? attachment;

  SubmitTaskModel({this.taskSubmissionId, this.attachment});

  SubmitTaskModel.fromJson(Map<String, dynamic> json) {
    taskSubmissionId = json['taskSubmissionId'];
    attachment = json['attachment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['taskSubmissionId'] = this.taskSubmissionId;
    data['attachment'] = this.attachment;
    return data;
  }
}
