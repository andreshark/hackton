import 'package:equatable/equatable.dart';

class Doctor extends Equatable {
  final String name;
  final DateTime date;

  const Doctor({required this.name, required this.date});

  @override
  // TODO: implement props
  List<Object?> get props => [name, date];
}
