import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:med_hackton/data/model/medicine.dart';
import 'package:med_hackton/presentation/bloc/local_data/local_data_bloc.dart';
import 'package:med_hackton/presentation/bloc/medicine/medicine_state.dart';

import '../../../data/model/dose.dart';

class MedicineBloc extends Cubit<MedicineState> {
  final LocalDataBloc localDataBloc;

  MedicineBloc(this.localDataBloc) : super(MedicineState(unit: 'таблетка(и)'));

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

  void saveMedicine() {
    Medicine medicine = Medicine(
        name: name!,
        remains: remains,
        unit: unit!,
        comment: comment,
        doses: doses!,
        remainsNotificate: remainsNotificate,
        startTreatment: startTreatment,
        endTreatment: endTreatment);
    localDataBloc.addMedicine(medicine);
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
