import 'package:subrate/api_url.dart';

import '../../../helpers/base_dio_api.dart';
import '../../../helpers/requests_enum.dart';

class SetDefultAccountApi extends BaseDioApi {
  String id;
  SetDefultAccountApi({required this.id}) : super(setAccountAsDefaultUrl(id));

  Future fetch() async {
    final response = await sendRequest(requests.post, isAuthenticated: true);
    return response;
  }
}
