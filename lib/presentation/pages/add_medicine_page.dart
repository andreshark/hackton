import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:med_hackton/presentation/bloc/local_data/local_data_bloc.dart';
import 'package:med_hackton/presentation/bloc/medicine/medicine_bloc.dart';
import 'package:med_hackton/presentation/bloc/medicine/medicine_state.dart';
import 'package:numberpicker/numberpicker.dart';
import '../../commons/constants.dart';
import '../../data/model/dose.dart';
import 'package:intl/intl.dart';

class AddMedicinePage extends StatefulWidget {
  const AddMedicinePage({super.key});
  @override
  State<AddMedicinePage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AddMedicinePage> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) =>
            MedicineBloc(BlocProvider.of<LocalDataBloc>(context)),
        child: BlocBuilder<MedicineBloc, MedicineState>(
          builder: (context, state) {
            MedicineBloc medicineBloc = BlocProvider.of<MedicineBloc>(context);

            return Scaffold(
                appBar: AppBar(
                  title: Text('Добавление лекарства'),
                ),
                body: Form(
                    key: _formKey,
                    child: Padding(
                        padding: EdgeInsets.all(15),
                        child: ListView(children: [
                          Container(
                              color: Colors.white,
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Название лекарства:',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    TextFormField(
                                      decoration: InputDecoration(
                                          hintText:
                                              'Введите название лекарства'),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Название не может быть пустым';
                                        }
                                        return null;
                                      },
                                      onChanged: (value) {
                                        medicineBloc.name = value;
                                      },
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    const Text(
                                      'Комментарий:',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    TextFormField(
                                      maxLines: null,
                                      decoration: InputDecoration(
                                          hintText: 'Введите комментарий'),
                                      onChanged: (value) {
                                        medicineBloc.comment = value;
                                      },
                                    ),
                                    Row(
                                      children: [
                                        Text('Единицы измерения'),
                                        Spacer(),
                                        DropdownButton(
                                            value: medicineBloc.unit,
                                            items: units
                                                .map<DropdownMenuItem<String>>(
                                                    (String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                              );
                                            }).toList(),
                                            onChanged: (unit) {
                                              medicineBloc.unit = unit;
                                            })
                                      ],
                                    ),
                                  ],
                                ),
                              )),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                              color: Colors.white,
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  children: <Widget>[
                                        Row(
                                          children: [
                                            Text('График приема'),
                                            Spacer(),
                                            TextButton(
                                                onPressed: () {
                                                  medicineBloc.checkDoses =
                                                      false;
                                                  medicineBloc.addDose();
                                                },
                                                child: Row(
                                                  children: [
                                                    Text('Добавить прием'),
                                                    Icon(Icons.add)
                                                  ],
                                                ))
                                          ],
                                        ),
                                        state.doses == null
                                            ? state.checkDoses
                                                ? Text(
                                                    'Заполните график приема',
                                                    style: TextStyle(
                                                        color: Colors.red),
                                                  )
                                                : SizedBox.shrink()
                                            : SizedBox(
                                                height: 15,
                                              )
                                      ] +
                                      (state.doses == null
                                          ? [const SizedBox.shrink()]
                                          : List.generate(
                                              state.doses!.length,
                                              (int index) => Column(children: [
                                                    Row(
                                                      children: [
                                                        TextButton(
                                                            onPressed:
                                                                () async {
                                                              TimeOfDay? time =
                                                                  await showDialog<
                                                                          TimeOfDay>(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (BuildContext
                                                                              context) {
                                                                        return TimePickerDialog(
                                                                          initialTime:
                                                                              TimeOfDay.now(),
                                                                        );
                                                                      });
                                                              if (time !=
                                                                  null) {
                                                                List<Dose>?
                                                                    doses =
                                                                    List.from(state
                                                                        .doses!);
                                                                doses[index] = medicineBloc
                                                                    .doses![
                                                                        index]
                                                                    .copyWith(
                                                                        hour: time
                                                                            .hour,
                                                                        minute:
                                                                            time.minute);
                                                                medicineBloc
                                                                        .doses =
                                                                    doses;
                                                              }
                                                            },
                                                            child: Text(
                                                                '${state.doses![index].hour < 10 ? '0${state.doses![index].hour}' : state.doses![index].hour}:${state.doses![index].minute < 10 ? '0${state.doses![index].minute}' : state.doses![index].minute}')),
                                                        Spacer(),
                                                        TextButton(
                                                            onPressed:
                                                                () async {
                                                              showDialog<int>(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (BuildContext
                                                                          context1) {
                                                                    int value1 = state
                                                                        .doses![
                                                                            index]
                                                                        .dosage;
                                                                    return StatefulBuilder(
                                                                        builder: (context,
                                                                                setState) =>
                                                                            AlertDialog(
                                                                              alignment: Alignment.bottomCenter,
                                                                              title: Text('Дозировка'),
                                                                              content: NumberPicker(
                                                                                infiniteLoop: true,
                                                                                value: value1,
                                                                                minValue: 1,
                                                                                maxValue: 100,
                                                                                onChanged: (value) {
                                                                                  setState(() {
                                                                                    value1 = value;
                                                                                  });
                                                                                },
                                                                              ),
                                                                              actions: [
                                                                                OutlinedButton(
                                                                                    onPressed: () {
                                                                                      Navigator.of(context).pop();
                                                                                    },
                                                                                    child: Text('Отмена')),
                                                                                FilledButton(
                                                                                    onPressed: () {
                                                                                      List<Dose>? doses = List.from(medicineBloc.doses!);
                                                                                      doses[index] = medicineBloc.doses![index].copyWith(dosage: value1);
                                                                                      medicineBloc.doses = doses;
                                                                                      Navigator.of(context).pop();
                                                                                    },
                                                                                    child: Text('Сохранить'))
                                                                              ],
                                                                            ));
                                                                  });
                                                            },
                                                            child: Text(
                                                                '${state.doses![index].dosage} ${medicineBloc.unit}')),
                                                        IconButton(
                                                            onPressed: () {
                                                              medicineBloc
                                                                  .deleteDose(
                                                                      index);
                                                            },
                                                            icon: Icon(
                                                                Icons.delete))
                                                      ],
                                                    ),
                                                    state.doses!.last !=
                                                            state.doses![index]
                                                        ? Divider()
                                                        : SizedBox.shrink()
                                                  ]))),
                                ),
                              )),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            color: Colors.white,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SwitchListTile(
                                    title: const Text('Длительность курса'),
                                    value: state.treatmentOn!,
                                    onChanged: (f) {
                                      if (f) {
                                        medicineBloc.startTreatment =
                                            DateTime.now();
                                        medicineBloc.endTreatment =
                                            DateTime.now();
                                      } else {
                                        debugPrint(f.toString());
                                        medicineBloc.startTreatment = null;
                                        medicineBloc.endTreatment = null;
                                      }
                                      medicineBloc.treatmentOn = f;
                                    }),
                                !state.treatmentOn!
                                    ? SizedBox.shrink()
                                    : Padding(
                                        padding: EdgeInsets.all(15),
                                        child: GestureDetector(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              RichText(
                                                text: TextSpan(
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 18),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                      text: 'От: ',
                                                    ),
                                                    TextSpan(
                                                        text: DateFormat(
                                                                'y/M/d')
                                                            .format(medicineBloc
                                                                .startTreatment!),
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ],
                                                ),
                                              ),
                                              RichText(
                                                text: TextSpan(
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 18),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                      text: 'До: ',
                                                    ),
                                                    TextSpan(
                                                        text: DateFormat(
                                                                'y/M/d')
                                                            .format(medicineBloc
                                                                .endTreatment!),
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          onTap: () async {
                                            DateTimeRange? datetime =
                                                await showDateRangePicker(
                                              context: context,
                                              firstDate: DateTime.now(),
                                              lastDate: DateTime(2030),
                                            );
                                            if (datetime != null) {
                                              medicineBloc.startTreatment =
                                                  datetime.start;
                                              medicineBloc.endTreatment =
                                                  datetime.end;
                                            }
                                          },
                                        ))
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            color: Colors.white,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SwitchListTile(
                                    title:
                                        const Text('Контроль запаса лекарств'),
                                    value: state.remainsOn!,
                                    onChanged: (f) {
                                      if (f) {
                                        medicineBloc.remains = 10;
                                        medicineBloc.remainsNotificate = 5;
                                      } else {
                                        medicineBloc.remains = null;
                                        medicineBloc.remainsNotificate = null;
                                      }
                                      medicineBloc.remainsOn = f;
                                    }),

                                !state.remainsOn!
                                    ? SizedBox.shrink()
                                    : Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 10,
                                            ),
                                            const Text(
                                              'Количество лекарств:',
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            ),
                                            TextFormField(
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: InputDecoration(
                                                  hintText:
                                                      'Введите сколько у вас лекарств'),
                                              onChanged: (value) {
                                                medicineBloc.remains =
                                                    int.parse(value);
                                              },
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            const Text(
                                              'Уведомлять с:',
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            ),
                                            TextFormField(
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: InputDecoration(
                                                  hintText:
                                                      'Введите количество лекарств'),
                                              onChanged: (value) {
                                                medicineBloc.remainsNotificate =
                                                    int.parse(value);
                                              },
                                            ),
                                          ],
                                        ))

                                // OutlinedButton(onPressed: () {}, child: Text(DateFormat('y/M/d').format(medicineBloc.startTreatment!) )),
                                // DatePickerDialog(
                                //   //initialEntryMode: DatePickerEntryMode.inputOnly,
                                //   firstDate: DateTime.now(),
                                //   lastDate: DateTime(2030),
                                //   initialDate: DateTime.now(),
                                // ),
                                // DatePickerDialog(
                                //   firstDate: DateTime.now(),
                                //   lastDate: DateTime(2030),
                                //   initialDate: DateTime.now(),
                                // )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          FilledButton(
                              onPressed: () {
                                final FormState? form = _formKey.currentState;
                                if (form!.validate() &&
                                    medicineBloc.doses != null &&
                                    medicineBloc.doses!.isNotEmpty) {
                                  medicineBloc.saveMedicine();
                                } else {
                                  medicineBloc.checkDoses = true;
                                }
                              },
                              child: Text('Готово'))
                        ]))));
          },
        ));
  }
}
