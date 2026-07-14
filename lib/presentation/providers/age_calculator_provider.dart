import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_age_calculator_pro/core/utils/age_calculator.dart';
import 'package:smart_age_calculator_pro/domain/entities/age_result.dart';

final ageCalculatorProvider =
    StateNotifierProvider<AgeCalculatorNotifier, AgeResult?>(
        (ref) => AgeCalculatorNotifier());

class AgeCalculatorNotifier extends StateNotifier<AgeResult?> {
  AgeCalculatorNotifier() : super(null);

  void calculateAge(DateTime birthDate) {
    state = AgeCalculator.calculateAge(birthDate);
  }

  void reset() {
    state = null;
  }
}
