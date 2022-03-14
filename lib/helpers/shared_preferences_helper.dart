import 'package:shared_preferences/shared_preferences.dart';

/// Common shared preference helper class
class SharedPreferencesHelper {
  static final String _authToken = "authToken";
  static final String _customURL = "customURL";

  static late final SharedPreferences prefs;


  static initialise()async{
    prefs = await SharedPreferences.getInstance();
  }

  static String? getAuthToken()  {
    return prefs.getString(_authToken);
  }

  //Returns empty String if token is not set
  static String getAuthTokenWithNullCheck()  {
    return prefs.getString(_authToken) ?? "";
  }

  static Future<bool> setAuthToken(String value){
    return prefs.setString(_authToken, value);
  }

  static Future<bool> clearAuthToken() async {
    return prefs.remove(_authToken);
  }

  static String? getCustomURL() {
    return prefs.getString(_customURL);
  }

  static Future<bool> setCustomURL(String value)  {
    return prefs.setString(_customURL, value);
  }
}
