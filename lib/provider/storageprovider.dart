import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:subrate/api_url.dart';
import 'package:subrate/provider/authprovider.dart';
import 'package:subrate/theme/ui_helper.dart';

class StorageProvider with ChangeNotifier {
  String? resultLink;
  Future<bool> uploadFile({
    required XFile? imageFile,
    required BuildContext context,
  }) async {
    final provider = Provider.of<AuthProvider>(context, listen: false);
    String token = provider.token!;
    String fileName;
    final dio = Dio();
    const String uploadPath = "storage/upload";
    const String fullUrl = "$baseUrl/$uploadPath";

    try {
      // Replace the file path with your actual file path
      fileName = imageFile!.path.split('/').last;
      print(fullUrl);

      // Prepare the form data
      FormData formData = FormData.fromMap({
        'files':
            await MultipartFile.fromFile(imageFile.path, filename: fileName),
      });

      // Make the POST request
      final response = await dio.post(
        fullUrl,
        data: formData,
        options: Options(
          headers: {
            'Authorization': "Bearer $token",
          },
        ),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        // Parse the result string from the response
        resultLink = response.data['result'][0];
        UIHelper.showNotification('Photo uploaded successfully',
            backgroundColor: Colors.green);
        print("Uploaded file link: $resultLink");
        return true;

        // Save the result link (example: save in a variable or storage)
        // You can use SharedPreferences, SQLite, or other storage options.
      } else {
        if (response.statusCode == 413) {
          UIHelper.showNotification('File size is too large');
        } else {
          print("Failed to upload file. Status code: ${response.statusCode}");
        }

        return false;
      }
    } catch (e) {
      if (e.toString().contains('413')) {
        UIHelper.showNotification('File size is too large');
      } else {
        UIHelper.showNotification('Something went wrong');
      }
      return false;
    }
  }
}
