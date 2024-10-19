import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:intl/intl_standalone.dart' if (dart.library.html) 'package:intl/intl_browser.dart';
import 'package:provider/provider.dart';
import 'app/providers/ingresos_provider.dart';
import 'app/providers/residentes_providers.dart';
import 'app/providers/session_provider.dart';
import 'app/providers/user_provider.dart';
import 'app/providers/vehiculo_provider.dart';
import 'app/providers/vistante_providers.dart';
import 'view/SplashScreen.dart';
import 'view/ingresos/ingreso_main_view.dart';
import 'view/login/create_login_view.dart';
import 'view/login/login_responsive.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await findSystemLocale();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
        ChangeNotifierProvider<SessionProvider>(
            create: (_) => SessionProvider()),
        ChangeNotifierProvider<VisitanteProvider>(
            create: (_) => VisitanteProvider()),
        ChangeNotifierProvider<IngresosProvider>(
            create: (_) => IngresosProvider()),
        ChangeNotifierProvider<VehiculoProvider>(
            create: (_) => VehiculoProvider()),
        ChangeNotifierProvider<ResidentesProvider>(
            create: (_) => ResidentesProvider()),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'SEA',
        theme: ThemeData(
            outlinedButtonTheme: OutlinedButtonThemeData(
                style: ButtonStyle(
              visualDensity: VisualDensity.adaptivePlatformDensity,
            )),
            visualDensity: VisualDensity.adaptivePlatformDensity,
            useMaterial3: true
            // textTheme: GoogleFonts.poppinsTextTheme(),
            ),
        localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
          GlobalWidgetsLocalizations.delegate,
          ...GlobalMaterialLocalizations.delegates,
          ...GlobalCupertinoLocalizations.delegates,
        ],
        supportedLocales: [Locale("es")],
        darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        routes: {
          '/': (_) => const SplashScreen(),
          '/login': (_) => const LoginResponsive(),
          '/createPage': (_) => const CreateUserView(),
          '/ingresosview': (_) => const IngresoView()
        },
        initialRoute: '/',
      ),
    );
  }
}
