// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mvvm_boilerplate/main.dart';
import 'package:flutter_mvvm_boilerplate/modules/common/views/alert_bar.dart';
import 'package:flutter_mvvm_boilerplate/modules/common/views/common_button.dart';
import 'package:flutter_mvvm_boilerplate/modules/login_view/view/login_view.dart';
import 'package:flutter_mvvm_boilerplate/modules/login_view/view_model/login_view_model.dart';
import 'package:flutter_mvvm_boilerplate/utils/constants/locale_constants.dart';
import 'package:flutter_mvvm_boilerplate/utils/navigation_helper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Check Validations', () {
    LoginViewModel loginViewModel = LoginViewModel();

    loginViewModel.emailTextFieldController.clear();
    loginViewModel.passwordTextFieldController.clear();

    test('It should return false when user and pass is empty', () async {
      bool result = loginViewModel.validate();
      expect(result, false);
    });

    test('It should return true when user and pass is not empty', () async {
      loginViewModel.emailTextFieldController.text = "SomeMail@mail.com";
      loginViewModel.passwordTextFieldController.text = "SomePassword";
      bool result = loginViewModel.validate();

      expect(result, true);
    });
  });

  group('Check Login Screen', () {
    testWidgets('Login should have submit button', (WidgetTester tester) async {
      WidgetsFlutterBinding.ensureInitialized();

      final testWidget = EasyLocalization(
          supportedLocales: LocaleConstants.SUPPORTED_LOCALES,
          path: 'assets/localisation',
          fallbackLocale: LocaleConstants.ENGLISH,
          child: MyApp(NavigationHelper.viewModelsMapper[LoginView.TAG]!));

      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      expect(find.text('Login with Common Loader'), findsOneWidget);
    });
  });
}
