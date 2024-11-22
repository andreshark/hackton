import 'package:equatable/equatable.dart';

class Steps extends Equatable {
  final int stepsCount;
  final DateTime date;

  const Steps({required this.stepsCount, required this.date});

  @override
  // TODO: implement props
  List<Object?> get props => [stepsCount, date];
}
