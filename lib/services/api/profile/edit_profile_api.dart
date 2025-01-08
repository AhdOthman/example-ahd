import 'package:subrate/api_url.dart';
import 'package:subrate/models/profile/edit_profile_model.dart';

import '../../../helpers/base_dio_api.dart';
import '../../../helpers/requests_enum.dart';

class EditProfileApi extends BaseDioApi {
  EditProfileModel editProfileModel;

  EditProfileApi({
    required this.editProfileModel,
  }) : super(editProfileLink);

  @override
  body() {
    return editProfileModel.toJson();
  }

  Future fetch() async {
    final response = await sendRequest(requests.put, isAuthenticated: true);
    return response;
  }
}
