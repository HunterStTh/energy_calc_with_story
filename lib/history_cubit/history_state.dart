// Указываем, что этот файл является частью 'history_cubit.dart'
// чтобы использовать internal-типы и методы из основного файла
part of 'history_cubit.dart';


/// Абстрактный класс HistoryState класс для всех возможных состояний,
/// в которых может находиться экран истории вычислений.
/// Наследуются от него конкретные состояния: начальное, загрузка, загружено, ошибка.
abstract class HistoryState {}


/// начальное состояние перед началом загрузки истории.
class HistoryInitial extends HistoryState {}


/// сигнализирует, что данные истории вычислений загружаются.
/// Используется, чтобы показать пользователю индикатор загрузки (например, прогресс-бар).
class HistoryLoading extends HistoryState {}


/// содержит список вычислений, полученных из SharedPreferences.
/// calculations - список объектов [CalculationModel], представляющих историю расчётов
class HistoryLoaded extends HistoryState {
  final List<CalculationModel> calculations;

  HistoryLoaded(this.calculations);
}


///  при возникновении ошибки во время загрузки истории.
///  message - текстовое описание ошибки, которое можно отобразить пользователю
class HistoryError extends HistoryState {
  final String message;

  HistoryError(this.message);
}