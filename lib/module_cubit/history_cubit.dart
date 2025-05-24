import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'calculation_model.dart';

part 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit() : super(HistoryInitial()) {
    loadHistory();
  }

  Future<void> loadHistory() async {
    emit(HistoryLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final calculations = prefs.getStringList('calculations') ?? [];
      emit(HistoryLoaded(
        calculations.map((e) => CalculationModel.fromJson(jsonDecode(e))).toList(),
      ));
    } catch (e) {
      emit(HistoryError('Ошибка загрузки истории'));
    }
  }
}