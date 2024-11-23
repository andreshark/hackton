import 'package:flutter/material.dart';
import 'package:med_hackton/data/model/dose_active.dart';
import 'package:med_hackton/presentation/bloc/local_data/local_data_bloc.dart';

showDoseActiveDialog1(
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
                                    .allActiveDoses[index].medicine.name,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 20),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Text(
                                  'Нужно использовать в ${localDataBloc.allActiveDoses[index].dose.hour < 10 ? '0${localDataBloc.allActiveDoses[index].dose.hour}' : localDataBloc.allActiveDoses[index].dose.hour}:${localDataBloc.allActiveDoses[index].dose.minute < 10 ? '0${localDataBloc.allActiveDoses[index].dose.minute}' : localDataBloc.allActiveDoses[index].dose.minute}'),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                  'Дозировка: ${localDataBloc.allActiveDoses[index].dose.dosage} ${localDataBloc.allActiveDoses[index].medicine.unit}'),
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
                                                    .allActiveDoses[index],
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
                                                  .allActiveDoses[index],
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
                                                    .allActiveDoses[index],
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
