import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:structure/configure_di.dart';
import 'package:structure/core/app_store/app_store.dart';
import '../logic/global_bloc.dart';

class OurThemeWidget extends StatefulWidget {
  const OurThemeWidget({Key? key}) : super(key: key);

  @override
  State<OurThemeWidget> createState() => _OurThemeWidgetState();
}

class _OurThemeWidgetState extends State<OurThemeWidget> {
  @override
  Widget build(BuildContext context) {
    return ThemeWidget(
      subTitle: "theme",
      onThemeChanged: (index) {
        getIt<AppStore>().setDarkMode(index);
        context.read<GlobalBloc>().add(ThemeChanged(getIt<AppStore>().isDarkMode));
        setState(() {});
        finish(context,true);
      },
    );
  }
}
