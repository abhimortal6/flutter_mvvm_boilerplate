




# Flutter MVVM Boilerplate

Flutter Boilerplate containing pre initialised services and following standardised protocol for code quality.

Maintained by  - [Abhijeet Tripathi](https://github.com/abhimortal6)

##  Features

| Feature | Availability |
| - | - |
| Ready to use | :white_check_mark: |
| Localisation | :white_check_mark: |
| MVVM based | :white_check_mark:|
| Network services | :white_check_mark: |
| Using Providers | :white_check_mark: |
| Modular | :white_check_mark: |
| Assets and custom Fonts | :white_check_mark: |
| Embedded custom URL screen | :white_check_mark: |





## Setup Guide

 1.  [Initial Setup](#1-initial-setup)
 2.  [Constants](#2-constants)
 3.  [Base Response Model](#3--base-response-model)
 4.  [Network layer](#4-network-layer)
 5.  [Navigation](#5-navigation)
 6. [Localisation](#6-localisation)

<br>


## 1. Initial Setup

1. Clone this repo
2. Rename "**flutter-boilerplate**" folder to your "**project_name**"
3.  Open folder in Android Studio
4. Open project's pubspec.yaml and change
  // This is Flutter level project name do not consider this as bundle id or application id
    - "name: flutter_mvvm_boilerplate" to "name: project_name"
    - "description: Ready to use flutter boiler plate" to "description: Your project description"

 5. In Android Studio's Terminal run
 ```sh
 flutter pub get
 ```
 Note: You'll start getting errors in all your files it's because we've changed the flutter package name and imports are still directing to old package name.

 6. Right click on "**lib**" folder and click "**Replace in path**" and replace "**flutter_mvvm_boilerplate**" to "**project_name**" (same as you used in pubspec.yaml) click **"Replace All"**.
Note: Most of your errors will go away if not just close and reopen Android Studio once.

7. Change Application name and ID: Open terminal tab in Android Studio and run following commands.


• This will install package rename tool
```sh
flutter pub global activate rename
```

• This will rename your Application name
```sh
flutter pub global run rename --appname "Project Name"
```

• This will rename your Application ID/Bundle ID
```sh
flutter pub global run rename --bundleId com.companyname.projectname
```
<br>

  8. Add and register project specific assets and you're ready to go.
<br>
<br>


## 2. Constants

**Description**

Maintainability is achieved by distributing type of Constant Data into specific category.
Important constants files are
 - api_constants.dart
      - Contains base URL and all the end points that application is going to use.

 - app_constants.dart
      - Contains maintenance flag for changing Production and Staging Environments
      - Also contains app related constants

 - singleton_constants.dart
      - This is a Singleton class for general purpose data sharing over the app User object, token etc.
- Other constants files are self explanatory
<br>
<br>

## 3.  Base Response Model

**Description**

Base Response Model is designed for productive API integration. This model can be modified according to Project's API structure.

File name

- response_data_model.dart

**Keys to change**

  1. Data
 2. Error and Message
 3. okAndContainsData

 Based on your API Structure change the 'data' key to specified key where all your response's data will be delivered.
 Example: For given API structure

  ```dart
{
  'data': [
    {
      'name': 'Abhijeet Tripathi',
      'mail': 'somemail@test.com'
    }
  ],

'message' : 'Data fetched',
'error' : 'None till now'
}
```

 the keys will be..

 ```dart
 data: parsedJson['data'] != null ? parsedJson['data'] : null,
 okAndContainsData: (response.statusCode == 200 ) && (parsedJson['data'] != null),
 message: parsedJson['message'] != null ? parsedJson['message'] : "",
```

 Though this model is null safe but it's not safe from parsing errors.
 Always cross checks key names and hierarchy of them.
<br>
<br>

 ## 4. Network Layer

**Description**

Networking layer is preinitialised with following features.

-  Network connection check
 - Common loader
 - Common Error and Success Message
 - Prettyfied Logs for easy debugging.

Responsible files

 - api_helper.dart
 - api_service.dart
 - api_constants.dart
 - network_check.dart
 - pretty_json_print.dart

**Things to change**

In  **api_helper.dart** change the following as per your project needs.

 - DEFAULT_TIMEOUT this is a top level variable denotes time out seconds. Default is 45.
 - _getHeaders this is Header generator for API call change as per required.
 - _handleError this is error handler for all REST calls you can handle unauthorised logout and
   error alert directly from here.

**Usage example**

  1. Declare end point you want consume in api_constants.dart in given format.
 ```dart
 static const String LOGIN = "/api/login";
 ```

 2.  Create **URI** with **base URL** and **end point** in your function

 ```dart
//  baseURL here is Getter of String type that returns your base URL from
//  api_constants.dart and is directly accesibile.

Uri _loginUri = Uri.parse(baseURL + ApiConstants.LOGIN);
 ```

 - Use ApiHelper class it contains plug and play REST callers
 -  ApiHelper have 2 types of caller
    - Plug and Play  This requires BuildContext and contains common loader and alert dialog built in
    - BG : This doesn't requires context can be called in Background but it doesn't contains UI elements everything will be handled by developer.


 ```dart
Map map =  { "email": "eve.holt@reqres.in","password": "cityslicka" }


// If showConnectivityError is set to false will Throw NoNetworkException in case of no connectivity.
// showConnectivityError: false allows developer to handle no connectivity exception manually.
// Plug and Play with common loader and dialog
ResponseData responseData =
    await ApiHelper().postRequest(context, _loginUri, map,
          useAuth: false, showLoader: true, responseName: "Login",
          showLog: true, showError: true, showConnectivityError: true);

// Background callers without loader and dialog
// Throws NoNetworkException in case of no nonnectivity.

try {
  ResponseData responseData =
    await ApiHelper().postRequestBG(_loginUri,map,useAuth: false,showLog: true);
} on NoNetworkException {
     print("Please Check Internet Connection");
     //Handle error on UI if using BG callers
}

```

3.  Check response and consume.
 ```dart
if (responseData.okAndContainsData ) {
   print(responseData.data['message'])
   // Do success stuff here.
}else if(responseData.statusCode == 500){
   // Handle 500.
}else{
   // Handle everthing else.
}

```
<br>
<br>

 ## 5. Navigation

**Description**

Navigation is context less, a global key is passed in top level MaterialApp which takes care of navigation. Routes is saved  in static variable named viewModelsMapper.



Responsible file

 - navigation_helper.dart

####  Things to take care of

 - Always provide Navigation TAG - All views have their own specific tag
 ```dart
 static const String TAG = "/LoginView";
 ```
These tags help to easily access and switch to views
 - Register path in routes - in main.dart register paths to their respective view.
  ```dart
routes: {
  CustomURLView.TAG: (context) =>
    NavigationHelper.viewModelsMapper[CustomURLView.TAG]!,
},
```

 - Usage

```dart
NavigationHelper.instance.goToScreen(screenName: LoginView.TAG);
```

 - With Args
```dart
NavigationHelper.instance.goToScreen(
  screenName: LoginView.TAG, args: {"someObject": Object()});
```

 ## 6. Localisation

**Description**

Localisation is achieved with the help of EasyLocalisation Plugin. Localisation is straight forward and easy



Responsible file

 - locale_constants.dart

####  Things to take care of

 - Most of the things are configured and 3 example languages and their respective JSON and configs are added in projects
 - When adding new language add respective JSON and add language configs in locale_constants.dart.

To use just add .tr() extension on Strings

e.g

 ```dart
AppConstants.APP_NAME.tr()
 ```

You'll have to import this manually
  ```dart
import 'package:easy_localization/easy_localization.dart';
```


 - To change

```dart
EasyLocalization.of(context)!.setLocale(LocaleConstants.HINDI);
```

 - To get
```dart
Locale currentLanguage = context.locale;
```