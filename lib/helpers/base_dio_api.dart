import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:subrate/helpers/call_token.dart';
import 'package:subrate/translations/locale_keys.g.dart';
import 'requests_enum.dart';
import 'package:flutter/material.dart';

import '../theme/failure.dart';
import '../theme/ui_helper.dart';

class BaseDioApi {
  String? token;
  final Dio _dio = Dio();

  late Response _response;
  Map<String, dynamic>? toHeaders = Map<String, dynamic>();
  final String url;
  // ApiResponse apiResponse;
  BaseDioApi(
    this.url,
  );

  Map<String, dynamic> queryParameters() {
    return {};
  }

  void addToHeaders(String key, String value) {
    toHeaders![key] = value;
  }

  dynamic headers() {
    return {
      // 'Content-Type': 'application/json',
      // 'Authorization': 'Bearer $token',
    };
  }

  String? tenantId;
  CallToken callToken = CallToken();

  Future<Map<String, dynamic>> sendRequest(Enum type,
      {required bool isAuthenticated, bool sendTenantId = true}) async {
    callToken.getTenant().then((value) {
      tenantId = callToken.tenantID;
      print('tenantIDDDDD ${callToken.tenantID}');
    });
    // Await the token retrieval
    callToken.token = await callToken.getToken();

    print(callToken.token); // Now this should print the token correctly
    print('callToken.tenantID ${callToken.tenantID}');

    if (isAuthenticated) {
      addToHeaders('Content-Type', 'application/json');
      addToHeaders('Authorization', 'Bearer ${callToken.token}');
      sendTenantId ? addToHeaders('x-tenant-id', tenantId.toString()) : null;
    }

    print('object from request $type');

    switch (type) {
      case requests.get:
        return await _getRequest();
      case requests.post:
        return await _postRequest();
      case requests.put:
        return await _putRequest();
      case requests.delete:
        return await _deleteRequest();
      default:
        return await _deleteRequest();
    }
  }

  static bool tokenEnd = false;

  dynamic body() {}

  Future<Map<String, dynamic>> _postRequest() async {
    debugPrint('url $url');
    debugPrint('body ${body()}');
    print('body ${body()}');
    print('queryParameters ${queryParameters()}');

    debugPrint('headers ${toHeaders}');
    try {
      _response = await _dio.post(
        url,
        options: Options(headers: toHeaders),
        queryParameters: queryParameters(),
        data: body(),
      );
      if (_response.statusCode == 401) {
        tokenEnd = true;
        print('this is error');
      }
      print(_response.data);
      return _response.data;
    } on DioError catch (e) {
      debugPrint(e.response.toString());
      if (e.response?.statusCode == 401) {
        tokenEnd = true;
        print('this is error');
      }
      e.response?.statusCode == 401 ? tokenEnd = true : null;

      debugPrint(e.message);
      debugPrint("${e.response}");

      UIHelper.showNotification(e.response!.data['error']['details']);

      switch (e.type) {
        case DioErrorType.connectTimeout:
        case DioErrorType.sendTimeout:
        case DioErrorType.receiveTimeout:
        case DioErrorType.other:
          throw Failure("Timeout request");
        case DioErrorType.response:
          e.response?.statusCode == 401 ? tokenEnd = true : false;
          throw e.response?.statusCode == 401
              ? throw Failure("Request cancelled")
              : throw Failure("Request cancelled");

        // ignore: unreachable_switch_case
        case DioErrorType.response:
          debugPrint(e.response?.statusMessage);
          throw Failure(e.error.toString());
        case DioErrorType.cancel:
          throw Failure("Request cancelled");
        // ignore: unreachable_switch_case
        case DioErrorType.other:
          {
            if (e.error is SocketException) {
              throw Failure('No Internet connection');
            } else if (e.response?.statusCode == 401) {
              tokenEnd = true;
              throw Failure("Token End");
            } else if (e.error is FormatException) {
              throw Failure("Bad response format");
            } else {
              throw Failure("Something Wrong");
            }
          }
      }
    }
  }

  Future<Map<String, dynamic>> _getRequest() async {
    addToHeaders('Accept-Language', LocaleKeys.language_code.tr());
    debugPrint('headers ${toHeaders}');

    debugPrint('uwrl $token');
    debugPrint('url $url');
    debugPrint('queryParameters ${queryParameters()}');
    debugPrint('headers ${toHeaders}');

    try {
      _response = await _dio.get(
        url,
        options: Options(
          headers: toHeaders,
        ),
        queryParameters: queryParameters(),
      );
      print(_response.data);
      return _response.data;
    } on DioError catch (e) {
      // UIHelper.showNotification(e.response!.data['message']);

      switch (e.type) {
        case DioErrorType.connectTimeout:
        case DioErrorType.sendTimeout:
        case DioErrorType.receiveTimeout:
          throw Failure("Timeout request");
        case DioErrorType.response:
          throw e.response?.statusCode == 404
              ? throw Failure("Request cancelled")
              : throw Failure(e.error.toString());

        case DioErrorType.cancel:
          throw Failure("Request cancelled");
        case DioErrorType.other:
          {
            if (e.error is SocketException) {
              throw Failure('No Internet connection');
            } else if (e.error is FormatException) {
              throw Failure("Bad response format");
            } else {
              throw Failure("Something Wrong");
            }
          }
      }
    }
  }

  Future<Map<String, dynamic>> _putRequest() async {
    debugPrint('url $url');
    debugPrint('queryParameters ${queryParameters()}');
    debugPrint('url $url');
    debugPrint('body ${body()}');
    try {
      _response = await _dio.put(
        url,
        options: Options(
          headers: toHeaders,
        ),
        queryParameters: queryParameters(),
        data: body(),
      );
      return _response.data;
    } on DioError catch (e) {
      switch (e.type) {
        case DioErrorType.connectTimeout:
        case DioErrorType.sendTimeout:
        case DioErrorType.receiveTimeout:
          throw Failure("Timeout request");
        case DioErrorType.response:
          throw Failure(e.error.toString());
        case DioErrorType.cancel:
          throw Failure("Request cancelled");
        case DioErrorType.other:
          {
            if (e.error is SocketException) {
              throw Failure('No Internet connection');
            } else if (e.error is FormatException) {
              throw Failure("Bad response format");
            } else {
              throw Failure("Something Wrong");
            }
          }
      }
    }
  }

  Future<Map<String, dynamic>> _deleteRequest() async {
    try {
      _response = await _dio.delete(
        url,
        options: Options(
          headers: toHeaders,
        ),
        queryParameters: queryParameters(),
        data: body(),
      );
      return _response.data;
    } on DioError catch (e) {
      switch (e.type) {
        case DioErrorType.connectTimeout:
        case DioErrorType.sendTimeout:
        case DioErrorType.receiveTimeout:
          throw Failure("Timeout request");
        case DioErrorType.response:
          throw Failure(e.error.toString());
        case DioErrorType.cancel:
          throw Failure("Request cancelled");
        case DioErrorType.other:
          {
            if (e.error is SocketException) {
              throw Failure('No Internet connection');
            } else if (e.error is FormatException) {
              throw Failure("Bad response format");
            } else {
              throw Failure("Something Wrong");
            }
          }
      }
    }
  }
}
