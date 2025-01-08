import 'package:subrate/api_url.dart';

import '../../../helpers/base_dio_api.dart';
import '../../../helpers/requests_enum.dart';

class EditProfilePictureApi extends BaseDioApi {
  String photoLink;

  EditProfilePictureApi({
    required this.photoLink,
  }) : super(editProfilePictureLink);

  @override
  body() {
    return {
      "picture": photoLink,
    };
  }

  Future fetch() async {
    final response = await sendRequest(requests.put, isAuthenticated: true);
    return response;
  }
}
