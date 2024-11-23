import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:med_hackton/data/model/dose_active.dart';
import 'package:med_hackton/data/model/sugar.dart';
import 'package:med_hackton/presentation/bloc/local_data/local_data_bloc.dart';
import 'package:med_hackton/presentation/pages/metric_page.dart';
import 'package:med_hackton/presentation/pages/metric_page_sugar.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:reorderables/reorderables.dart';
import '../../data/model/pulse.dart';
import '../widgets/dose_active_dialog.dart';
import 'add_medicine_page.dart';

Widget HomePage(BuildContext context, LocalDataBloc localDataBloc) {
  final List<Pulse> chartData = [
    Pulse(date: DateTime(2024, 11, 17, 17, 40, 20), pulsecount: 87),
    Pulse(date: DateTime(2024, 11, 18, 16, 40, 20), pulsecount: 90),
    Pulse(date: DateTime(2024, 11, 19, 16, 50, 20), pulsecount: 85),
    Pulse(date: DateTime(2024, 11, 20, 18, 40, 20), pulsecount: 76),
    Pulse(date: DateTime(2024, 11, 20, 19, 40, 20), pulsecount: 90),
    Pulse(date: DateTime(2024, 11, 20, 20, 40, 20), pulsecount: 80),
  ];
  return CustomScrollView(slivers: [
    SliverPersistentHeader(
      delegate: MySliverAppBar(
        expandedHeight: 210,
      ),
      pinned: true,
    ),
    SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        sliver: SliverList.list(children: [
          Column(children: [
            localDataBloc.state.summary!.isEmpty
                ? SizedBox.shrink()
                : SizedBox(
                    height: 15,
                  ),
            localDataBloc.state.summary!.isEmpty
                ? SizedBox.shrink()
                : Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: ExpansionTile(
                      title: Text('Сводка от нейросети'),
                      subtitle: Text(
                        'Нейросеть не заменяет врача, если вы чувствуйте, что с вами что-то не так, сразу обращайтесь к своему лечащему врачу!',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red),
                      ),
                      // decoration: BoxDecoration(
                      //     color: Colors.white,
                      //     borderRadius: BorderRadius.all(Radius.circular(20))),
                      children: [
                        Padding(
                            padding: EdgeInsets.all(15),
                            child: MarkdownBody(
                                data: jsonDecode(
                                    localDataBloc.state.summary!)['result']))
                      ],
                    )),
            SizedBox(
              height: 15,
            ),
            Container(
                height: 280,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: localDataBloc.lastActiveDoses.isEmpty
                    ? Center(
                        child: Text(
                          'На сегодня все)',
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: const Color.fromARGB(255, 114, 114, 114)),
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(children: <Widget>[
                          Text('Ближайшие события'),
                          Expanded(
                              child: ListView(
                            children: List.generate(
                                localDataBloc.lastActiveDoses.length,
                                (index) => Column(children: [
                                      Container(
                                          color: localDataBloc
                                                      .lastActiveDoses[index]
                                                      .doseState ==
                                                  DoseState.accepted
                                              ? Colors.green
                                              : localDataBloc
                                                          .lastActiveDoses[
                                                              index]
                                                          .doseState ==
                                                      DoseState.missed
                                                  ? Colors.red
                                                  : Colors.white,
                                          child: ListTile(
                                            title: Text(localDataBloc
                                                .lastActiveDoses[index].dose
                                                .getTime()),
                                            subtitle: Text(localDataBloc
                                                .lastActiveDoses[index]
                                                .medicine
                                                .name),
                                            trailing: Text(
                                                'Дозировка: ${localDataBloc.lastActiveDoses[index].dose.dosage} ${localDataBloc.lastActiveDoses[index].medicine.unit}'),
                                            onTap: () => showDoseActiveDialog(
                                                context, localDataBloc, index),
                                          )),
                                      index + 1 ==
                                              localDataBloc
                                                  .lastActiveDoses.length
                                          ? SizedBox.shrink()
                                          : Divider()
                                    ])),
                          )),
                        ]),
                      )),
            SizedBox(
              height: 15,
            ),
            GestureDetector(
              child: BlocProvider.of<LocalDataBloc>(context).pulses.isEmpty
                  ? SizedBox.shrink()
                  : Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Пульс',
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text('Последние данные'),
                              Text(
                                  style: TextStyle(fontSize: 18),
                                  '${BlocProvider.of<LocalDataBloc>(context).pulses.last.pulsecount} уд/мин')
                            ],
                          ),
                          Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Icon(Icons.arrow_right),
                              Container(
                                  width: 100,
                                  height: 80,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  child: SfCartesianChart(
                                      plotAreaBorderWidth: 0,
                                      annotations: <CartesianChartAnnotation>[],
                                      primaryYAxis: const NumericAxis(
                                        isVisible: false,
                                        rangePadding:
                                            ChartRangePadding.roundStart,
                                      ),
                                      primaryXAxis: DateTimeCategoryAxis(
                                        isVisible: false,
                                        //intervalType: DateTimeIntervalType.hours,
                                        rangePadding:
                                            ChartRangePadding.roundEnd,
                                      ),
                                      series: <CartesianSeries>[
                                        // Renders line chart
                                        LineSeries<Pulse, DateTime>(
                                            enableTooltip: true,
                                            dataSource:
                                                BlocProvider.of<LocalDataBloc>(
                                                        context)
                                                    .pulses,
                                            xValueMapper: (Pulse pulse, _) =>
                                                pulse.date,
                                            yValueMapper: (Pulse pulse, _) =>
                                                pulse.pulsecount)
                                      ]))
                            ],
                          )
                        ],
                      )),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute<Null>(
                    builder: (BuildContext context) => const MetricPage()));
              },
            ),
            SizedBox(
              height: 15,
            ),
            GestureDetector(
              child: BlocProvider.of<LocalDataBloc>(context).sugars.isEmpty
                  ? SizedBox.shrink()
                  : Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Уровень сахара',
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text('Последние данные'),
                              Text(
                                  style: TextStyle(fontSize: 18),
                                  '${BlocProvider.of<LocalDataBloc>(context).sugars.last.sugarcount} ммоль/л')
                            ],
                          ),
                          Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Icon(Icons.arrow_right),
                              Container(
                                  width: 100,
                                  height: 80,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  child: SfCartesianChart(
                                      plotAreaBorderWidth: 0,
                                      annotations: <CartesianChartAnnotation>[],
                                      primaryYAxis: const NumericAxis(
                                        isVisible: false,
                                        rangePadding:
                                            ChartRangePadding.roundStart,
                                      ),
                                      primaryXAxis: DateTimeCategoryAxis(
                                        isVisible: false,
                                        //intervalType: DateTimeIntervalType.hours,
                                        rangePadding:
                                            ChartRangePadding.roundEnd,
                                      ),
                                      series: <CartesianSeries>[
                                        // Renders line chart
                                        LineSeries<Sugar, DateTime>(
                                            enableTooltip: true,
                                            dataSource:
                                                BlocProvider.of<LocalDataBloc>(
                                                        context)
                                                    .sugars,
                                            xValueMapper: (Sugar pulse, _) =>
                                                pulse.date,
                                            yValueMapper: (Sugar pulse, _) =>
                                                pulse.sugarcount)
                                      ]))
                            ],
                          )
                        ],
                      )),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute<Null>(
                    builder: (BuildContext context) =>
                        const MetricSugarPage()));
              },
            ),
            SizedBox(
              height: 15,
            ),
            Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Вес',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text('Последние данные'),
                        Text(style: TextStyle(fontSize: 18), '60 кг')
                      ],
                    ),
                    Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Icon(Icons.arrow_right),
                        Container(
                            width: 100,
                            height: 80,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: SfCartesianChart(
                                plotAreaBorderWidth: 0,
                                annotations: <CartesianChartAnnotation>[],
                                primaryYAxis: const NumericAxis(
                                  isVisible: false,
                                  rangePadding: ChartRangePadding.roundStart,
                                ),
                                primaryXAxis: DateTimeCategoryAxis(
                                  isVisible: false,
                                  //intervalType: DateTimeIntervalType.hours,
                                  rangePadding: ChartRangePadding.roundEnd,
                                ),
                                series: <CartesianSeries>[
                                  // Renders line chart
                                  ColumnSeries<Pulse, DateTime>(
                                      enableTooltip: true,
                                      dataSource: chartData,
                                      xValueMapper: (Pulse pulse, _) =>
                                          pulse.date,
                                      yValueMapper: (Pulse pulse, _) =>
                                          pulse.pulsecount)
                                ]))
                      ],
                    )
                  ],
                )),
            SizedBox(
              height: 61,
            )
          ])
        ]))
  ]);
}

