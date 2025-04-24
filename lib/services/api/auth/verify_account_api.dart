import 'package:subrate/api_url.dart';
import 'package:subrate/models/auth/verify_account_model.dart';

import '../../../helpers/base_dio_api.dart';
import '../../../helpers/requests_enum.dart';

class VerifyAccountApi extends BaseDioApi {
  VerifyAccountModel verifyAccountModel;

  VerifyAccountApi({
    required this.verifyAccountModel,
  }) : super(verifyAccountLink);

  @override
  body() {
    return verifyAccountModel.toJson();
  }

  Future fetch() async {
    final response = await sendRequest(requests.post, isAuthenticated: false);
    return response;
  }
}
