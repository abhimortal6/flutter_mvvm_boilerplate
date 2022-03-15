import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_mvvm_boilerplate/constants/singleton_constant.dart';
import 'package:flutter_mvvm_boilerplate/modules/common/models/response_data_model.dart';
import 'package:flutter_mvvm_boilerplate/modules/common/views/alert_bar.dart';
import 'package:flutter_mvvm_boilerplate/modules/common/views/loader_widget.dart';
import 'package:flutter_mvvm_boilerplate/services/network_check.dart';
import 'package:flutter_mvvm_boilerplate/helpers/navigation_helper.dart';
import 'package:http/http.dart' as http;

class HttpHelper {
  final int _TIME_OUT_DURATION = 45; //in seconds

  List<int> _okCodes = [200, 201];

  Map<String, String> _generateHeaders({bool useAuth: true}) {
    return {
      'Content-Type': 'application/json',
      'Authorization':
          useAuth ? 'Bearer ' + (SingletonConstants().getToken ?? "") : "",
    };
  }

  _handleSuccess({
    required http.Response response,
    required BuildContext context,
    required bool showError,
    required bool showMessage,
    required String responseName,
    required bool showLog,
  }) {
    if (showLog) {
      debugPrint(
          "$responseName Response: ${_prettyJson(jsonDecode(response.body))}");
    }
  }

  _handleResponse({
    required http.Response response,
    required bool showError,
    required bool showMessage,
    required String responseName,
    required bool showLog,
    required bool showLoader,
    required BuildContext context,
  }) {
    if (showLoader) {
      _hideLoader();
    }
    if (_okCodes.contains(response.statusCode)) {
      _handleSuccess(
          context: context,
          response: response,
          showError: showError,
          showMessage: showMessage,
          responseName: responseName,
          showLog: showLog);
    } else {
      _handleError(
          context: context,
          response: response,
          showError: showError,
          showMessage: showMessage,
          responseName: responseName,
          showLog: showLog);
    }
  }

  _handleError({
    required http.Response response,
    required bool showError,
    required bool showMessage,
    required String responseName,
    required bool showLog,
    required BuildContext context,
  }) async {
    ResponseData responseData = ResponseData.fromResponse(response);

    if (showLog) {
      debugPrint("Request failed with status: ${response.statusCode}.");
      debugPrint("Error:${response.reasonPhrase}");
      debugPrint("$responseName Response:${response.body}");
    }

    if (response.statusCode == 401) {
      //TODO: Logout
    } else {
      if (showMessage) {
        if (responseData.message != null)
          AlertBar.show(context,
              title: 'Error',
              description: responseData.errors!.message,
              gravity: AlertBar.TOP,
              backgroundColor: Colors.red);
      }
      // if (showError) {
      //   if (responseData.errors != null) {}
      // }
    }
  }

  _showLoader(BuildContext context) {
    LoaderWidget.showLoader();
  }

  _hideLoader() {
    LoaderWidget.hideLoader();
  }

  Future<ResponseData> httpRequest({
    required RequestMethod method,
    required String requestUrl,
    BuildContext? context,
    Map? body,
    bool showError: false,
    bool showMessage: false,
    bool checkNetwork: true,
    bool showNetworkError: true,
    bool? showLoader: true,
    bool useAuth: true,
    String responseName: "",
    bool showLog: true,
  }) async {
    BuildContext? _context;
    ResponseData responseData = ResponseData();

    if (context == null) {
      if (NavigationHelper.instance.navigationKey.currentContext == null) {
        throw Exception("Null context");
      } else {
        _context = NavigationHelper.instance.navigationKey.currentContext!;
      }
    } else {
      _context = context;
    }

    if (showLog) {
      debugPrint("Requested URL: " + requestUrl);
      debugPrint("Method: " + method.name);
      debugPrint("Body: $body");
    }

    if (checkNetwork &&
        await NetworkCheck.isOnline(
            showError: showNetworkError, context: _context)) {
      if (showLoader!) _showLoader(_context);
      var jsonBody;
      Uri uri = Uri.parse(requestUrl);
      if (body != null) jsonBody = JsonEncoder().convert(body);

      switch (method) {
        case RequestMethod.get:
          await http
              .get(uri, headers: _generateHeaders(useAuth: useAuth))
              .timeout(Duration(seconds: _TIME_OUT_DURATION))
              .then((http.Response response) async {
            _handleResponse(
                context: _context!,
                response: response,
                showError: showError,
                showMessage: showMessage,
                responseName: responseName,
                showLog: showLog,
                showLoader: showLoader);
            responseData = ResponseData.fromResponse(response);
          }).catchError((error) {
            if (showLoader) {
              _hideLoader();
            }
            debugPrint(error.toString());
          });
          break;
        case RequestMethod.post:
          await http
              .post(uri,
                  body: jsonBody, headers: _generateHeaders(useAuth: useAuth))
              .timeout(Duration(seconds: _TIME_OUT_DURATION))
              .then((http.Response response) async {
            _handleResponse(
                context: _context!,
                response: response,
                showError: showError,
                showMessage: showMessage,
                responseName: responseName,
                showLog: showLog,
                showLoader: showLoader);
            responseData = ResponseData.fromResponse(response);
          }).catchError((error) {
            if (showLoader) {
              _hideLoader();
            }
            debugPrint(error.toString());
          });
          break;
        case RequestMethod.put:
          await http
              .put(uri,
                  body: jsonBody, headers: _generateHeaders(useAuth: useAuth))
              .timeout(Duration(seconds: _TIME_OUT_DURATION))
              .then((http.Response response) async {
            _handleResponse(
                context: _context!,
                response: response,
                showError: showError,
                showMessage: showMessage,
                responseName: responseName,
                showLog: showLog,
                showLoader: showLoader);
            responseData = ResponseData.fromResponse(response);
          }).catchError((error) {
            if (showLoader) {
              _hideLoader();
            }
            debugPrint(error.toString());
          });
          break;
        case RequestMethod.patch:
          await http
              .patch(uri,
                  body: jsonBody, headers: _generateHeaders(useAuth: useAuth))
              .timeout(Duration(seconds: _TIME_OUT_DURATION))
              .then((http.Response response) async {
            _handleResponse(
                context: _context!,
                response: response,
                showError: showError,
                showMessage: showMessage,
                responseName: responseName,
                showLog: showLog,
                showLoader: showLoader);
            responseData = ResponseData.fromResponse(response);
          }).catchError((error) {
            if (showLoader) {
              _hideLoader();
            }
            debugPrint(error.toString());
          });
          break;
        case RequestMethod.delete:
          await http
              .delete(uri,
                  body: jsonBody, headers: _generateHeaders(useAuth: useAuth))
              .timeout(Duration(seconds: _TIME_OUT_DURATION))
              .then((http.Response response) async {
            _handleResponse(
                context: _context!,
                response: response,
                showError: showError,
                showMessage: showMessage,
                responseName: responseName,
                showLog: showLog,
                showLoader: showLoader);
            responseData = ResponseData.fromResponse(response);
          }).catchError((error) {
            if (showLoader) {
              _hideLoader();
            }
            debugPrint(error.toString());
          });
          break;
      }
    }
    return responseData;
  }

  String _prettyJson(dynamic json, {int indent = 2}) {
    var spaces = ' ' * indent;
    var encoder = JsonEncoder.withIndent(spaces);
    return encoder.convert(json);
  }
}

enum RequestMethod { get, post, put, patch, delete }
