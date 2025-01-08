import 'package:subrate/api_url.dart';

import '../../../helpers/base_dio_api.dart';
import '../../../helpers/requests_enum.dart';

class CreatePayoutApi extends BaseDioApi {
  String payoutMethodId;
  CreatePayoutApi({required this.payoutMethodId})
      : super(createPayoutRequestLink);
  @override
  body() {
    return {'payoutMethodId': payoutMethodId};
  }

  Future fetch() async {
    final response = await sendRequest(requests.post, isAuthenticated: true);
    return response;
  }
}
