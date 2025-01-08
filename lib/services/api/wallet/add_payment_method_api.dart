import 'package:subrate/api_url.dart';
import 'package:subrate/models/wallet/dynamic_payment_request.dart';

import '../../../helpers/base_dio_api.dart';
import '../../../helpers/requests_enum.dart';

class AddPaymentMethodApi extends BaseDioApi {
  PaymentDetailsRequest paymentDetailsRequest;
  AddPaymentMethodApi({required this.paymentDetailsRequest})
      : super(addPaymentMethodLink);
  @override
  body() {
    return paymentDetailsRequest.toJson();
  }

  Future fetch() async {
    final response = await sendRequest(requests.post, isAuthenticated: true);
    return response;
  }
}
