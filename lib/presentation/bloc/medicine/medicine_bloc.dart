import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:med_hackton/data/model/medicine.dart';
import 'package:med_hackton/presentation/bloc/local_data/local_data_bloc.dart';
import 'package:med_hackton/presentation/bloc/medicine/medicine_state.dart';
import 'package:http/http.dart' as http;
import '../../../data/model/dose.dart';

class MedicineBloc extends Cubit<MedicineState> {
  final LocalDataBloc localDataBloc;
  final Medicine? medicine;

  MedicineBloc(this.localDataBloc, this.medicine)
      : super(MedicineState(
            startTreatment: medicine != null ? medicine.startTreatment : null,
            endTreatment: medicine != null ? medicine.endTreatment : null,
            name: medicine != null ? medicine.name : null,
            remains: medicine != null ? medicine.remains : null,
            comment: medicine != null ? medicine.comment : null,
            unit: medicine != null ? medicine.unit : 'таблетка(и)',
            doses: medicine != null ? medicine.doses : null,
            remainsNotificate:
                medicine != null ? medicine.remainsNotificate : null,
            remainsOn:
                medicine != null && medicine.remains != null ? true : false,
            treatmentOn: medicine != null && medicine.startTreatment != null
                ? true
                : false,
            checkDoses: medicine != null ? true : false,
            finish: false));

  bool? get checkDoses => state.checkDoses;
  set checkDoses(bool? checkDoses) {
    emit(state.copyWith(checkDoses: checkDoses));
  }

  String? get name => state.name;
  set name(String? name) {
    emit(state.copyWith(name: name));
  }

  void addDose() {
    late List<Dose> doses1;
    if (doses == null || doses!.isEmpty) {
      doses1 = [const Dose(hour: 8, minute: 0, dosage: 1)];
    } else {
      doses1 = List.from(doses!);
      if (doses!.last.hour < 22) {
        doses1.add(Dose(
            hour: doses!.last.hour + 2, minute: 0, dosage: doses!.last.dosage));
      }
    }
    emit(state.copyWith(doses: doses1));
  }

  Future<http.Response> getMedicineData(String name) {
    return http.post(
      Uri.parse('http://192.168.1.103:5000/parse-drug'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': name,
      }),
    );
  }

  Future<bool> saveMedicine(Medicine? medicine1) async {
    emit(state.copyWith(finish: true));
    Response response = await getMedicineData(name!);
    Map<String, dynamic>? body;
    if (response.statusCode == 200 && response.body != 'null') {
      body = json.decode(response.body);
    }
    Medicine medicine = Medicine(
      name: name!,
      remains: remains,
      unit: unit!,
      comment: comment,
      doses: doses!,
      remainsNotificate: remainsNotificate,
      startTreatment: startTreatment,
      endTreatment: endTreatment,
      contraindications: body != null ? body['protivopokazaniia'] : null,
      indications: body != null ? body['pokazaniia'] : null,
      sideEffects: body != null ? body['pobocnye-deistviia'] : null,
      directionsForUse: body != null ? body['vzaimodeistvie-deistviia'] : null,
    );

    localDataBloc.addMedicine(medicine, medicine1);
    return true;
  }

  void deleteDose(int index) {
    late List<Dose> doses1;
    doses1 = List.from(doses!);
    doses1.removeAt(index);

    emit(state.copyWith(doses: doses1));
  }

  bool? get treatmentOn => state.treatmentOn;
  set treatmentOn(bool? treatmentOn) {
    emit(state.copyWith(treatmentOn: treatmentOn));
  }

  bool? get remainsOn => state.remainsOn;
  set remainsOn(bool? remainsOn) {
    emit(state.copyWith(remainsOn: remainsOn));
  }

  DateTime? get startTreatment => state.startTreatment;
  set startTreatment(DateTime? startTreatment) {
    emit(state.copyWith(startTreatment: startTreatment));
  }

  DateTime? get endTreatment => state.endTreatment;
  set endTreatment(DateTime? endTreatment) {
    emit(state.copyWith(endTreatment: endTreatment));
  }

  int? get remainsNotificate => state.remainsNotificate;
  set remainsNotificate(int? remainsNotificate) {
    emit(state.copyWith(remainsNotificate: remainsNotificate));
  }

  int? get remains => state.remains;
  set remains(int? remains) {
    emit(state.copyWith(remains: remains));
  }

  String? get comment => state.comment;
  set comment(String? comment) {
    emit(state.copyWith(comment: comment));
  }

  String? get unit => state.unit;
  set unit(String? unit) {
    emit(state.copyWith(unit: unit));
  }

  List<Dose>? get doses => state.doses;
  set doses(List<Dose>? doses) {
    if (doses != null) {
      doses.sort(
        (a, b) {
          if (a.hour.compareTo(b.hour) == 0) {
            return a.minute.compareTo(b.minute);
          }
          return a.hour.compareTo(b.hour);
        },
      );
    }
    emit(state.copyWith(doses: doses));
  }
}
