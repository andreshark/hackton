import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:med_hackton/data/model/medicine.dart';
import 'package:med_hackton/presentation/bloc/local_data/local_data_bloc.dart';
import 'package:med_hackton/presentation/pages/medicine_page.dart';
import 'package:intl/intl.dart';

class DoctorsPage extends StatelessWidget {
  const DoctorsPage({super.key});

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
            itemCount: localDataBloc.doctors.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Row(
                      children: [
                        Column(
                          children: [
                            Image.asset(
                              'assets/doctor01.png',
                              width: 60,
                              height: 60,
                            )
                          ],
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Column(
                          children: [
                            Text(localDataBloc.doctors[index].name),
                            Text(DateFormat.MMMMd('ru_Ru')
                                    .format(localDataBloc.doctors[index].date) +
                                ' ${localDataBloc.doctors[index].date.hour.toString().length == 1 ? '0' : ''}${localDataBloc.doctors[index].date.hour}:${localDataBloc.doctors[index].date.minute.toString().length == 1 ? '0' : ''}${localDataBloc.doctors[index].date.minute}')
                          ],
                        )
                      ],
                    ),
                  ));
            }));
  }
}
