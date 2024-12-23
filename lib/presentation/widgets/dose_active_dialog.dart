import 'package:flutter/material.dart';
import 'package:med_hackton/data/model/dose_active.dart';
import 'package:med_hackton/presentation/bloc/local_data/local_data_bloc.dart';

showDoseActiveDialog(
    BuildContext context, LocalDataBloc localDataBloc, int index) {
  showDialog<int>(
      context: context,
      builder: (BuildContext context1) {
        return StatefulBuilder(
            builder: (context, setState) => Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                child: Container(
                  child: Stack(
                    children: [
                      FittedBox(
                          child: Image.asset(
                        'assets/2.png',
                        width: 320,
                        height: 220,
                        fit: BoxFit.cover,
                      )),
                      Padding(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                localDataBloc
                                    .lastActiveDoses[index].medicine.name,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 20),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Text(
                                  'Нужно использовать в ${localDataBloc.lastActiveDoses[index].dose.hour < 10 ? '0${localDataBloc.lastActiveDoses[index].dose.hour}' : localDataBloc.lastActiveDoses[index].dose.hour}:${localDataBloc.lastActiveDoses[index].dose.minute < 10 ? '0${localDataBloc.lastActiveDoses[index].dose.minute}' : localDataBloc.lastActiveDoses[index].dose.minute}'),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                  'Дозировка: ${localDataBloc.lastActiveDoses[index].dose.dosage} ${localDataBloc.lastActiveDoses[index].medicine.unit}'),
                              SizedBox(
                                height: 30,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            localDataBloc.updateDoseState(
                                                localDataBloc
                                                    .lastActiveDoses[index],
                                                DoseState.missed);
                                            Navigator.pop(context);
                                          },
                                          icon: Icon(
                                            Icons.clear,
                                            color: Colors.red,
                                          )),
                                      Text('Пропустить')
                                    ],
                                  ),
                                  Column(children: [
                                    IconButton(
                                        onPressed: () {
                                          localDataBloc.updateDoseState(
                                              localDataBloc
                                                  .lastActiveDoses[index],
                                              DoseState.waiting);
                                          Navigator.pop(context);
                                        },
                                        icon: Icon(
                                          Icons.hourglass_empty_outlined,
                                          color: Theme.of(context).primaryColor,
                                        )),
                                    Text('Отложить')
                                  ]),
                                  Column(
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            localDataBloc.updateDoseState(
                                                localDataBloc
                                                    .lastActiveDoses[index],
                                                DoseState.accepted);
                                            Navigator.pop(context);
                                          },
                                          icon: Icon(
                                            Icons.done,
                                            color: Colors.green,
                                          )),
                                      Text('Принять')
                                    ],
                                  )
                                ],
                              )
                            ],
                          ))
                    ],
                  ),
                )));
      });
}
