import 'package:flutter/cupertino.dart';
import 'package:flutter_mvvm_boilerplate/modules/custom_url/view_model/custom_url_view_model.dart';
import 'package:flutter_mvvm_boilerplate/modules/login_view/view_model/login_view_model.dart';
import 'package:flutter_mvvm_boilerplate/modules/custom_url/view/custom_url_view.dart';
import 'package:flutter_mvvm_boilerplate/modules/login_view/view/login_view.dart';
import 'package:provider/provider.dart';

///Navigation Helper
///
///
class NavigationHelper {
  static final NavigationHelper instance = NavigationHelper._internal();

  NavigationHelper._internal();

  final GlobalKey<NavigatorState> navigationKey =
      new GlobalKey<NavigatorState>();

  Future<Object?> goToScreen({
    BuildContext? context,
    required String screenName,
    Object? args,
    bool replaceCurrentScreen = false,
    bool withTransitionAnimation = true,
  }) {
    if (context == null) {
      context = navigationKey.currentContext!;
    }
    Route r = PageRouteBuilder(
      settings: RouteSettings(
        name: screenName,
        arguments: args ?? {},
      ),
      pageBuilder: (_, __, ___) => viewModelsMapper[screenName]!,
      transitionDuration:
          withTransitionAnimation ? Duration(milliseconds: 200) : Duration.zero,
      reverseTransitionDuration: Duration.zero,
      transitionsBuilder: (context, animation1, animation2, widget) =>
          SlideTransition(
        position:
            animation1.drive(Tween(begin: Offset(1.0, 0.0), end: Offset.zero)),
        child: widget,
      ),
    );

    if (replaceCurrentScreen) {
      Navigator.of(context).pushReplacement(r);
    } else {
      Navigator.of(context).push(r);
    }
    return r.popped;
  }

  static final Map<String, Widget> viewModelsMapper = {
    CustomURLView.TAG: MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CustomURLViewModel(),
        )
      ],
      child: CustomURLView(),
    ),
    LoginView.TAG: MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => LoginViewModel(),
        )
      ],
      child: LoginView(),
    )
  };
}
