import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:structure/configure_di.dart';
import 'package:structure/core/app_store/app_store.dart';
import 'package:structure/core/logic/global_bloc.dart';

class LanguagesWidget extends StatefulWidget {
  const LanguagesWidget({super.key});

  @override
  LanguagesWidgetState createState() => LanguagesWidgetState();
}

class LanguagesWidgetState extends State<LanguagesWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LanguageListWidget(
        widgetType: WidgetType.LIST,
        onLanguageChange: (v) {
          getIt<AppStore>().setLanguage(v.languageCode!);
          context.read<GlobalBloc>().add(LanguageChanged(v.languageCode!));
          setState(() {});
          finish(context, true);
        },
      );
  }
}
