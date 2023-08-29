import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:structure/common/platform_info.dart';

class AppBackdrop extends StatelessWidget {
  const AppBackdrop({
    Key? key,
    this.strength = 1,
    this.child,
  }) : super(key: key);

  final double strength;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final double normalStrength = clampDouble(strength, 0, 1);
    if (!PlatformInfo.isAndroid) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: normalStrength * 5.0, sigmaY: normalStrength * 5.0),
        child: child ?? SizedBox.expand(),
      );
    }
    final fill = Container(color: Colors.black.withOpacity(.8 * strength));
    return child == null
        ? fill
        : Stack(
            children: [
              child!,
              Positioned.fill(child: fill),
            ],
          );
  }
}
