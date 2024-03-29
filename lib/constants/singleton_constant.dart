import 'package:flutter_mvvm_boilerplate/constants/api_constants.dart';
import 'package:flutter_mvvm_boilerplate/helpers/shared_preferences_helper.dart';

/// This is Singleton Class. Data like user object, token etc can be stored here for easy access around the application.
/// Always create a getter and setter for variables.
/// Direct initialisation and access is not recommended.
class SingletonConstants {
  static SingletonConstants? _instance;

  factory SingletonConstants() => _instance ??= new SingletonConstants._();

  SingletonConstants._();

  String? _baseUrl;
  String? _authToken;

  String? getBaseUrl() =>
      _baseUrl != null ? _baseUrl : ApiConstants.SERVER_BASE_URL;

  void setBaseUrl(String baseURL) => _baseUrl = baseURL;

  String? get getToken => _authToken != null
      ? _authToken
      : SharedPreferencesHelper.getAuthTokenWithNullCheck();
}
