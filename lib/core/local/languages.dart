import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

List<LanguageDataModel> languagesModels = [
  LanguageDataModel(
      id: 1, name: 'English', languageCode: 'en', fullLanguageCode: 'en-US', flag: 'assets/images/ic_us.png'),
  LanguageDataModel(
      id: 2, name: 'Arabic', languageCode: 'ar', fullLanguageCode: 'ar-AR', flag: 'assets/images/ic_ar.png'),
];

abstract class BaseLanguage {
  static BaseLanguage of(BuildContext context) => Localizations.of<BaseLanguage>(context, BaseLanguage)!;

  String get appName;
}
