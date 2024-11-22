import 'package:equatable/equatable.dart';

class Pulse extends Equatable {
  final int pulsecount;
  final DateTime date;

  const Pulse({required this.pulsecount, required this.date});

  @override
  // TODO: implement props
  List<Object?> get props => [pulsecount, date];
}
