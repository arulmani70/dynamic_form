import 'package:dynamic_form/src/common/widgets/file_not_found.dart';
import 'package:dynamic_form/src/form/views/dynamic_form_page.dart';
import 'package:dynamic_form/src/form_manager/demo/demo_page.dart';
import 'package:dynamic_form/src/form_manager/form_renderer/dynamic_form_renderer.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:dynamic_form/src/app/route_names.dart';
import 'package:logger/logger.dart';
import 'package:dynamic_form/src/common/widgets/splashscreen.dart';

class Routes {
  final log = Logger();

  GoRouter router = GoRouter(
    routes: [
      GoRoute(
        name: RouteNames.splashscreen,
        path: "/",
        builder: (BuildContext context, GoRouterState state) {
          return const SplashScreen();
        },
      ),

      GoRoute(
        name: RouteNames.dynamicform,
        path: '/dynamicform',
        builder: (context, state) => DynamicFormPage(),
      ),
      GoRoute(
        path: '/form_render',
        name: RouteNames.renderer,
        builder: (context, state) {
          final json = state.extra! as List<Map<String, dynamic>>;
          return BlocProvider(
            create: (_) => DFRendererBloc()..add(DFRendererInitialized(json)),
            child: const DynamicFormRendererPage(),
          );
        },
      ),

      GoRoute(
        name: RouteNames.demoform,
        path: '/demoform',
        builder: (context, state) => DynamicFormDemoPage(),
      ),
    ],
    redirect: (context, state) {
      final loc = state.matchedLocation;

      if (loc == '/form_render' || loc == '/demoform' || loc == '/')
        return null;

      return '/demoform';
    },

    debugLogDiagnostics: true,
    errorBuilder: (contex, state) {
      return FileNotFound(message: "${state.error?.message}");
    },
  );
}
