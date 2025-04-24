import 'package:subrate/api_url.dart';

import '../../../helpers/base_dio_api.dart';
import '../../../helpers/requests_enum.dart';

class RequestCodeForPassApi extends BaseDioApi {
  String email;

  RequestCodeForPassApi({
    required this.email,
  }) : super(requestCodeForPassReset);

  @override
  body() {
    return {
      'email': email,
    };
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
