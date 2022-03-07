import 'package:flutter/material.dart';

class LocaleConstants {
  static const Locale ENGLISH = Locale('en');
  static const Locale HINDI = Locale('hi');
  static const Locale KANNADA = Locale('kn');

  static const List<Locale> SUPPORTED_LOCALES = [
    LocaleConstants.ENGLISH,
    LocaleConstants.HINDI,
    LocaleConstants.KANNADA,
  ];
}
