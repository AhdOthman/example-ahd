import 'package:subrate/api_url.dart';

import '../../../helpers/base_dio_api.dart';
import '../../../helpers/requests_enum.dart';

class ResendVerifyOtpApi extends BaseDioApi {
  String email;

  ResendVerifyOtpApi({
    required this.email,
  }) : super(resendOtpLink);

  @override
  body() {
    return {
      'identifier': email,
    };
  }

  Future fetch() async {
    final response = await sendRequest(requests.post, isAuthenticated: false);
    return response;
  }
}
