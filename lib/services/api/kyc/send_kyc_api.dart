import 'package:subrate/api_url.dart';
import 'package:subrate/models/kyc/send_kyc_request_model.dart';

import '../../../helpers/base_dio_api.dart';
import '../../../helpers/requests_enum.dart';

class SendKycApi extends BaseDioApi {
  KYCRequestModel kycRequestModel;

  SendKycApi({
    required this.kycRequestModel,
  }) : super(sendKycLink);

  @override
  body() {
    return kycRequestModel.toJson();
  }

  Future fetch() async {
    final response = await sendRequest(requests.post, isAuthenticated: true);
    return response;
  }
}
