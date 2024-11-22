import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:med_hackton/data/model/medicine.dart';
import 'package:med_hackton/presentation/bloc/local_data/local_data_bloc.dart';
import 'package:med_hackton/presentation/pages/medicine_page.dart';

class MedicinesPage extends StatelessWidget {
  const MedicinesPage({super.key});

  String times(Medicine medecine) {
    if (medecine.doses.length == 1) {
      return '${medecine.doses[0].getTime()}';
    } else {
      String doses = '';
      for (int i = 0; i < medecine.doses.length; i++) {
        if (i != medecine.doses.length - 1) {
          if (i != 0) {
            doses += ', ${medecine.doses[i].getTime()}';
          } else {
            doses += '${medecine.doses[0].getTime()}';
          }
        } else {
          doses += ' и ${medecine.doses[i].getTime()}';
        }
      }
      return doses;
    }
  }

  @override
  Widget build(BuildContext context) {
    LocalDataBloc localDataBloc = BlocProvider.of<LocalDataBloc>(context);
    return Padding(
        padding: EdgeInsets.all(15),
        child: ListView.builder(
            itemCount: localDataBloc.medicines.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                color: Colors.white,
                child: ListTile(
                  title: Row(children: [
                    Icon(Icons.medication_liquid),
                    SizedBox(
                      width: 15,
                    ),
                    Text(localDataBloc.medicines[index].name)
                  ]),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          '${localDataBloc.medicines[index].doses.length} ${localDataBloc.medicines[index].doses.length == 1 ? 'раз' : 'раза'} в день - ${times(localDataBloc.medicines[index])}'),
                      localDataBloc.medicines[index].remains == null
                          ? SizedBox.shrink()
                          : SizedBox(
                              height: 15,
                            ),
                      localDataBloc.medicines[index].remains == null
                          ? SizedBox.shrink()
                          : Container(
                              decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 240, 237, 237),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: EdgeInsets.all(3),
                                child: Text(
                                    'Осталось ${localDataBloc.medicines[index].remains} ${localDataBloc.medicines[index].unit}'),
                              ))
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute<Null>(
                        builder: (BuildContext context) => MedicinePage(
                              index: index,
                            )));
                  },
                ),
              );
            }));
  }
}
