import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:jiffy/jiffy.dart';
import 'package:med_hackton/data/model/pulse.dart';
import 'package:med_hackton/presentation/bloc/local_data/local_data_bloc.dart';
import 'package:intl/intl.dart';

import '../../data/model/emotions.dart';

Future<void> addEmotion(BuildContext context) {
  final _controller = TextEditingController();
  final _controller1 = TextEditingController();
  final controller1 = TextEditingController();
  List<String> symptoms = [];
  int rate = 0;
  return showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context1) {
        return StatefulBuilder(builder: (context, setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Отменить')),
                  Spacer(),
                  Text(
                    'Контроль симптомов',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  TextButton(
                      onPressed: () {
                        List<Emotions> emotions = List.from(
                            BlocProvider.of<LocalDataBloc>(context).emotions);
                        emotions.add(Emotions(
                            rate: rate,
                            symptoms: symptoms,
                            date: DateFormat("d MMMM yyyy", "ru_RU")
                                .parse(_controller.text.replaceFirst('г.', ''))
                                .add(Duration(
                                    hours: int.parse(
                                        _controller1.text.substring(0, 2)),
                                    minutes: int.parse(
                                        _controller1.text.substring(3, 5))))));
                        BlocProvider.of<LocalDataBloc>(context).emotions =
                            emotions;
                        Navigator.pop(context);
                      },
                      child: Text('Добавить')),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                  padding: EdgeInsets.all(15),
                  child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        Text('Выберите, как вы себя чувствуете'),
                        SizedBox(
                          height: 5,
                        ),
                        RatingBar.builder(
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            switch (index) {
                              case 0:
                                return Icon(
                                  Icons.sentiment_very_dissatisfied,
                                  color: Colors.red,
                                );
                              case 1:
                                return Icon(
                                  Icons.sentiment_dissatisfied,
                                  color: Colors.redAccent,
                                );
                              case 2:
                                return Icon(
                                  Icons.sentiment_neutral,
                                  color: Colors.amber,
                                );
                              case 3:
                                return Icon(
                                  Icons.sentiment_satisfied,
                                  color: Colors.lightGreen,
                                );
                              case 4:
                                return Icon(
                                  Icons.sentiment_very_satisfied,
                                  color: Colors.green,
                                );
                            }
                            return SizedBox.shrink();
                          },
                          onRatingUpdate: (rating) {
                            rate = rating.round();
                          },
                        ),
                        Divider(),
                        Text('Введите симптомы'),
                        symptoms.isEmpty
                            ? SizedBox.shrink()
                            : SizedBox(
                                height: 15,
                              ),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: List.generate(
                              symptoms.length,
                              (index) => Container(
                                  padding: EdgeInsets.only(
                                      left: 5, top: 5, bottom: 5),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(symptoms[index]),
                                      IconButton(
                                          onPressed: () {
                                            setState(
                                              () {
                                                symptoms.removeAt(index);
                                              },
                                            );
                                          },
                                          icon: Icon(Icons.close))
                                    ],
                                  ))),
                        ),
                        symptoms.isEmpty
                            ? SizedBox.shrink()
                            : SizedBox(
                                height: 15,
                              ),
                        TextFormField(
                          controller: controller1,
                          textAlign: TextAlign.right,
                          decoration: InputDecoration(
                              suffix: TextButton(
                                  onPressed: () {
                                    if (controller1.text.isNotEmpty) {
                                      setState(
                                        () {
                                          symptoms.add(controller1.text);
                                          controller1.text = '';
                                        },
                                      );
                                    }
                                  },
                                  child: Text('Добавить')),
                              prefixIcon: Padding(
                                  padding: EdgeInsets.all(15),
                                  child: Text('Симптом'))),
                        )
                      ]))),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: EdgeInsets.all(15),
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                            prefixIcon: Padding(
                                padding: EdgeInsets.all(15),
                                child: Text('Дата'))),
                        focusNode: AlwaysDisabledFocusNode(),
                        controller: _controller,
                        onTap: () {
                          selectDate(context, _controller);
                        },
                      ),
                      Divider(),
                      TextField(
                        textAlign: TextAlign.right,
                        focusNode: AlwaysDisabledFocusNode(),
                        decoration: InputDecoration(
                            prefixIcon: Padding(
                                padding: EdgeInsets.all(15),
                                child: Text('Время'))),
                        controller: _controller1,
                        onTap: () {
                          selectTime(context, _controller1);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 150,
              )
            ],
          );
        });
      });
}

void selectDate(BuildContext context, TextEditingController controller) async {
  DateTime? newSelectedDate = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime(2040),
  );

  if (newSelectedDate != null) {
    controller
      ..text = DateFormat.yMMMMd('ru_Ru').format(newSelectedDate)
      ..selection = TextSelection.fromPosition(TextPosition(
          offset: controller.text.length, affinity: TextAffinity.upstream));
  }
}

void selectTime(BuildContext context, TextEditingController controller) async {
  TimeOfDay? newSelectedDate = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
  );

  if (newSelectedDate != null) {
    controller
      ..text =
          '${newSelectedDate.hour.toString().length == 1 ? '0' : ''}${newSelectedDate.hour}:${newSelectedDate.minute.toString().length == 1 ? '0' : ''}${newSelectedDate.minute}'
      ..selection = TextSelection.fromPosition(TextPosition(
          offset: controller.text.length, affinity: TextAffinity.upstream));
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
