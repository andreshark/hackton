import 'package:equatable/equatable.dart';
import 'package:med_hackton/data/model/dose.dart';

class Medicine extends Equatable {
  final String name;
  final int? remains; // kolvo
  final String? contraindications; // противопоказания
  final String? indications; // показания
  final String? sideEffects; // поб эфф
  final String? comment; //
  final String? directionsForUse; // рек по исп
  final String unit; // tip priema
  final List<Dose> doses;
  final int? remainsNotificate;
  final DateTime? startTreatment;
  final DateTime? endTreatment;

  const Medicine(
      {required this.name,
      required this.remains,
      this.contraindications,
      this.indications,
      this.sideEffects,
      this.comment,
      this.directionsForUse,
      required this.unit,
      required this.doses,
      this.remainsNotificate,
      this.startTreatment,
      this.endTreatment});

  Medicine copyWith(int remains) {
    return Medicine(
      name: name,
      remains: remains,
      unit: unit,
      doses: doses,
      comment: comment,
      startTreatment: startTreatment,
      endTreatment: endTreatment,
      contraindications: contraindications,
      indications: indications,
      directionsForUse: directionsForUse,
      remainsNotificate: remainsNotificate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'contraindications': contraindications,
      'indications': indications,
      'interaction ': directionsForUse,
    };
  }

  @override
  // TODO: implement props
  List<Object?> get props => [name, remains, unit, doses, comment];
}
