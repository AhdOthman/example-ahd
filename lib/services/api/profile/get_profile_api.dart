import 'package:subrate/api_url.dart';

import '../../../helpers/base_dio_api.dart';
import '../../../helpers/requests_enum.dart';

class GetProfileApi extends BaseDioApi {
  GetProfileApi() : super(getProfileLink);

  Future fetch() async {
    final response = await sendRequest(requests.get,
        isAuthenticated: true, sendTenantId: false);
    return response;
  }
}
