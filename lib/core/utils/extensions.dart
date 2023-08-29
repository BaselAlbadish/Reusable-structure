import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:structure/configure_di.dart';
import 'package:structure/core/app_store/app_store.dart';

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}

extension PercentSized on double {
  double get h => ((this * getIt<AppStore>().height) / getIt<AppStore>().defaultHeight);

  double get w => ((this * getIt<AppStore>().width) / getIt<AppStore>().defaultWidth);

  double get sp =>
      ((getIt<AppStore>().width * getIt<AppStore>().height) * this) /
      (getIt<AppStore>().defaultHeight * getIt<AppStore>().defaultWidth);
}

extension HexColor on Color {
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}
