import 'dart:math';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:med_hackton/data/model/pulse.dart';
import 'package:med_hackton/data/model/sugar.dart';
import 'package:med_hackton/presentation/bloc/local_data/local_data_bloc.dart';
import 'package:med_hackton/presentation/bloc/local_data/local_data_state.dart';
import 'package:med_hackton/presentation/widgets/add_metric_sheet_sugar.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

import '../widgets/add_metric_sheet.dart';

class MetricSugarPage extends StatefulWidget {
  const MetricSugarPage({super.key});
  @override
  State<MetricSugarPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<MetricSugarPage> {
  final _formKey = GlobalKey<FormState>();
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(
        enable: true,
        builder: (dynamic data, dynamic point, dynamic series, int pointIndex,
            int seriesIndex) {
          //debugPrint(data);
          return Container(
              child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    '${DateFormat('M/d H:m').format((data as Sugar).date)}\nСахар: ${(data as Sugar).sugarcount.toString()}',
                    style: TextStyle(color: Colors.white),
                  )));
        });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<Pulse> chartData = [
      Pulse(date: DateTime(2024, 11, 17, 17, 40, 20), pulsecount: 105),
      Pulse(date: DateTime(2024, 11, 18, 16, 40, 20), pulsecount: 90),
      Pulse(date: DateTime(2024, 11, 19, 16, 50, 20), pulsecount: 60),
      Pulse(date: DateTime(2024, 11, 20, 18, 40, 20), pulsecount: 76),
      Pulse(date: DateTime(2024, 11, 20, 19, 40, 20), pulsecount: 90),
      Pulse(date: DateTime(2024, 11, 20, 20, 40, 20), pulsecount: 80),
    ];
    Intl.defaultLocale = 'ru_RU';
    return BlocBuilder<LocalDataBloc, LocalDataState>(
        builder: (context, state) {
      final List<Sugar> sortedPulse = List.from(state.sugars!)
        ..sort((a, b) {
          if (a.date.compareTo(b.date) == 1) {
            return -1;
          } else if (a.date.compareTo(b.date) == -1) {
            return 1;
          }
          return 0;
        });
      final minPulse = state.sugars!.isEmpty
          ? null
          : minBy(state.sugars!.where((x) => x.date.day == DateTime.now().day),
                  (e) => e.sugarcount)!
              .sugarcount;
      final maxPulse = state.sugars!.isEmpty
          ? null
          : maxBy(state.sugars!.where((x) => x.date.day == DateTime.now().day),
                  (e) => e.sugarcount)!
              .sugarcount;

      return Scaffold(
          appBar: AppBar(
            title: Text('Уровень сахара в крови'),
            actions: [
              Padding(
                  padding: EdgeInsets.all(10),
                  child: TextButton.icon(
                    onPressed: () {
                      addMetricSugar(null, context);
                    },
                    label: Text('Добавить'),
                    icon: Icon(Icons.add),
                  ))
            ],
          ),
          body: Stack(children: [
            ListView(
              children: [
                    SizedBox(
                      height: 15,
                    ),
                    state.sugars!.isEmpty
                        ? SizedBox.shrink()
                        : Container(
                            color: Colors.white,
                            child: SfCartesianChart(
                                tooltipBehavior: _tooltipBehavior,
                                annotations: <CartesianChartAnnotation>[
                                  CartesianChartAnnotation(
                                      widget: Container(
                                          color: const Color.fromARGB(
                                              255, 61, 60, 60),
                                          child: Padding(
                                              padding: EdgeInsets.all(10),
                                              child: Text(
                                                'Диапазон\n $minPulse-$maxPulse ммоль/л\n${DateFormat.MMMd().format(DateTime.now())}',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ))),
                                      region: AnnotationRegion.plotArea,
                                      coordinateUnit:
                                          CoordinateUnit.logicalPixel,
                                      x: 300,
                                      y: 30)
                                ],
                                primaryYAxis: const NumericAxis(
                                  rangePadding: ChartRangePadding.roundStart,
                                ),
                                primaryXAxis: DateTimeCategoryAxis(
                                  //intervalType: DateTimeIntervalType.hours,
                                  rangePadding: ChartRangePadding.roundEnd,

                                  dateFormat: DateFormat('M/d H:m'),
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
                                ])),
                    SizedBox(
                      height: 5,
                    ),
                  ] +
                  List.generate(
                    state.sugars!.length,
                    (index) => Container(
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: ListTile(
                          title: Text(
                              'Уровень сахара в крови: ${sortedPulse[index].sugarcount} ммоль/л'),
                          subtitle: Text(
                            '${DateFormat('y MMM d г. ${sortedPulse[index].date.hour.toString().length == 1 ? '0' : ''}H:${sortedPulse[index].date.minute.toString().length == 1 ? '0' : ''}m').format(sortedPulse[index].date)} ',
                          ),
                          trailing: Icon(Icons.edit_note),
                          onTap: () =>
                              addMetricSugar(sortedPulse[index], context),
                        )),
                  ),
            ),
            Padding(
                padding: EdgeInsets.all(20),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: FilledButton.tonal(
                      onPressed: () {}, child: Text('Отслеживать')),
                ))
          ]));
    });
  }
}
