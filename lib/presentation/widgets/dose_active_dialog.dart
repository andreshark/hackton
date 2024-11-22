import 'package:flutter/material.dart';
import 'package:med_hackton/presentation/bloc/local_data/local_data_bloc.dart';

showDoseActiveDialog(
    BuildContext context, LocalDataBloc localDataBloc, int index) {
  showDialog<int>(
      context: context,
      builder: (BuildContext context1) {
        return StatefulBuilder(
            builder: (context, setState) => AlertDialog(
                  title:
                      Text(localDataBloc.lastActiveDoses[index].medicine.name),
                  content: Column(mainAxisSize: MainAxisSize.min, children: [
                    Text(
                        'Нужно использовать в ${localDataBloc.lastActiveDoses[index].dose.hour < 10 ? '0${localDataBloc.lastActiveDoses[index].dose.hour}' : localDataBloc.lastActiveDoses[index].dose.hour}:${localDataBloc.lastActiveDoses[index].dose.minute < 10 ? '0${localDataBloc.lastActiveDoses[index].dose.minute}' : localDataBloc.lastActiveDoses[index].dose.minute}'),
                    Text(
                        'Дозировка: ${localDataBloc.lastActiveDoses[index].dose.dosage} ${localDataBloc.lastActiveDoses[index].medicine.unit}'),
                  ]),
                  actionsAlignment: MainAxisAlignment.spaceBetween,
                  actions: [
                    Column(
                      children: [
                        IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.cancel,
                              color: Colors.red,
                            )),
                        Text('Пропустить')
                      ],
                    ),
                    Column(children: [
                      IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.hourglass_top,
                            color: Theme.of(context).primaryColor,
                          )),
                      Text('Отложить')
                    ]),
                    Column(
                      children: [
                        IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.done,
                              color: Colors.green,
                            )),
                        Text('Принять')
                      ],
                    )
                  ],
                ));
      });
}
