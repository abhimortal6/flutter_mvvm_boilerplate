import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mvvm_boilerplate/constants/app_constants.dart';
import 'package:flutter_mvvm_boilerplate/constants/color_constants.dart';
import 'package:flutter_mvvm_boilerplate/constants/font_family_constants.dart';
import 'package:flutter_mvvm_boilerplate/modules/login_view/view_model/login_view_model.dart';
import 'package:flutter_mvvm_boilerplate/modules/common/views/common_button.dart';
import 'package:flutter_mvvm_boilerplate/modules/common/views/common_text_field.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  LoginView({Key? key}) : super(key: key);

  static const String TAG = "/LoginView";

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  LoginViewModel? _viewModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  _buildSubmitButton(LoginViewModel loginViewModel) {
    switch (loginViewModel.loadingStatus) {
      case ApiStatus.started:
        return Padding(
          padding: EdgeInsets.all(8.0),
          child: CircularProgressIndicator(),
        );
      case ApiStatus.completed:
        return Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Icon(
            Icons.check,
            size: 40,
            color: ColorConstants.GREEN,
          ),
        );

      default:
        return CommonButton(
          title: "Login with Widget Specific Loader",
          function: () {
            loginViewModel.loginUser();
          },
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_viewModel == null)
      _viewModel = Provider.of<LoginViewModel>(context)..init(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _viewModel!.changeLocale(context);
        },
        child: Text(_viewModel!.currentLanguage.languageCode),
      ),

      ///This flag will allow to ignore Keyboard Overflow.
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          AppConstants.APP_NAME.tr(),
          style: TextStyle(fontFamily: FontFamilyConstants.PLAY_FAIR_DISPLAY),
        ),
      ),
      body: Column(
        children: [
          Padding(
              padding: const EdgeInsets.only(top: 50, bottom: 10),
              child: Image.asset(
                "assets/images/logos/Google_flutter_logo.png",
                width: 150,
              )),
          CommonTextField(
            label: "Email",
            hint: "Enter Email here",
            controller: _viewModel!.emailTextFieldController,
          ),
          CommonTextField(
            label: "Password",
            hint: "Enter Password here",
            controller: _viewModel!.passwordTextFieldController,
          ),
          _buildSubmitButton(_viewModel!),
          CommonButton(
            title: "Login with Common Loader",
            function: () {
              _viewModel!.loginUser(logInWithCommonLoader: true);
            },
          )
        ],
      ),
    );
  }
}
