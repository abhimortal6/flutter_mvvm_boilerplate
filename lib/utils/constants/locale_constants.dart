import 'package:flutter/material.dart';

class LocaleConstants {
  static const Locale ENGLISH = Locale('en');
  static const Locale Hindi = Locale('hi');
  static const Locale Kannada = Locale('kn');
  static const List<Locale> SUPPORTED_LOCALES = [
    LocaleConstants.ENGLISH,
    LocaleConstants.Hindi,
    LocaleConstants.Kannada,
  ];
}
