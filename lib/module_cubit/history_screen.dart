import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'calculation_model.dart';
import 'history_cubit.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('История расчетов')),
      body: BlocBuilder<HistoryCubit, HistoryState>(
        builder: (context, state) {
          if (state is HistoryLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is HistoryLoaded) {
            return ListView.builder(
              itemCount: state.calculations.length,
              itemBuilder: (context, index) {
                final calc = state.calculations[index];
                return ListTile(
                  title: Text('Энергия: ${calc.energy.toStringAsFixed(2)} Дж'),
                  subtitle: Text(
                    'Масса: ${calc.originalMass} ${calc.unitSystem == 'si' ? 'кг' : 'фунтов'}\n'
                    'Скорость: ${calc.originalVelocity} ${calc.unitSystem == 'si' ? 'км/ч' : 'миль/ч'}',
                  ),
                  trailing: Text(calc.formattedDate),
                );
              },
            );
          }
          if (state is HistoryError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox();
        },
      ),
    );
  }
}