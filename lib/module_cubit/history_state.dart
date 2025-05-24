part of 'history_cubit.dart';

abstract class HistoryState {}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {
  final List<CalculationModel> calculations;
  HistoryLoaded(this.calculations);
}

class HistoryError extends HistoryState {
  final String message;
  HistoryError(this.message);
}