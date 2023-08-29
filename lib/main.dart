import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:structure/core/logic/global_bloc.dart';
import 'app_theme.dart';
import 'configure_di.dart';
import 'core/app_store/app_store.dart';
import 'core/local/app_localization.dart';
import 'core/local/languages.dart';
import 'core/local/languages/language_en.dart';

BaseLanguage language = LanguageEn();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureInjection();
  await initialize();
  localeLanguageList = languagesModels;
  getIt<AppStore>().initial();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GlobalBloc(),
      child: BlocBuilder<GlobalBloc, GlobalState>(
        builder: (context, state) {
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme(),
              darkTheme: AppTheme.darkTheme(),
              themeMode: getIt<AppStore>().isDarkMode ? ThemeMode.dark : ThemeMode.light,
              localizationsDelegates: const [
                AppLocalizations(),
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: LanguageDataModel.languageLocales(),
              localeResolutionCallback: (locale, supportedLocales) => locale,
              locale: Locale(getIt<AppStore>().selectedLanguageCode),
              home: const SafeArea(child: Scaffold(body: Placeholder())));
        },
      ),
    );
  }
}
