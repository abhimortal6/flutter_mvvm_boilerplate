import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mvvm_boilerplate/utils/constants/app_constants.dart';
import 'package:flutter_mvvm_boilerplate/utils/constants/locale_constants.dart';
import 'package:flutter_mvvm_boilerplate/utils/navigation_helper.dart';
import 'package:flutter_mvvm_boilerplate/modules/custom_url/view/custom_url_view.dart';
import 'package:flutter_mvvm_boilerplate/modules/login_view/view/login_view.dart';

void main() async {
  //Check if custom URL flag is set and make safe check for production
  //If true custom url screen is shown
  //
  Widget _defaultHome =
      AppConstants.isCustomURLBuild && !AppConstants.isProdBuild
          ? NavigationHelper.getCustomURLViewWithProvider()
          : NavigationHelper.getLoginViewWithProvider();

  WidgetsFlutterBinding.ensureInitialized();
  //Locks orientation
  //Can be changed at runtime via same method.
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  ///Sets Status Bar Color
  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: ));

  runApp(
    new EasyLocalization(
        supportedLocales: LocaleConstants.SUPPORTED_LOCALES,
        path: 'assets/localisation',
        fallbackLocale: LocaleConstants.ENGLISH,
        child: MaterialApp(
          navigatorKey: NavigationHelper.instance.navigationKey,
          title: AppConstants.APP_NAME,
          debugShowCheckedModeBanner: false,
          routes: {
            '/': (context) => _defaultHome,

            ///Home Route is Denoted as /
            ///Set tag in view itself, so it can be used directly maintaining consistency.
            CustomURLView.TAG: (context) =>
                NavigationHelper.getCustomURLViewWithProvider(),
            LoginView.TAG: (context) =>
                NavigationHelper.getLoginViewWithProvider(),
          },
        )),
  );
}
