import 'package:subrate/api_url.dart';

import '../../../helpers/base_dio_api.dart';
import '../../../helpers/requests_enum.dart';

class GetCountryListApi extends BaseDioApi {
  GetCountryListApi() : super(getCountryLink);

  Future fetch() async {
    final response = await sendRequest(requests.get, isAuthenticated: false);
    return response;
  }
}
