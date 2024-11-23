import 'package:equatable/equatable.dart';

class Pulse extends Equatable {
  final int pulsecount;
  final DateTime date;

  const Pulse({required this.pulsecount, required this.date});

  Map<String, dynamic> toJson() {
    return {
      'pulsecount': pulsecount,
      'date': date,
    };
  }

  @override
  // TODO: implement props
  List<Object?> get props => [pulsecount, date];
}
