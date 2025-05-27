// Импортируем Bloc из flutter_bloc для управления состоянием приложения
import 'package:flutter_bloc/flutter_bloc.dart';

// Для работы с JSON-данными (например, сохранение в SharedPreferences)
import 'dart:convert';

// Подключаем SharedPreferences для локального хранения данных
import 'package:shared_preferences/shared_preferences.dart';

// Подключаем модель данных CalculationModel, которая описывает один расчёт энергии
import 'calculation_model.dart';

// Состояния приложения (InputState, ResultState и т.п.)
import 'energy_state.dart';


/// Основной BLoC (Business Logic Component), отвечающий за вычисления энергии,
/// обработку ввода пользователя и сохранение истории вычислений.
class EnergyCalculatorCubit extends Cubit<EnergyCalculatorState> {
  // Экземпляр SharedPreferences для локального хранения данных
  late SharedPreferences _prefs;

  // Флаг, показывающий, инициализированы ли SharedPreferences
  bool _isPrefsInitialized = false;

  /// Конструктор кубита. Устанавливает начальное состояние [InitialState].
  EnergyCalculatorCubit() : super(InitialState()) {
    _initPrefs(); // Пытаемся загрузить данные из SharedPreferences
  }

  /// Асинхронный метод инициализации SharedPreferences
  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    _isPrefsInitialized = true;
  }

  /// Сохраняет вычисление в SharedPreferences как JSON-строку
  ///
  /// @param calculation - объект [CalculationModel], который нужно сохранить
  Future<void> _saveCalculation(CalculationModel calculation) async {
    if (!_isPrefsInitialized) await _initPrefs();

    // Получаем список уже сохранённых вычислений или создаём новый
    List<String> calculations = _prefs.getStringList('calculations') ?? [];

    // Преобразуем объект в JSON-строку и добавляем в список
    calculations.add(jsonEncode(calculation.toJson()));

    // Сохраняем обновлённый список обратно в SharedPreferences
    await _prefs.setStringList('calculations', calculations);
  }

  /// ЕДИНСТВЕННЫЙ МЕТОД, выполняющий вычисление энергии
  void calculateEnergy() async {
    // Получаем текущее состояние формы (InputState)
    final state = this.state as InputState;

    // Если пользователь не согласился с условиями — выходим
    if (!state.agreementChecked) return;

    // Пытаемся преобразовать введённые значения массы и скорости в числа
    final mass = double.tryParse(state.mass);
    final velocity = double.tryParse(state.velocity);

    // Если значения некорректны — выходим
    if (mass == null || velocity == null || mass <= 0 || velocity < 0) return;

    // Коэффициенты перевода единиц измерения
    const poundsToKg = 0.453592; // фунты -> килограммы
    const mphToMs = 0.44704;     // мили/ч -> метры/с
    const kmhToMs = 0.277778;    // км/ч -> метры/с

    // Переменные для хранения значений в системе СИ
    double convertedMass = mass;
    double convertedVelocity = velocity;

    // Применяем конвертацию, если используется имперская система
    if (state.unitSystem == 'imperial') {
      convertedMass *= poundsToKg;
      convertedVelocity *= mphToMs;
    } else {
      // Для метрической системы конвертируем только скорость
      convertedVelocity *= kmhToMs;
    }

    // Вычисляем кинетическую энергию по формуле: E = ½ * m * v²
    final energy = 0.5 * convertedMass * convertedVelocity * convertedVelocity;

    // Сохраняем результат в историю вычислений
    await _saveCalculation(CalculationModel(
      originalMass: mass,
      originalVelocity: velocity,
      unitSystem: state.unitSystem,
      energy: energy,
      timestamp: DateTime.now(),
    ));

    // Меняем состояние приложения на ResultState, передавая результаты
    emit(ResultState(
      mass: convertedMass,
      velocity: convertedVelocity,
      energy: energy,
      unitSystem: state.unitSystem,
      originalMass: mass,
      originalVelocity: velocity,
    ));
  }

  /// Возвращает приложение к начальному состоянию формы
  void initForm() {
    emit(InputState());
  }

  /// Обновляет значения полей ввода в форме
  ///
  /// @param mass - новое значение массы
  /// @param velocity - новое значение скорости
  /// @param agreementChecked - статус согласия с правилами
  /// @param unitSystem - выбранная система единиц измерения
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

  /// Возвращает пользователя к форме ввода из экрана результата
  void goBack() {
    emit(InputState());
  }
}