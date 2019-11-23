import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'core/router/route_paths.dart';
import 'core/router/router.dart';
import 'core/theme/custom_theme.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // no need to init hive for browser
  if (!kIsWeb) {
    // init Hive for mobile
    Hive.init((await path_provider.getApplicationDocumentsDirectory()).path);
  }

  // dependency injection
  await di.init();

  // init logging of BLoC transitions
  initBlocLogging();

  // run the app
  runApp(MyApp());
}

void initBlocLogging() {
  // only in debug mode
  if (!kReleaseMode) {
    BlocSupervisor.delegate = SimpleBlocDelegate();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '2048 flutter game',
      theme: CustomTheme.themeData,
      initialRoute: RoutePaths.Game,
      onGenerateRoute: Router.generateRoute,
    );
  }
}

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    print(event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
    print(error);
  }
}
