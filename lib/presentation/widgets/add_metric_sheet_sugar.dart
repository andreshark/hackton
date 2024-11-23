import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:med_hackton/data/model/pulse.dart';
import 'package:med_hackton/data/model/sugar.dart';
import 'package:med_hackton/presentation/bloc/local_data/local_data_bloc.dart';
import 'package:intl/intl.dart';

Future<void> addMetricSugar(Sugar? sugar, BuildContext context) {
  final _controller = TextEditingController();
  final _controller1 = TextEditingController();
  final controller1 = TextEditingController();
  if (sugar != null) {
    _controller.text = DateFormat('d MMMM yyyy').format(sugar.date);
    _controller1.text =
        '${sugar.date.hour.toString().length == 1 ? '0${sugar.date.hour}' : sugar.date.hour}:${sugar.date.minute.toString().length == 1 ? '0${sugar.date.minute}' : sugar.date.minute}';
    controller1.text = '${sugar.sugarcount}';
  }
  return showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context1) {
        return StatefulBuilder(builder: (context, setState) {
          // final controller2 = TextEditingController();
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
                    'Уровень сахара в крови',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  TextButton(
                      onPressed: () {
                        if (sugar == null) {
                          BlocProvider.of<LocalDataBloc>(context).addSugar(
                              Sugar(
                                  sugarcount: int.parse(controller1.text),
                                  date: DateFormat("d MMMM yyyy", "ru_RU")
                                      .parse(_controller.text
                                          .replaceFirst('г.', ''))
                                      .add(Duration(
                                          hours: int.parse(_controller1.text
                                              .substring(0, 2)),
                                          minutes: int.parse(_controller1.text
                                              .substring(3, 5))))));
                        } else {
                          final List<Sugar> list = List.from(
                              BlocProvider.of<LocalDataBloc>(context).sugars);
                          list[list.indexOf(sugar)] = Sugar(
                              sugarcount: int.parse(controller1.text),
                              date: DateFormat("d MMMM yyyy", "ru_RU")
                                  .parse(
                                      _controller.text.replaceFirst('г.', ''))
                                  .add(Duration(
                                      hours: int.parse(
                                          _controller1.text.substring(0, 2)),
                                      minutes: int.parse(
                                          _controller1.text.substring(3, 5)))));
                          BlocProvider.of<LocalDataBloc>(context).sugars = list;
                        }
                        Navigator.pop(context);
                      },
                      child:
                          sugar == null ? Text('Добавить') : Text('Сохранить')),
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
                      Divider(),
                      TextFormField(
                        controller: controller1,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                            prefixIcon: Padding(
                                padding: EdgeInsets.all(15),
                                child: Text('ммоль/л'))),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 450,
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
