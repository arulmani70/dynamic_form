import 'package:dynamic_form/src/form_manager/form_renderer/repo/form_loader_repository.dart';
import 'package:flutter/material.dart';
import 'package:dynamic_form/src/app/app.dart';

import 'package:dynamic_form/src/common/common.dart';
import 'package:dynamic_form/src/common/services/services_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupLocator();

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => getIt<PreferencesRepository>()),
        RepositoryProvider<ApiRepository>(
          create: (context) => getIt<ApiRepository>(),
        ),
        RepositoryProvider(create: (_) => getIt<FormLoaderRepository>()),
      ],

      child: const App(),
    ),
  );
}
