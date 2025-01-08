import 'package:subrate/api_url.dart';
import 'package:subrate/models/tasks/submit_task_model.dart';

import '../../../helpers/base_dio_api.dart';
import '../../../helpers/requests_enum.dart';

class SubmitTaskApi extends BaseDioApi {
  SubmitTaskModel submitTaskModel;
  SubmitTaskApi({required this.submitTaskModel}) : super(submitTaskLink);
  @override
  body() {
    return submitTaskModel.toJson();
  }

  Future fetch() async {
    final response = await sendRequest(requests.post, isAuthenticated: true);
    return response;
  }
}
