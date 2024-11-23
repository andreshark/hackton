import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_neat_and_clean_calendar/flutter_neat_and_clean_calendar.dart';
import 'package:med_hackton/data/model/medicine.dart';
import 'package:med_hackton/data/model/sugar.dart';
import 'package:med_hackton/presentation/bloc/local_data/local_data_bloc.dart';
import 'package:med_hackton/presentation/pages/metric_page.dart';
import 'package:med_hackton/presentation/pages/metric_page_sugar.dart';
import 'package:med_hackton/presentation/widgets/dose_active_dialog1.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../data/model/dose.dart';
import '../../data/model/dose_active.dart';
import '../../data/model/pulse.dart';
import '../widgets/dose_active_dialog.dart';
import 'add_medicine_page.dart';

Widget CalendarPage(BuildContext context, LocalDataBloc localDataBloc) {
  List<Color> colors = [
    Colors.blue,
    Colors.green,
    Colors.purple,
    Colors.pink,
    Colors.teal,
    Colors.red,
  ];
  final List<NeatCleanCalendarEvent> _eventList2 = [];
  for (Medicine medicine in localDataBloc.medicines) {
    if (medicine.startTreatment == null) {
      for (Dose dose in medicine.doses) {
        DateTime date = DateTime.now();
        for (int i = 0; i < 90; i++) {
          if (date.day != DateTime.now().day) {
            _eventList2.add(NeatCleanCalendarEvent(
              'Принять лекарство ${medicine.name}',
              description: '${dose.dosage} ${medicine.unit}',
              startTime: DateTime(
                date.year,
                date.month,
                date.day,
                dose.hour,
                dose.minute,
              ),
              endTime: DateTime(
                  date.year, date.month, date.day, dose.hour, dose.minute),
              color: colors[localDataBloc.medicines.indexOf(medicine)],
            ));
          }
          date = date.add(const Duration(days: 1));
        }
      }
    } else {
      for (Dose dose in medicine.doses) {
        DateTime date = medicine.startTreatment!;
        for (date;
            date.isBefore(medicine.endTreatment!) ||
                date.isAtSameMomentAs(medicine.endTreatment!);
            date = date.add(const Duration(days: 1))) {
          if (date.day != DateTime.now().day) {
            _eventList2.add(NeatCleanCalendarEvent(
              'Принять лекарство ${medicine.name}',
              description: '${dose.dosage} ${medicine.unit}',
              startTime: DateTime(
                date.year,
                date.month,
                date.day,
                dose.hour,
                dose.minute,
              ),
              endTime: DateTime(
                  date.year, date.month, date.day, dose.hour, dose.minute),
              color: colors[localDataBloc.medicines.indexOf(medicine)],
            ));
          }
        }
      }
    }
  }

  final List<NeatCleanCalendarEvent> _eventList1 = List.generate(
      localDataBloc.allActiveDoses.length,
      (index) => NeatCleanCalendarEvent(
            metadata: {'index': index},
            localDataBloc.allActiveDoses[index].doseState == DoseState.accepted
                ? 'Лекарство принято ${localDataBloc.allActiveDoses[index].medicine.name}'
                : localDataBloc.allActiveDoses[index].doseState ==
                        DoseState.missed
                    ? 'Забыли принять лекарство  ${localDataBloc.allActiveDoses[index].medicine.name}'
                    : 'Принять лекарство ${localDataBloc.allActiveDoses[index].medicine.name}',
            description:
                '${localDataBloc.allActiveDoses[index].dose.dosage} ${localDataBloc.allActiveDoses[index].medicine.unit}',
            startTime: DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
              localDataBloc.allActiveDoses[index].dose.hour,
              localDataBloc.allActiveDoses[index].dose.minute,
            ),
            endTime: DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day,
                localDataBloc.allActiveDoses[index].dose.hour,
                localDataBloc.allActiveDoses[index].dose.minute),
            color: colors[localDataBloc.medicines
                .indexOf(localDataBloc.allActiveDoses[index].medicine)],
          ));
  final List<NeatCleanCalendarEvent> _eventListPulse = List.generate(
      localDataBloc.pulses.length,
      (index) => NeatCleanCalendarEvent(
            //metadata: {'index': index},
            'Пульс',
            description: '${localDataBloc.pulses[index].pulsecount} УД/МИН',
            startTime: DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
              localDataBloc.pulses[index].date.hour,
              localDataBloc.pulses[index].date.minute,
            ),
            endTime: DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day,
                localDataBloc.pulses[index].date.hour,
                localDataBloc.pulses[index].date.minute),
            color: Colors.redAccent,
          ));

  final List<NeatCleanCalendarEvent> _eventListSugar = List.generate(
      localDataBloc.sugars.length,
      (index) => NeatCleanCalendarEvent(
            //metadata: {'index': index},
            'Уровень сахара в крови',
            description: '${localDataBloc.sugars[index].sugarcount} ММОЛЬ/Л',
            startTime: DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
              localDataBloc.sugars[index].date.hour,
              localDataBloc.sugars[index].date.minute,
            ),
            endTime: DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day,
                localDataBloc.sugars[index].date.hour,
                localDataBloc.sugars[index].date.minute),
            color: const Color.fromARGB(255, 218, 215, 215),
          ));

  final List<NeatCleanCalendarEvent> _eventListDoctors = List.generate(
      localDataBloc.doctors.length,
      (index) => NeatCleanCalendarEvent(
            //metadata: {'index': index},
            'Запись к врачу',
            description: 'Врач ${localDataBloc.doctors[index].name}',
            startTime: DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
              localDataBloc.doctors[index].date.hour,
              localDataBloc.doctors[index].date.minute,
            ),
            endTime: DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day,
                localDataBloc.doctors[index].date.hour,
                localDataBloc.doctors[index].date.minute),
            color: const Color.fromARGB(255, 80, 197, 243),
          ));

  final List<NeatCleanCalendarEvent> _eventListEmotions = List.generate(
      localDataBloc.emotions.length,
      (index) => NeatCleanCalendarEvent(
            //metadata: {'index': index},
            'Запись самочувствия',
            description: 'самочувствие ${localDataBloc.emotions[index].rate}/5',
            startTime: DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
              localDataBloc.emotions[index].date.hour,
              localDataBloc.emotions[index].date.minute,
            ),
            endTime: DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day,
                localDataBloc.emotions[index].date.hour,
                localDataBloc.emotions[index].date.minute),
            color: const Color.fromARGB(255, 80, 83, 243),
          ));

  List<NeatCleanCalendarEvent> list1 = _eventListPulse;
  list1.addAll(_eventListEmotions);
  list1.addAll(_eventListDoctors);
  list1.addAll(_eventListSugar);
  list1.addAll(_eventList1);
  list1.sort(
    (a, b) {
      if (a.startTime.isBefore(b.startTime)) {
        return -1;
      } else if (a.startTime.isAtSameMomentAs(b.startTime)) {
        return 0;
      }
      return 1;
    },
  );
  return Column(children: [
    SizedBox(
      height: 15,
    ),
    Wrap(
      spacing: 10,
      runSpacing: 10,
      children: List.generate(
          localDataBloc.medicines.length,
          (index) => Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                decoration: BoxDecoration(
                    color: colors[index],
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Text(localDataBloc.medicines[index].name),
              )),
    ),
    SizedBox(
      height: 15,
    ),
    Expanded(
        child: Calendar(
      hideArrows: true,
      hideTodayIcon: true,
      startOnMonday: true,
      eventsList: list1 + _eventList2,
      weekDays: [
        'понедель.',
        'вторник',
        'среда',
        'четверг',
        'пятница',
        'суббота',
        'воск.'
      ],
      isExpandable: true,
      eventDoneColor: Colors.green,
      selectedColor: Colors.pink,
      selectedTodayColor: Colors.red,
      todayColor: Colors.blue,
      eventColor: null,
      locale: 'ru_Ru',
      todayButtonText: DateTime.now().weekday.toString(),
      allDayEventText: 'Все дни',
      multiDayEndText: 'Конец',
      isExpanded: true,
      expandableDateFormat: 'EEEE, dd. MMMM yyyy',
      datePickerType: DatePickerType.date,
      dayOfWeekStyle: TextStyle(
          color: Colors.black, fontWeight: FontWeight.w800, fontSize: 11),
      onEventSelected: (value) {
        if (value.metadata != null) {
          final int index = value.metadata!['index'];
          showDoseActiveDialog1(
              context,
              localDataBloc,
              localDataBloc.allActiveDoses
                  .indexOf(localDataBloc.allActiveDoses[index]));
        }
      },
    )),
    SizedBox(
      height: 70,
    )
  ]);
}
