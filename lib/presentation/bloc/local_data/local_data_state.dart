import 'package:equatable/equatable.dart';
import 'package:med_hackton/data/model/doctor.dart';
import 'package:med_hackton/data/model/emotions.dart';
import 'package:med_hackton/data/model/medicine.dart';
import 'package:med_hackton/data/model/pulse.dart';
import 'package:med_hackton/data/model/sugar.dart';

import '../../../data/model/dose_active.dart';

class LocalDataState extends Equatable {
  final List<Medicine>? medicines;
  final List<Pulse>? pulses;
  final List<Doctor>? doctors;
  final List<Sugar>? sugars;
  final List<Emotions>? emotions;
  final List<ActiveDose>? allActiveDoses;
  final String? summary;
  const LocalDataState(
      {this.medicines,
      this.pulses,
      this.sugars,
      this.allActiveDoses,
      this.doctors,
      this.summary,
      this.emotions});

  @override
  List<Object?> get props =>
      [medicines, pulses, sugars, allActiveDoses, emotions, summary];

  LocalDataState copyWith(
      {List<Medicine>? medicines,
      List<Pulse>? pulses,
      List<Sugar>? sugars,
      List<Emotions>? emotions,
      List<Doctor>? doctors,
      String? summary,
      List<ActiveDose>? allActiveDoses}) {
    return LocalDataState(
      medicines: medicines ?? this.medicines,
      pulses: pulses ?? this.pulses,
      sugars: sugars ?? this.sugars,
      doctors: doctors ?? this.doctors,
      summary: summary ?? this.summary,
      emotions: emotions ?? this.emotions,
      allActiveDoses: allActiveDoses ?? this.allActiveDoses,
    );
  }
}
