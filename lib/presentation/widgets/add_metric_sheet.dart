import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:textfield_datepicker/textfield_dateAndTimePicker.dart';
import 'package:intl/intl.dart';
import 'package:textfield_datepicker/textfield_datepicker.dart';
import 'package:textfield_datepicker/textfield_timePicker.dart';

Future<void> addMetric(BuildContext context) {
  final _controller = TextEditingController();
  final _controller1 = TextEditingController();
  return showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context1) {
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
                  'Пульс',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Spacer(),
                TextButton(
                    onPressed: () => Navigator.pop(context),
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextfieldDatePicker(
                      decoration: InputDecoration(
                          prefixIcon: Padding(
                              padding: EdgeInsets.all(15),
                              child: Text('Дата'))),
                      textAlign: TextAlign.right,
                      textfieldDatePickerController: _controller,
                      preferredDateFormat: DateFormat.yMMMMd('ru_Ru'),
                      cupertinoDatePickerBackgroundColor: Colors.white,
                      cupertinoDatePickerMaximumDate: DateTime(2099),
                      cupertinoDatePickerMaximumYear: 2099,
                      cupertinoDatePickerMinimumYear: 1990,
                      cupertinoDatePickerMinimumDate: DateTime(1990),
                      cupertinoDateInitialDateTime: DateTime.now(),
                      materialDatePickerFirstDate: DateTime.now(),
                      // materialInitialTime: TimeOfDay.now(),
                      materialDatePickerInitialDate: DateTime.now(),
                      materialDatePickerLastDate: DateTime(2099),
                    ),
                    Divider(),
                    TextfieldTimePicker(
                      decoration: InputDecoration(
                          prefixIcon: Padding(
                              padding: EdgeInsets.all(15),
                              child: Text('Время'))),
                      materialTimePickerUse24hrFormat: true,
                      textAlign: TextAlign.right,
                      textfieldDateAndTimePickerController: _controller1,
                      cupertinoDatePickerBackgroundColor: Colors.white,
                      cupertinoDateInitialDateTime: DateTime.now(),
                      materialInitialTime: TimeOfDay.now(),
                    ),
                    Divider(),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                          prefixIcon: Padding(
                              padding: EdgeInsets.all(15),
                              child: Text('УД/МИН'))),
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
}

class _DateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue prevText, TextEditingValue currText) {
    int selectionIndex;

    String date;
    String month;
    int year;

// Get the previous and current input strings
    String pText = prevText.text;
    String cText = currText.text;

    cText = cText.replaceAll("//", "/");

// Abbreviate lengths
    int cLen = cText.length;
    int pLen = pText.length;

    /// ENTERING THE DATE
    if (cLen == 1) {
      ///  User enters the first digit of the  date. The first digit
      // Can only be 0, 1, 2 or 3
      if (int.parse(cText) > 3) {
        // Remove char
        cText = '';
      }
    } else if (cLen == 2 && pLen == 1) {
      /// User has already entered a valid first digit of the date, now he
      /// enters the second digit of the date; but
      // Days cannot be greater than 31
      int dd = int.parse(cText.substring(0, 2));
      if (dd == 0 || dd > 31) {
        // Remove char
        cText = cText.substring(0, 1);
      } else {
        /// User has entered a valid date (between 1 and 31). So now,
        // Add a / char
        cText += '/';
      }

      /// ENTERING THE MONTH
    } else if (cLen == 4) {
      /// after entering a valid date and programmatic insertion of '/', now User has entered
      /// the first digit of the Month. But, it
      // Can only be 0 or 1
      /// (and, not  '/' either)
      if (int.parse(cText.substring(3, 4)) > 1 ||
          cText.substring(3, 4) == "/") {
        // Remove char
        cText = cText.substring(0, 3);
      }
    } else if (cLen == 5 && pLen == 4) {
      int mm = int.parse(cText.substring(3, 5));
      int dd = int.parse(cText.substring(0, 2));

      /// User has entered the second digit of the Month, but the
      // Month cannot be greater than 12
      /// Also, that entry cannot be '/'
      if ((mm == 0 || mm > 12 || cText.substring(3, 5) == "/") ||

          /// If the date is 31, the month cannot be Apr, Jun, Sept or Nov
          (dd == 31 &&
              (mm == 02 || mm == 04 || mm == 06 || mm == 09 || mm == 11)) ||

          /// If the date is greater than 29, the month cannot be Feb
          /// (Leap years will be dealt with, when user enters the Year)
          (dd > 29 && (mm == 02))) {
        // Remove char
        cText = cText.substring(0, 4);
      } else if (cText.length == 5) {
        /// the Month entered is valid; so,
        // Add a / char
        cText += '/';
      }
    } else if ((cLen == 3 && pLen == 4) || (cLen == 6 && pLen == 7)) {
      // Remove / char
      cText = cText.substring(0, cText.length - 1);
    } else if (cLen == 3 && pLen == 2) {
      if (int.parse(cText.substring(2, 3)) > 1) {
        // Replace char
        cText = cText.substring(0, 2) + '/';
      } else {
        // Insert / char
        cText =
            cText.substring(0, pLen) + '/' + cText.substring(pLen, pLen + 1);
      }

      /// ENTERING THE YEAR
    } else if (cLen == 6 && pLen == 5) {
      // Can only be 1 or 2 - if so insert a / char
      int y1 = int.parse(cText.substring(5, 6));
      if (y1 < 1 || y1 > 2) {
        // Replace char
        /// i.e, add '/' after the 5th position
        cText = cText.substring(0, 5) + '/';
      } else {
        // Insert / char
        cText = cText.substring(0, 5) + '/' + cText.substring(5, 6);
      }
    } else if (cLen == 7) {
      /// the first digit of year
      // Can only be 1 or 2
      int y1 = int.parse(cText.substring(6, 7));
      if (y1 < 1 || y1 > 2) {
        // Remove char
        cText = cText.substring(0, 6);
      }
    } else if (cLen == 8) {
      // Can only be 19 or 20
      /// Also, there cannot be / typed by the user
      String y2 = cText.substring(6, 8);
      if (y2 != "19" && y2 != "20") {
        // Remove char
        cText = cText.substring(0, 7);
      }
    } else if (cLen == 9) {
      /// There cannot be / typed by the user
      if (cText.substring(8, 9) == "/") {
        // Remove char
        cText = cText.substring(0, 8);
      }
    } else if (cLen == 10) {
      /// There cannot be / typed by the user
      if (cText.substring(9, 10) == "/") {
        // Remove char
        cText = cText.substring(0, 9);
      }

      /// If the year entered is not a leap year but the date entered is February 29,
      /// it will be advanced to the next valid date
      date = cText.substring(0, 2);
      month = cText.substring(3, 5);
      year = int.parse(cText.substring(6, 10));
      bool isNotLeapYear =
          !((year % 4 == 0) && (year % 100 != 0) || (year % 400 == 0));
      if (isNotLeapYear && month == "02" && date == "29") {
        cText = "01/03/$year";
      }
    }

    selectionIndex = cText.length;
    return TextEditingValue(
      text: cText,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
