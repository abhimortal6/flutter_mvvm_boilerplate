import 'package:flutter/material.dart';
import 'package:flutter_mvvm_boilerplate/constants/api_constants.dart';
import 'package:flutter_mvvm_boilerplate/constants/singleton_constant.dart';
import 'package:flutter_mvvm_boilerplate/helpers/navigation_helper.dart';
import 'package:flutter_mvvm_boilerplate/helpers/shared_preferences_helper.dart';
import 'package:flutter_mvvm_boilerplate/modules/login_view/view/login_view.dart';
import 'package:flutter_mvvm_boilerplate/modules/common/views/alert_bar.dart';

class CustomURLViewModel with ChangeNotifier {
  TextEditingController urlTextFieldController = TextEditingController();

  //Check if custom URL was set previously if true then re-set it in text field
  void checkIfURLSetPreviously() async {
    String? url = await SharedPreferencesHelper.getCustomURL();
    if (url != null) {
      urlTextFieldController.text = url;
    }
  }

  //Set URL in singleton class and shared preference
  void setURL({required BuildContext context}) async {
    if (urlTextFieldController.text.isEmpty) {
      AlertBar.show(context,
          title: "Enter URL", description: "Please enter a URL");
      return;
    }
    SingletonConstants().setBaseUrl(urlTextFieldController.text.trim());
    SharedPreferencesHelper.setCustomURL(urlTextFieldController.text.trim());
    NavigationHelper.instance.goToScreen(
      screenName: LoginView.TAG,
    );
  }

  void setStaging({required BuildContext context}) async {
    SingletonConstants().setBaseUrl(ApiConstants.SERVER_BASE_URL);
    NavigationHelper.instance.goToScreen(
      screenName: LoginView.TAG,
    );
  }
}
