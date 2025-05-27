// Импортируем библиотеку intl для форматирования даты и времени
import 'package:intl/intl.dart';

/// Модель данных для хранения информации о вычислениях.
/// Содержит исходные данные, результат вычисления энергии,
/// систему единиц измерения и временную метку.
class CalculationModel {
  /// Исходная масса, переданная пользователем
  final double originalMass;

  /// Исходная скорость, переданная пользователем
  final double originalVelocity;

  /// Система единиц измерения метрическую или империческую
  final String unitSystem;

  /// Рассчитанное значение кинетической энергии
  final double energy;

  /// Временная метка, указывающая, когда было выполнено вычисление
  final DateTime timestamp;

  /// Конструктор модели вычисления
  CalculationModel({
    required this.originalMass,
    required this.originalVelocity,
    required this.unitSystem,
    required this.energy,
    required this.timestamp,
  });

  /// Преобразует объект [CalculationModel] в JSON-объект.
  /// Используется при сохранении данных в локальное хранилище или отправке на сервер.
  Map<String, dynamic> toJson() => {
        'originalMass': originalMass,
        'originalVelocity': originalVelocity,
        'unitSystem': unitSystem,
        'energy': energy,
        // Дата сохраняется в ISO 8601 формате как строка
        'timestamp': timestamp.toIso8601String(),
      };

  /// Создаёт объект [CalculationModel] из JSON-объекта.
  /// Используется при загрузке данных из локального хранилища или получения от сервера.
  factory CalculationModel.fromJson(Map<String, dynamic> json) => CalculationModel(
        originalMass: json['originalMass'].toDouble(),
        originalVelocity: json['originalVelocity'].toDouble(),
        unitSystem: json['unitSystem'],
        energy: json['energy'].toDouble(),
        // Дата парсится из строки в объект [DateTime]
        timestamp: DateTime.parse(json['timestamp']),
      );

  /// Возвращает отформатированную строку даты и времени.
  String get formattedDate => DateFormat('dd.MM.yyyy HH:mm').format(timestamp);
}