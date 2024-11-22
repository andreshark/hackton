import 'package:equatable/equatable.dart';

class Dose extends Equatable {
  final int hour;
  final int minute;
  final int dosage;

  const Dose({required this.hour, required this.minute, required this.dosage});

  Dose copyWith({int? hour, int? minute, int? dosage}) {
    return Dose(
        hour: hour ?? this.hour,
        minute: minute ?? this.minute,
        dosage: dosage ?? this.dosage);
  }

  String getTime() {
    return '${hour < 10 ? '0${hour}' : hour}:${minute < 10 ? '0${minute}' : minute}';
  }

  @override
  // TODO: implement props
  List<Object?> get props => [hour, minute, dosage];
}
