import 'dart:io';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:med_hackton/commons/notifications.dart';
import 'presentation/bloc/local_data/local_data_bloc.dart';
import 'presentation/pages/navigator_page.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_timezone/flutter_timezone.dart';

void main() async {
  // LocalNotificationService.initialize();
  WidgetsFlutterBinding.ensureInitialized();
  // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin()
  //       ..initialize(const InitializationSettings(
  //           android: AndroidInitializationSettings('app_icon')));
  // // flutterLocalNotificationsPlugin
  // //     .resolvePlatformSpecificImplementation<
  // //         AndroidFlutterLocalNotificationsPlugin>()!
  // //     .requestNotificationsPermission();
  await _configureLocalTimeZone();
  initializeDateFormatting('ru_Ru', null)
      .then((_) => runApp(MultiBlocProvider(providers: [
            BlocProvider<LocalDataBloc>(
              create: (context) => LocalDataBloc(),
            ),
          ], child: const MainApp())));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Ваше здоровье',
        theme: ThemeData(
            scaffoldBackgroundColor: const Color(0xffF0F3F8),
            colorScheme:
                ColorScheme.fromSeed(seedColor: const Color(0xff256FFF)),
            inputDecorationTheme: const InputDecorationTheme(
              enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Colors.white), // change color you want...
              ),
              fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide(style: BorderStyle.none)),
            ),
            appBarTheme: AppBarTheme(backgroundColor: Colors.white),
            outlinedButtonTheme: OutlinedButtonThemeData(
                style: ButtonStyle(
              shape: const WidgetStatePropertyAll(RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(6)))),
              elevation: const WidgetStatePropertyAll(10),
            )),
            filledButtonTheme: FilledButtonThemeData(
                style: ButtonStyle(
              shape: const WidgetStatePropertyAll(RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(6)))),
              elevation: const WidgetStatePropertyAll(10),
              backgroundColor: WidgetStateProperty.resolveWith<Color?>(
                (Set<WidgetState> states) {
                  if (states.contains(WidgetState.pressed)) {
                    return const Color(0xff00369F);
                  }
                  return const Color(0xff256FFF);
                },
              ),
            ))
            // appBarTheme: AppBarTheme(
            //     systemOverlayStyle: SystemUiOverlayStyle(
            //         systemNavigationBarColor: ThemeData(
            //             colorScheme: ColorScheme.fromSeed(
            //   seedColor: Color(0xff256FFF),
            // )).colorScheme.surface))
            ),
        home: const NavigatorPage());
  }
}

Future<void> _configureLocalTimeZone() async {
  if (kIsWeb || Platform.isLinux) {
    return;
  }
  tz.initializeTimeZones();
  if (Platform.isWindows) {
    return;
  }
  final String? timeZoneName = await FlutterTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName!));
}
