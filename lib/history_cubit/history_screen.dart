// Импортируем Flutter и виджеты для построения UI
import 'package:flutter/material.dart';

// Импортируем Bloc для управления состоянием экрана
import 'package:flutter_bloc/flutter_bloc.dart';

// Подключаем наш HistoryCubit, который управляет загрузкой истории вычислений
import 'history_cubit.dart';

/// Виджет Histo — это экран, отображающий историю вычислений энергии.
/// Он использует BlocBuilder, чтобы реагировать на изменения в ХistoryCubit
/// и показывать пользователю результаты предыдущих расчётов.
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Заголовок экрана
      appBar: AppBar(title: const Text('История расчетов')),

      // Основное содержимое экрана
      body: BlocBuilder<HistoryCubit, HistoryState>(
        builder: (context, state) {
          // Если состояние "загрузка" — показываем индикатор загрузки
          if (state is HistoryLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Если история успешно загружена — строим список вычислений
          if (state is HistoryLoaded) {
            return ListView.builder(
              itemCount: state.calculations.length,
              itemBuilder: (context, index) {
                final calc = state.calculations[index];

                return ListTile(
                  // Заголовок элемента списка — значение энергии
                  title: Text('Энергия: ${calc.energy.toStringAsFixed(2)} Дж'),

                  // Подзаголовок — исходные данные массы и скорости
                  subtitle: Text(
                    'Масса: ${calc.originalMass} '
                        '${calc.unitSystem == 'si' ? 'кг' : 'фунтов'}\n'
                    'Скорость: ${calc.originalVelocity} '
                        '${calc.unitSystem == 'si' ? 'км/ч' : 'миль/ч'}',
                  ),

                  // Дата и время вычисления — справа от элемента
                  trailing: Text(calc.formattedDate),
                );
              },
            );
          }

          // Если произошла ошибка — выводим сообщение об ошибке
          if (state is HistoryError) {
            return Center(child: Text(state.message));
          }

          // По умолчанию — пустой виджет
          return const SizedBox();
        },
      ),
    );
  }
}