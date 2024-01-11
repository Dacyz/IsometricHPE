import 'package:app_position/core/const.dart';
import 'package:app_position/features/providers/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() {
  // Ensure that widget binding is initialized. This is required before running the app.
  WidgetsFlutterBinding.ensureInitialized();
  // Set the preferred device orientations. In this case, we only allow portrait up.
  SystemChrome.setPreferredOrientations(const [DeviceOrientation.portraitUp]);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Settings()),
      ],
      child: MaterialApp(
        title: 'App Position',
        routes: AppConstants.routes,
        theme: ThemeData.light().copyWith(
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            foregroundColor: Colors.blue,
          ),
          iconTheme: const IconThemeData(
            color: Colors.blue,
          ),
          iconButtonTheme: IconButtonThemeData(
              style: TextButton.styleFrom(
            foregroundColor: Colors.blue,
          )),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: Colors.blue,
              iconColor: Colors.blue,
            ),
          ),
        ),
        darkTheme: ThemeData.dark(),
        initialRoute: AppConstants.initialRoute,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
