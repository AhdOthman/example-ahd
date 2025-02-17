import 'package:subrate/api_url.dart';
import '../../../helpers/base_dio_api.dart';
import '../../../helpers/requests_enum.dart';

enum SocialType { apple, google, facebook }

class SigninWithSocialApi extends BaseDioApi {
  SocialType type;
  String socialToken;
  SigninWithSocialApi({required this.socialToken, required this.type})
      : super(type == SocialType.apple
            ? signinWithAppleLink
            : signinWithGoggleLink);

  @override
  body() {
    return {
      type == SocialType.apple ? "code" : 'token': socialToken,
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
