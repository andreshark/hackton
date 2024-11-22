import 'package:equatable/equatable.dart';
import 'package:med_hackton/data/model/dose.dart';
import 'package:med_hackton/data/model/medicine.dart';

class ActiveDose extends Equatable {
  final Dose dose;
  final Medicine medicine;
  final DoseState doseState;

  const ActiveDose(
      {required this.dose, required this.doseState, required this.medicine});

  ActiveDose copyWith({Dose? dose, DoseState? doseState}) {
    return ActiveDose(
        dose: dose ?? this.dose,
        medicine: medicine,
        doseState: doseState ?? this.doseState);
  }

  @override
  // TODO: implement props
  List<Object?> get props => [dose, doseState];
}

enum DoseState { accepted, missed, waiting }
