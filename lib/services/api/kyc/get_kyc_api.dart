import 'package:subrate/api_url.dart';
import '../../../helpers/base_dio_api.dart';
import '../../../helpers/requests_enum.dart';

class GetKycApi extends BaseDioApi {
  String userID;
  String tenantID;
  GetKycApi({required this.userID, required this.tenantID})
      : super(getKycRequestLink);

  @override
  queryParameters() {
    return {'userId': userID, 'tenantId': tenantID};
  }

  Future fetch() async {
    final response = await sendRequest(requests.get, isAuthenticated: true);
    return response;
  }
}
