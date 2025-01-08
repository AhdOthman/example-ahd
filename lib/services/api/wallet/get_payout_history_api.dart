import 'package:subrate/api_url.dart';

import '../../../helpers/base_dio_api.dart';
import '../../../helpers/requests_enum.dart';

class GetPayoutHistoryApi extends BaseDioApi {
  GetPayoutHistoryApi() : super(getPayoutHistoryLink);

  Future fetch() async {
    final response = await sendRequest(requests.get, isAuthenticated: true);
    return response;
  }
}
