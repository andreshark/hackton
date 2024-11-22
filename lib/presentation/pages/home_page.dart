import 'package:flutter/material.dart';
import 'package:med_hackton/presentation/bloc/local_data/local_data_bloc.dart';
import 'package:med_hackton/presentation/pages/metric_page.dart';

import '../widgets/dose_active_dialog.dart';
import 'add_medicine_page.dart';

Widget HomePage(BuildContext context, LocalDataBloc localDataBloc) {
  return Padding(
      padding: EdgeInsets.all(15),
      child: Column(
        children: [
          FilledButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute<Null>(
                    builder: (BuildContext context) => const MetricPage()));
              },
              child: Text('Добавить лекарство')),
          SizedBox(
            height: 15,
          ),
          Container(
              height: 280,
              color: Colors.white,
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
                                    ListTile(
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
                                    ),
                                    index + 1 ==
                                            localDataBloc.lastActiveDoses.length
                                        ? SizedBox.shrink()
                                        : Divider()
                                  ])),
                        ))
                      ]),
                    ))
        ],
      ));
}
