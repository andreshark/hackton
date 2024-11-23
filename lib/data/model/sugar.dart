import 'package:equatable/equatable.dart';

class Sugar extends Equatable {
  final int sugarcount;
  final DateTime date;

  const Sugar({required this.sugarcount, required this.date});

  Map<String, dynamic> toJson() {
    return {
      'sugarcount': sugarcount,
      'date': date,
    };
  }

  @override
  // TODO: implement props
  List<Object?> get props => [sugarcount, date];
}
