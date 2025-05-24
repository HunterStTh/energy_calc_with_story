// Добавляем необходимые импорты
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'calculation_model.dart'; // Ваш новый файл с моделью данных
import 'energy_state.dart';

// Исправленный EnergyCalculatorCubit
class EnergyCalculatorCubit extends Cubit<EnergyCalculatorState> {
  late SharedPreferences _prefs;
  bool _isPrefsInitialized = false;

  EnergyCalculatorCubit() : super(InitialState()) {
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    _isPrefsInitialized = true;
  }

  Future<void> _saveCalculation(CalculationModel calculation) async {
    if (!_isPrefsInitialized) await _initPrefs();
    List<String> calculations = _prefs.getStringList('calculations') ?? [];
    calculations.add(jsonEncode(calculation.toJson()));
    await _prefs.setStringList('calculations', calculations);
  }

  // ОДИН ЕДИНСТВЕННЫЙ МЕТОД calculateEnergy()
  void calculateEnergy() async {
    final state = this.state as InputState;
    
    if (!state.agreementChecked) return;

    final mass = double.tryParse(state.mass);
    final velocity = double.tryParse(state.velocity);
    
    if (mass == null || velocity == null || mass <= 0 || velocity < 0) return;

    const poundsToKg = 0.453592;
    const mphToMs = 0.44704;
    const kmhToMs = 0.277778;

    double convertedMass = mass;
    double convertedVelocity = velocity;

    if (state.unitSystem == 'imperial') {
      convertedMass *= poundsToKg;
      convertedVelocity *= mphToMs;
    } else {
      convertedVelocity *= kmhToMs;
    }

    final energy = 0.5 * convertedMass * convertedVelocity * convertedVelocity;

    await _saveCalculation(CalculationModel(
      originalMass: mass,
      originalVelocity: velocity,
      unitSystem: state.unitSystem,
      energy: energy,
      timestamp: DateTime.now(),
    ));

    emit(ResultState(
      mass: convertedMass,
      velocity: convertedVelocity,
      energy: energy,
      unitSystem: state.unitSystem,
      originalMass: mass,
      originalVelocity: velocity,
    ));
  }

  void initForm() {
    emit(InputState());
  }

  void updateValues({
    String? mass,
    String? velocity,
    bool? agreementChecked,
    String? unitSystem,
  }) {
    final currentState = state as InputState;
    emit(InputState(
      mass: mass ?? currentState.mass,
      velocity: velocity ?? currentState.velocity,
      agreementChecked: agreementChecked ?? currentState.agreementChecked,
      unitSystem: unitSystem ?? currentState.unitSystem,
    ));
  }

  void goBack() {
    emit(InputState());
  }
}