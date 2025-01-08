import 'package:subrate/api_url.dart';
import 'package:subrate/models/auth/signup_model_request.dart';

import '../../../helpers/base_dio_api.dart';
import '../../../helpers/requests_enum.dart';

class SignupApi extends BaseDioApi {
  SignupModelRequest signUpRequestModel;

  SignupApi({
    required this.signUpRequestModel,
  }) : super(signupLink);

  @override
  body() {
    return signUpRequestModel.toJson();
  }

  // @override
  // headers() {
  //   return {
  //     'Content-Type': 'application/json',
  //   };
  // }

  Future fetch() async {
    final response = await sendRequest(requests.post, isAuthenticated: false);
    return response;
  }
}
