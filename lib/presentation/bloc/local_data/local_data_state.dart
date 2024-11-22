import 'package:equatable/equatable.dart';
import 'package:med_hackton/data/model/medicine.dart';

class LocalDataState extends Equatable {
  final List<Medicine>? medicines;
  const LocalDataState({
    this.medicines,
  });

  @override
  List<Object?> get props => [medicines];

  LocalDataState copyWith({
    List<Medicine>? medicines,
  }) {
    return LocalDataState(
      medicines: medicines ?? this.medicines,
    );
  }
}
