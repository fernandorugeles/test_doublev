import 'package:doule_v/constants/theme.dart';
import 'package:doule_v/feature/dashboard/dashboard_screen.dart';
import 'package:doule_v/feature/create_user/create_user_dasboard_screen.dart';
import 'package:doule_v/feature/search_user/search_user_dasboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:doule_v/l10n/app_localizations.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'DoubleV',
      home: const DashboardScreen(),
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'OpenSans',
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.bgColorScreen),
      ),
      initialRoute: '/dashboard',
      routes: {
        '/dashboard': (_) => const DashboardScreen(),
        '/create_users': (_) => const CreateUserDasboardScreen(),
        '/search_users': (_) => const SearchUserDasboardScreen(),
      },
      supportedLocales: const [Locale('en'), Locale('es')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: const Locale('es'),
    );
  }
}
