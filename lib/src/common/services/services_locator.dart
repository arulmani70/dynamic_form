import 'package:dio/dio.dart';
import 'package:dynamic_form/src/common/repos/prefences_repository.dart';
import 'package:dynamic_form/src/common/repos/api_repository.dart';
import 'package:dynamic_form/src/form_manager/form_renderer/repo/form_loader_repository.dart';

import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupLocator() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);

  getIt.registerSingleton<PreferencesRepository>(
    PreferencesRepository(sharedPreferences),
  );

  getIt.registerSingleton<Dio>(Dio());

  getIt.registerSingleton<ApiRepository>(
    ApiRepository(getIt<Dio>(), getIt<PreferencesRepository>()),
  );
  getIt.registerLazySingleton<FormLoaderRepository>(
    () => FormLoaderRepository(),
  );
}
