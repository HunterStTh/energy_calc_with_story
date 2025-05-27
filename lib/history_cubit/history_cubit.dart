// Импортируем библиотеку для работы с JSON-данными (кодирование/декодирование)
import 'dart:convert';

// Импортируем BLoC для управления состоянием в приложении
import 'package:flutter_bloc/flutter_bloc.dart';

// Подключаем SharedPreferences для локального хранения данных
import 'package:shared_preferences/shared_preferences.dart';

// Импортируем модель данных CalculationModel — она описывает одно вычисление
import '../module_cubit/calculation_model.dart';

// Подключаем часть файла, где определены состояния HistoryInitial, HistoryLoaded и др.
part 'history_state.dart';


/// Класс [HistoryCubit] отвечает за загрузку и управление историей вычислений.
///
/// Он использует SharedPreferences для получения сохранённых результатов,
/// преобразует их из строки JSON в объекты [CalculationModel],
/// и уведомляет UI о текущем состоянии (загрузка, успех, ошибка).
class HistoryCubit extends Cubit<HistoryState> {

  /// Конструктор кубита. При создании сразу вызывается метод [loadHistory],
  /// чтобы начать загрузку истории вычислений.
  HistoryCubit() : super(HistoryInitial()) {
    loadHistory();
  }

  /// Асинхронный метод для загрузки истории вычислений из SharedPreferences
  Future<void> loadHistory() async {
    // Сначала отправляем состояние "загрузка", чтобы показать индикатор загрузки
    emit(HistoryLoading());

    try {
      // Получаем доступ к SharedPreferences
      final prefs = await SharedPreferences.getInstance();

      // Получаем список строк из SharedPreferences по ключу 'calculations'
      // Если список пуст, возвращаем пустой список
      final calculations = prefs.getStringList('calculations') ?? [];

      // Преобразуем каждую строку JSON обратно в объект [CalculationModel]
      final List<CalculationModel> history = calculations
          .map((e) => CalculationModel.fromJson(jsonDecode(e)))
          .toList();

      // Отправляем состояние "успешно загружено" с данными истории
      emit(HistoryLoaded(history));
    } catch (e) {
      // Если произошла ошибка, отправляем состояние ошибки с сообщением
      emit(HistoryError('Ошибка загрузки истории'));
    }
  }
}