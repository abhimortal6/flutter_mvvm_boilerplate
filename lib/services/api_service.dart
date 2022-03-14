import 'package:flutter/material.dart';
import 'package:flutter_mvvm_boilerplate/constants/api_constants.dart';
import 'package:flutter_mvvm_boilerplate/modules/common/models/login_model.dart';
import 'package:flutter_mvvm_boilerplate/modules/common/models/response_data_model.dart';
import 'package:flutter_mvvm_boilerplate/helpers/http_helper.dart';

class ApiService {
  Future<ResponseData> loginUser(
      {required BuildContext context,
      required LoginModel loginModel,
      bool? logInWithCommonLoader}) {
    String _uri = baseURL! + ApiConstants.LOGIN;

    return HttpHelper().httpRequest(
        method: RequestMethod.post,
        requestUrl: _uri,
        body: loginModel.toMap(),
        useAuth: false,
        showLoader: logInWithCommonLoader,
        responseName: "Login",
        showLog: true,
        showError: true);
  }
}
