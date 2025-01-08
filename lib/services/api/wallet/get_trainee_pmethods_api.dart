import 'package:subrate/api_url.dart';

import '../../../helpers/base_dio_api.dart';
import '../../../helpers/requests_enum.dart';

class GetTraineePmethodsApi extends BaseDioApi {
  GetTraineePmethodsApi() : super(getTraineePaymentMethodLink);

  Future fetch() async {
    final response = await sendRequest(requests.get, isAuthenticated: true);
    return response;
  }
}
