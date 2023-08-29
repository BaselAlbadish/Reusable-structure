import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:structure/core/app_store/app_store.dart';
import 'core/data/local_data/local_data_source.dart';
import 'core/data/remote_data/network_client_http.dart';

final getIt = GetIt.instance;

Future<void> configureInjection() async {
  /// data sources
  final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  final AppStore appStore = AppStore();

  getIt.registerSingleton<NetworkClient>(NetworkClientHttp());

  getIt.registerSingleton<SharedPreferences>(sharedPreferences);
  getIt.registerSingleton<LocalDataSource>(LocalDataSourceSharedPreferences(getIt()));

  getIt.registerSingleton<AppStore>(appStore);

}
