import 'package:flutter/material.dart';
import 'package:med_hackton/data/model/pulse.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

import '../widgets/add_metric_sheet.dart';

class MetricPage extends StatefulWidget {
  const MetricPage({super.key});
  @override
  State<MetricPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<MetricPage> {
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
                    '${DateFormat('M/d H:m').format((data as Pulse).date)}\nПульс: ${(data as Pulse).pulsecount.toString()}',
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Пульс'),
        actions: [
          Padding(
              padding: EdgeInsets.all(10),
              child: TextButton.icon(
                onPressed: () {
                  addMetric(context);
                },
                label: Text('Добавить'),
                icon: Icon(Icons.add),
              ))
        ],
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 15,
          ),
          Container(
              color: Colors.white,
              child: SfCartesianChart(
                  tooltipBehavior: _tooltipBehavior,
                  annotations: <CartesianChartAnnotation>[
                    CartesianChartAnnotation(
                        widget: Container(
                            color: const Color.fromARGB(255, 61, 60, 60),
                            child: Padding(
                                padding: EdgeInsets.all(10),
                                child: const Text(
                                  'Диапазон\n 60-105 уд/мин\n21 декабрая',
                                  style: TextStyle(color: Colors.white),
                                ))),
                        region: AnnotationRegion.plotArea,
                        coordinateUnit: CoordinateUnit.logicalPixel,
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
                    LineSeries<Pulse, DateTime>(
                        enableTooltip: true,
                        dataSource: chartData,
                        xValueMapper: (Pulse pulse, _) => pulse.date,
                        yValueMapper: (Pulse pulse, _) => pulse.pulsecount)
                  ]))
        ],
      ),
    );
  }
}
