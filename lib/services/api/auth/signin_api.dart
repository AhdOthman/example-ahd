import 'package:subrate/api_url.dart';
import 'package:subrate/models/auth/signin_model_request.dart';

import '../../../helpers/base_dio_api.dart';
import '../../../helpers/requests_enum.dart';

class SigninApi extends BaseDioApi {
  SigninModelRequest signinModelRequest;

  SigninApi({
    required this.signinModelRequest,
  }) : super(signinLink);

  @override
  body() {
    return signinModelRequest.toJson();
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
