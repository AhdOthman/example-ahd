import 'package:subrate/api_url.dart';

import '../../../helpers/base_dio_api.dart';
import '../../../helpers/requests_enum.dart';

class DeletePayoutAccountApi extends BaseDioApi {
  String id;
  DeletePayoutAccountApi({required this.id})
      : super(deletePayoutAccountUrl(id));

  Future fetch() async {
    final response = await sendRequest(requests.delete, isAuthenticated: true);
    return response;
  }
}
