import 'package:subrate/api_url.dart';
import 'package:subrate/models/auth/update_password_model.dart';

import '../../../helpers/base_dio_api.dart';
import '../../../helpers/requests_enum.dart';

class UpdatePasswordApi extends BaseDioApi {
  UpdatePasswordModel updatePasswordModel;

  UpdatePasswordApi({
    required this.updatePasswordModel,
  }) : super(updatePasswordLink);

  @override
  body() {
    return updatePasswordModel.toJson();
  }

  Future fetch() async {
    final response = await sendRequest(requests.put, isAuthenticated: true);
    return response;
  }
}
