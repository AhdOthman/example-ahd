import 'package:subrate/api_url.dart';

import '../../../helpers/base_dio_api.dart';
import '../../../helpers/requests_enum.dart';

class DeleteMyAccountApi extends BaseDioApi {
  DeleteMyAccountApi() : super(deleteAccountLink);

  Future fetch() async {
    final response = await sendRequest(requests.get, isAuthenticated: true);
    return response;
  }
}
