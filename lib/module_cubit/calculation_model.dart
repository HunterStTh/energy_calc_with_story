import 'package:intl/intl.dart';

class CalculationModel {
  final double originalMass;
  final double originalVelocity;
  final String unitSystem;
  final double energy;
  final DateTime timestamp;

  CalculationModel({
    required this.originalMass,
    required this.originalVelocity,
    required this.unitSystem,
    required this.energy,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'originalMass': originalMass,
    'originalVelocity': originalVelocity,
    'unitSystem': unitSystem,
    'energy': energy,
    'timestamp': timestamp.toIso8601String(),
  };

  factory CalculationModel.fromJson(Map<String, dynamic> json) => CalculationModel(
    originalMass: json['originalMass'].toDouble(),
    originalVelocity: json['originalVelocity'].toDouble(),
    unitSystem: json['unitSystem'],
    energy: json['energy'].toDouble(),
    timestamp: DateTime.parse(json['timestamp']),
  );

  String get formattedDate => DateFormat('dd.MM.yyyy HH:mm').format(timestamp);
}