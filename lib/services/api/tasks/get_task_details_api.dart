import 'package:subrate/api_url.dart';

import '../../../helpers/base_dio_api.dart';
import '../../../helpers/requests_enum.dart';

class GetTaskDetailsApi extends BaseDioApi {
  String taskID;
  GetTaskDetailsApi({required this.taskID}) : super(getTaskDetailsLink);
  @override
  queryParameters() {
    return {
      'id': taskID,
    };
  }

  Future fetch() async {
    final response = await sendRequest(requests.get, isAuthenticated: true);
    return response;
  }
}
