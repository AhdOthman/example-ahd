import 'package:subrate/api_url.dart';
import 'package:subrate/models/auth/reset_password_model.dart';

import '../../../helpers/base_dio_api.dart';
import '../../../helpers/requests_enum.dart';

class SubmitCodeForResetApi extends BaseDioApi {
  ResetPasswordModel resetPasswordModel;

  SubmitCodeForResetApi({
    required this.resetPasswordModel,
  }) : super(resetPasswordLink);

  @override
  body() {
    return resetPasswordModel.toJson();
  }

  Future fetch() async {
    final response = await sendRequest(requests.post, isAuthenticated: false);
    return response;
  }
}
