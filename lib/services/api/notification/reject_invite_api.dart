import 'package:subrate/api_url.dart';

import '../../../helpers/base_dio_api.dart';
import '../../../helpers/requests_enum.dart';

class RejectInviteApi extends BaseDioApi {
  String id;

  RejectInviteApi({
    required this.id,
  }) : super(rejectInviteLink);

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
