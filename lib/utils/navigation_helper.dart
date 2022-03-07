import 'package:flutter/cupertino.dart';
import 'package:flutter_mvvm_boilerplate/modules/custom_url/view_model/custom_url_view_model.dart';
import 'package:flutter_mvvm_boilerplate/modules/login_view/view_model/login_view_model.dart';
import 'package:flutter_mvvm_boilerplate/modules/custom_url/view/custom_url_view.dart';
import 'package:flutter_mvvm_boilerplate/modules/login_view/view/login_view.dart';
import 'package:provider/provider.dart';

///Navigation Helper
///Naming Standard:
///               Fun that gives View with provider             - getViewNameWithProvider()
///               Fun that pushes View                          - gotoViewName()
///               Fun(Data data) that pushes View with data     - gotoViewNameWithData(data)
///               Fun that clears stack and pushes View         - clearAndGotoViewName
///
///
class NavigationHelper {
  static final NavigationHelper instance = NavigationHelper._internal();

  NavigationHelper._internal();

  final GlobalKey<NavigatorState> navigationKey =
      new GlobalKey<NavigatorState>();

  static getCustomURLViewWithProvider() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CustomURLViewModel(),
        )
      ],
      child: CustomURLView(),
    );
  }

  static getLoginViewWithProvider() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => LoginViewModel(),
        )
      ],
      child: LoginView(),
    );
  }
}
