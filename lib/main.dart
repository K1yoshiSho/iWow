import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:i_wow/notifications/screens/initial_page_widget.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
  static _MyAppState of(BuildContext context) => context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  bool displaySplashImage = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 1500), () => setState(() => displaySplashImage = false));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'iWow',
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: Locale('ru'),
      supportedLocales: const [
        Locale('ru'),
      ],
      theme: ThemeData(brightness: Brightness.light, useMaterial3: true),
      themeMode: ThemeMode.light,
      home: displaySplashImage
          ? Builder(
              builder: (context) => Container(
                child: Image.asset(
                  'assets/images/splashScreen.png',
                  fit: BoxFit.cover,
                ),
              ),
            )
          : InitialPageWidget(),
    );
  }
}
