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
          ? NavigationHelper.viewModelsMapper[CustomURLView.TAG]!
          : NavigationHelper.viewModelsMapper[LoginView.TAG]!;

  WidgetsFlutterBinding.ensureInitialized();
  //Locks orientation
  //Can be changed at runtime via same method.
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  //Localisation
  await EasyLocalization.ensureInitialized();
  // EasyLocalization.logger.enableLevels = [];

  ///Sets Status Bar Color
  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: ));

  runApp(
    new EasyLocalization(
        supportedLocales: LocaleConstants.SUPPORTED_LOCALES,
        path: 'assets/localisation',
        fallbackLocale: LocaleConstants.ENGLISH,
        child: MyApp(_defaultHome)),
  );
}

class MyApp extends StatelessWidget {
  MyApp(this.defaultHome);

  final Widget defaultHome;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: NavigationHelper.instance.navigationKey,
      title: AppConstants.APP_NAME,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      routes: {
        '/': (context) => defaultHome,

        ///Home Route is Denoted as /
        ///Set tag in view itself, so it can be used directly maintaining consistency.
        CustomURLView.TAG: (context) =>
            NavigationHelper.viewModelsMapper[CustomURLView.TAG]!,
        LoginView.TAG: (context) =>
            NavigationHelper.viewModelsMapper[LoginView.TAG]!,
      },
    );
  }
}
