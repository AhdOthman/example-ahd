import 'package:subrate/api_url.dart';

import '../../../helpers/base_dio_api.dart';
import '../../../helpers/requests_enum.dart';

class GetPayoutMethodDetailsApi extends BaseDioApi {
  String payoutMethodId;
  GetPayoutMethodDetailsApi({required this.payoutMethodId})
      : super(getPayoutMethodDetailsLink);
  @override
  queryParameters() {
    return {
      'id': payoutMethodId,
    };
  }

  Future fetch() async {
    final response = await sendRequest(requests.get, isAuthenticated: true);
    return response;
  }
}
