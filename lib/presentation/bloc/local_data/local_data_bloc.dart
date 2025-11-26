import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart';
import 'package:med_hackton/commons/constants.dart';
import 'package:med_hackton/data/model/doctor.dart';
import 'package:med_hackton/data/model/dose_active.dart';
import 'package:med_hackton/data/model/emotions.dart';
import 'package:med_hackton/data/model/medicine.dart';
import 'package:med_hackton/data/model/pulse.dart';
import 'package:med_hackton/data/model/sugar.dart';
import 'package:med_hackton/presentation/bloc/local_data/local_data_state.dart';
import 'package:timezone/timezone.dart' as tz;
import '../../../data/model/dose.dart';
import '../../../main.dart';
import 'package:http/http.dart' as http;

class LocalDataBloc extends Cubit<LocalDataState> {
  LocalDataBloc()
      : super(LocalDataState(
            medicines: [],
            pulses: [],
            sugars: [],
            allActiveDoses: [],
            emotions: [],
            summary: '',
            doctors: [
              Doctor(name: 'Терапевт', date: DateTime(2024, 11, 23, 17, 0)),
              Doctor(name: 'Зубной', date: DateTime(2024, 11, 28, 14, 0))
            ])) {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestNotificationsPermission();
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) async {
        debugPrint(notificationResponse.payload);
      },
      onDidReceiveBackgroundNotificationResponse: (response) {
        if (response.payload != null) {
          debugPrint(response.payload);
        }
      },
    );
  }
  int id = 0;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  List<ActiveDose> get lastActiveDoses {
    List<ActiveDose> doses = [];

    for (ActiveDose activeDose in allActiveDoses) {
      if ((activeDose.dose.hour == DateTime.now().hour &&
              activeDose.dose.minute >= DateTime.now().minute) ||
          activeDose.dose.hour > DateTime.now().hour) {
        doses.add(activeDose);
      }
    }
    doses.sort((a, b) {
      if (a.dose.hour.compareTo(b.dose.hour) == 0) {
        return a.dose.minute.compareTo(b.dose.minute);
      }
      return a.dose.hour.compareTo(b.dose.hour);
    });
    return doses;
  }

  void addSugar(Sugar sugar) {
    List<Sugar> sugars1 = List.from(sugars);
    sugars1.add(sugar);
    sugars1.sort((a, b) => a.date.compareTo(b.date));

    emit(state.copyWith(sugars: sugars1));
  }

  List<ActiveDose> get allActiveDoses => state.allActiveDoses!;

  List<Emotions> get emotions => state.emotions!;
  set emotions(List<Emotions> emotions) {
    emit(state.copyWith(emotions: emotions));
  }

  List<Sugar> get sugars => state.sugars!;
  set sugars(List<Sugar> sugars) {
    emit(state.copyWith(sugars: sugars));
  }

  List<Doctor> get doctors => state.doctors!;
  set doctors(List<Doctor> doctors) {
    emit(state.copyWith(doctors: doctors));
  }

  void addPulse(Pulse pulse) {
    List<Pulse> pulses1 = List.from(pulses);
    pulses1.add(pulse);
    pulses1.sort((a, b) => a.date.compareTo(b.date));

    emit(state.copyWith(pulses: pulses1));
  }

  List<Pulse> get pulses => state.pulses!;
  set pulses(List<Pulse> pulses) {
    emit(state.copyWith(pulses: pulses));
  }

  List<Medicine> get medicines => state.medicines!;
  set medicines(List<Medicine> medicines) {
    emit(state.copyWith(medicines: medicines));
  }

  Future<http.Response> sendData() {
    Map<String, dynamic> h = <String, dynamic>{
      'medicine': medicines.map((a) => a.toJson()).toList().toString(),
      'health_status': emotions.map((a) => a.toJson()).toList().toString(),
      'pulse': pulses.map((a) => a.toJson()).toList().toString(),
      'blood_sugar_level': sugars.map((a) => a.toJson()).toList().toString(),
    };
    debugPrint(h.toString());
    return http.post(
      Uri.parse('http:/localhost:5000/indicators'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(h),
    );
  }

  Future<void> getSummary() async {
    Response response = await sendData();
    if (response.statusCode == 200 && response.body != 'null') {
      emit(state.copyWith(summary: response.body));
    }
  }

  void updateDoseState(ActiveDose dose, DoseState state1) {
    List<Medicine> medicines = List.from(state.medicines!);
    List<ActiveDose> doses = List.from(state.allActiveDoses!);
    final int indexDose = doses.indexOf(dose);
    if (state1 == DoseState.accepted && dose.medicine.remains != null) {
      List<Medicine> medicines = List.from(state.medicines!);
      medicines[medicines.indexOf(dose.medicine)] =
          dose.medicine.copyWith(dose.medicine.remains! - 1);
    } else if (state1 == DoseState.waiting) {
      doses[indexDose] = dose.copyWith(
          dose: dose.dose.copyWith(minute: dose.dose.minute + 10));
    }

    doses[indexDose] = doses[indexDose].copyWith(doseState: state1);
    emit(state.copyWith(allActiveDoses: doses, medicines: medicines));
  }

  void addMedicine(Medicine medicine, Medicine? medicine1) {
    List<Medicine> medicines1 = List.from(medicines);
    if (medicine1 == null) {
      medicines1.add(medicine);
    } else {
      medicines1[medicines1.indexOf(medicine1)] = medicine;
    }
    List<ActiveDose> doses = [];
    for (Medicine medicine in medicines1) {
      if (medicine.startTreatment == null ||
          medicine.startTreatment!.day <= DateTime.now().day)
        for (Dose dose in medicine.doses) {
          doses.add(ActiveDose(
              medicine: medicine, dose: dose, doseState: DoseState.waiting));
        }
    }
    doses.sort((a, b) {
      if (a.dose.hour.compareTo(b.dose.hour) == 0) {
        return a.dose.minute.compareTo(b.dose.minute);
      }
      return a.dose.hour.compareTo(b.dose.hour);
    });

    for (Dose dose in medicine.doses) {
      notification1(
          medicine.name, medicine.unit, dose.hour, dose.minute, dose.dosage);
    }

    emit(state.copyWith(medicines: medicines1, allActiveDoses: doses));
  }

  Future<void> notification1(name, type, hour, minute, dosage) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        id++,
        'Время принять лекарство $name',
        '$dosage $type',
        tz.TZDateTime(tz.local, DateTime.now().year, DateTime.now().month,
            DateTime.now().day, hour, minute),
        const NotificationDetails(
            android: AndroidNotificationDetails(
          sound: RawResourceAndroidNotificationSound('hello'),
          playSound: true,
          'your channel id',
          'your channel name',
          channelDescription: 'your channel description',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
        )),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  Future<void> showNotification() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            'У вас запись к врачу терапевт', 'Запись на 17:00',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(id++,
        'У вас запись к врачу терапевт', 'Запись на 17:00', notificationDetails,
        payload: 'item x');
  }
}
