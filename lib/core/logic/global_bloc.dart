import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:structure/configure_di.dart';
import 'package:structure/core/app_store/app_store.dart';

part 'global_event.dart';

part 'global_state.dart';

class GlobalBloc extends Bloc<GlobalEvent, GlobalState> {
  GlobalBloc()
      : super(GlobalState.initial(
            languageCode: getIt<AppStore>().selectedLanguageCode, isDarkTheme: getIt<AppStore>().isDarkMode)) {

    on<LanguageChanged>((event, emit) {
      emit(state.copyWith(languageCode: event.language));
    });

    on<ThemeChanged>((event, emit) {
      emit(state.copyWith(isDarkTheme: event.isDark));
    });
  }
}
