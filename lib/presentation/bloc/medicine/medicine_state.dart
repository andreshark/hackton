import 'dart:io';
import 'dart:typed_data';
import 'package:equatable/equatable.dart';

import '../../../data/model/dose.dart';

class MedicineState extends Equatable {
  final String? name;
  final int? remains; // kolvo
  final String? comment;
  final bool? treatmentOn;
  final bool? remainsOn;
  final int? remainsNotificate;
  final DateTime? startTreatment;
  final DateTime? endTreatment;
  final bool checkDoses;
  final String? unit; // tip priema
  final List<Dose>? doses;
  final bool? finish;
  const MedicineState(
      {this.startTreatment,
      this.endTreatment,
      this.name,
      this.remains,
      this.comment,
      this.unit,
      this.doses,
      this.remainsNotificate,
      this.remainsOn = false,
      this.treatmentOn = false,
      this.checkDoses = false,
      this.finish});

  @override
  List<Object?> get props => [
        name,
        remains,
        comment,
        unit,
        doses,
        startTreatment,
        endTreatment,
        remainsOn,
        treatmentOn,
        remainsNotificate,
        checkDoses,
        finish
      ];

  MedicineState copyWith(
      {String? name,
      int? remains,
      DateTime? startTreatment,
      DateTime? endTreatment,
      String? comment,
      String? unit,
      int? remainsNotificate,
      List<Dose>? doses,
      bool? treatmentOn,
      bool? remainsOn,
      bool? checkDoses,
      bool? finish}) {
    return MedicineState(
      remains: remains ?? this.remains,
      remainsNotificate: remainsNotificate ?? this.remainsNotificate,
      name: name ?? this.name,
      checkDoses: checkDoses ?? this.checkDoses,
      comment: comment ?? this.comment,
      finish: finish ?? this.finish,
      unit: unit ?? this.unit,
      doses: doses ?? this.doses,
      startTreatment: startTreatment ?? this.startTreatment,
      endTreatment: endTreatment ?? this.endTreatment,
      treatmentOn: treatmentOn ?? this.treatmentOn,
      remainsOn: remainsOn ?? this.remainsOn,
    );
  }
}
