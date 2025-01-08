import 'package:subrate/api_url.dart';

import '../../../helpers/base_dio_api.dart';
import '../../../helpers/requests_enum.dart';

class AcceptInvitationApi extends BaseDioApi {
  String id;

  AcceptInvitationApi({
    required this.id,
  }) : super(acceptInviteLink);

  @override
  body() {
    return {
      'invitationId': id,
    };
  }

  // @override
  // headers() {
  //   return {
  //     'Content-Type': 'application/json',
  //   };
  // }

  Future fetch() async {
    final response = await sendRequest(requests.post, isAuthenticated: true);
    return response;
  }
}
