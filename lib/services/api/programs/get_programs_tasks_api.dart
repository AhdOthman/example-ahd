import 'package:subrate/api_url.dart';

import '../../../helpers/base_dio_api.dart';
import '../../../helpers/requests_enum.dart';

class GetTasksByProgramsApi extends BaseDioApi {
  String programId;
  GetTasksByProgramsApi({required this.programId})
      : super(getProgramsTasksLink);
  @override
  queryParameters() {
    return {
      'id': programId,
    };
  }

  Future fetch() async {
    final response = await sendRequest(requests.get, isAuthenticated: true);
    return response;
  }
}
