import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:structure/core/local/languages/language_ar.dart';
import '../../main.dart';
import '../local/app_localization.dart';
import '../local/languages/language_en.dart';
import 'dart:ui' as ui;
import '../utils/functions.dart';

class AppStore {
  bool isDarkMode = false;

  String selectedLanguageCode = ui.window.locale.languageCode;

  final double defaultWidth = 360;
  final double defaultHeight = 690;

  double width = 0;
  double height = 0;

  initial() {
    Size screenSize = MediaQueryData.fromWindow(WidgetsBinding.instance.window).size;
    Orientation orientation = MediaQueryData.fromWindow(WidgetsBinding.instance.window).orientation;
    if (orientation == Orientation.portrait) {
      width = screenSize.width;
      height = screenSize.height;
    } else {
      width = screenSize.height;
      height = screenSize.width;
    }
    Functions.printDone("=> Done adding device size .");

    selectedLanguageCode = getStringAsync(SELECTED_LANGUAGE_CODE, defaultValue: ui.window.locale.languageCode);
    selectedLanguageCode == "en" ? language = LanguageEn() : language = LanguageAr();
    Functions.printDone("=> Done adding device language .");

    int themeIndex = getIntAsync(THEME_MODE_INDEX, defaultValue: 0);
    isDarkMode = isDarkMode = themeIndex == 1
        ? false
        : themeIndex == 2
            ? true
            : ui.window.platformBrightness.name == "dark";
    Functions.printDone("=> Done adding device theme .");
  }

  Future<void> setDarkMode(int themeIndex) async {
    isDarkMode = themeIndex == 1
        ? false
        : themeIndex == 2
            ? true
            : ui.window.platformBrightness.name == "dark";

    await setValue(THEME_MODE_INDEX, isDarkMode);
  }

  Future<void> setLanguage(String val) async {
    selectedLanguageCode = val;
    selectedLanguageDataModel = getSelectedLanguageModel(defaultLanguage: selectedLanguageCode);

    await setValue(SELECTED_LANGUAGE_CODE, selectedLanguageCode);

    language = await const AppLocalizations().load(Locale(selectedLanguageCode));
  }
}
