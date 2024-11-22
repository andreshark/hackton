import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:med_hackton/data/model/dose_active.dart';
import 'package:med_hackton/data/model/medicine.dart';
import 'package:med_hackton/presentation/bloc/local_data/local_data_state.dart';
import 'package:med_hackton/presentation/bloc/medicine/medicine_state.dart';

import '../../../data/model/dose.dart';

class LocalDataBloc extends Cubit<LocalDataState> {
  LocalDataBloc() : super(const LocalDataState(medicines: []));

  List<ActiveDose> get allActiveDoses {
    List<ActiveDose> doses = [];
    for (Medicine medicine in medicines) {
      for (Dose dose in medicine.doses) {
        doses.add(ActiveDose(
            medicine: medicine, dose: dose, doseState: DoseState.waiting));
      }
    }
    return doses;
  }

  List<ActiveDose> get lastActiveDoses {
    List<ActiveDose> doses = [];
    for (Medicine medicine in medicines) {
      for (Dose dose in medicine.doses) {
        if ((dose.hour == DateTime.now().hour &&
                dose.minute >= DateTime.now().minute) ||
            dose.hour > DateTime.now().hour) {
          doses.add(ActiveDose(
              medicine: medicine, dose: dose, doseState: DoseState.waiting));
        }
      }
    }
    doses.sort((a, b) {
      if (a.dose.hour.compareTo(a.dose.hour) == 0) {
        return a.dose.minute.compareTo(a.dose.minute);
      }
      return a.dose.hour.compareTo(a.dose.hour);
    });
    return doses;
  }

  List<Medicine> get medicines => state.medicines!;
  set medicines(List<Medicine> medicines) {
    emit(state.copyWith(medicines: medicines));
  }

  void addMedicine(Medicine medicine) {
    List<Medicine> medicines1 = List.from(medicines);
    medicines1.add(medicine);

    emit(state.copyWith(medicines: medicines1));
  }
}
