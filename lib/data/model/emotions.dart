import 'package:equatable/equatable.dart';

class Emotions extends Equatable {
  final int rate;
  final List<String> symptoms;
  final DateTime date;

  const Emotions(
      {required this.rate, required this.symptoms, required this.date});

  Map<String, dynamic> toJson() {
    return {
      'five-digit_emotion_rate': rate,
      'symptoms': symptoms,
    };
  }

  @override
  // TODO: implement props
  List<Object?> get props => [rate, symptoms, date];
}
