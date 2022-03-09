import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:flutter_mvvm_boilerplate/modules/common/models/login_model.dart';
import 'package:flutter_mvvm_boilerplate/modules/common/models/response_data_model.dart';
import 'package:flutter_mvvm_boilerplate/services/api_service.dart';
import 'package:flutter_mvvm_boilerplate/utils/constants/app_constants.dart';
import 'package:flutter_mvvm_boilerplate/utils/constants/color_constants.dart';
import 'package:flutter_mvvm_boilerplate/utils/constants/locale_constants.dart';
import 'package:flutter_mvvm_boilerplate/utils/navigation_helper.dart';
import 'package:flutter_mvvm_boilerplate/utils/shared_preferences_helper.dart';
import 'package:flutter_mvvm_boilerplate/modules/common/views/alert_bar.dart';

class LoginViewModel with ChangeNotifier {
  ApiStatus loadingStatus = ApiStatus.idle;
  Locale currentLanguage = LocaleConstants.ENGLISH;

  TextEditingController emailTextFieldController =
      TextEditingController(text: "eve.holt@reqres.in");
  TextEditingController passwordTextFieldController =
      TextEditingController(text: "cityslicka");

  init(BuildContext context) {
    currentLanguage = context.locale;
  }

  bool validate() {
    if (emailTextFieldController.text.isEmpty) {
      return false;
    }
    if (passwordTextFieldController.text.isEmpty) {
      return false;
    }

    return true;
  }

  void loginUser({bool logInWithCommonLoader: false}) async {
    if (emailTextFieldController.text.isEmpty) {
      AlertBar.show(NavigationHelper.instance.navigationKey.currentContext!,
          title: "Enter email", description: "Please enter a Email");
      return;
    }
    if (passwordTextFieldController.text.isEmpty) {
      AlertBar.show(NavigationHelper.instance.navigationKey.currentContext!,
          title: "Enter password", description: "Please enter a Password");
      return;
    }

    if (!logInWithCommonLoader) {
      loadingStatus = ApiStatus.started;
      notifyListeners();
    }

    LoginModel _loginModel = LoginModel(
        email: emailTextFieldController.text.trim(),
        password: passwordTextFieldController.text);

    ResponseData responseData = await ApiService().loginUser(
        context: NavigationHelper.instance.navigationKey.currentContext!,
        loginModel: _loginModel,
        logInWithCommonLoader: logInWithCommonLoader);

    if (responseData.ok) {
      //TODO: Push to next screen
      loadingStatus = ApiStatus.completed;
      String token = jsonDecode(responseData.rawResponseBody!)['token'];
      SharedPreferencesHelper.setAuthToken(token);
      AlertBar.show(NavigationHelper.instance.navigationKey.currentContext!,
          title: "Done",
          description: "Login Successful Token: $token",
          backgroundColor: ColorConstants.GREEN);
    } else {
      loadingStatus = ApiStatus.failed;
    }

    notifyListeners();

    await Future.delayed(Duration(seconds: 3));

    loadingStatus = ApiStatus.idle;
    notifyListeners();
  }

  changeLocale(BuildContext context) {
    currentLanguage = context.locale;

    if (currentLanguage == LocaleConstants.ENGLISH) {
      EasyLocalization.of(context)!.setLocale(LocaleConstants.HINDI);
    } else if (currentLanguage == LocaleConstants.HINDI) {
      EasyLocalization.of(context)!.setLocale(LocaleConstants.KANNADA);
    } else if (currentLanguage == LocaleConstants.KANNADA) {
      EasyLocalization.of(context)!.setLocale(LocaleConstants.ENGLISH);
    }
    currentLanguage = context.locale;
    notifyListeners();
  }
}