class MySliverAppBar extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final double kToolbarHeight = 75;
  MySliverAppBar({required this.expandedHeight});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Column(children: [
      Expanded(
          child: Stack(fit: StackFit.expand, children: [
        Container(
          decoration: const BoxDecoration(
            color: Colors.indigo,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20)),
          ),
          child: Image.asset(
            'assets/2.png',
            fit: BoxFit.fill,
          ),
        ),
        Align(
            alignment: Alignment.center,
            child: Padding(
                padding: EdgeInsets.all(15),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Flexible(
                    child: Opacity(
                        opacity: shrinkOffset < 100
                            ? 1
                            : shrinkOffset > 300
                                ? 0
                                : (expandedHeight - shrinkOffset) /
                                    expandedHeight,
                        child: InkWell(
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Image.asset(
                              'assets/11.png',
                              width: 100,
                              height: 100,
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                color: Colors.white),
                          ),
                          onTap: () {
                            //            Future.delayed(Duration(seconds: 1), () {
                            //   FlutterLocalNotificationsPlugin
                            //       flutterLocalNotificationsPlugin =
                            //       FlutterLocalNotificationsPlugin();
                            //   flutterLocalNotificationsPlugin
                            //       .resolvePlatformSpecificImplementation<
                            //           AndroidFlutterLocalNotificationsPlugin>()!
                            //       .requestNotificationsPermission();
                            // });

                            Navigator.of(context).push(MaterialPageRoute<Null>(
                                builder: (BuildContext context) =>
                                    const AddMedicinePage()));
                          },
                        )),
                  )
                ]))),
      ]))
    ]);
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
