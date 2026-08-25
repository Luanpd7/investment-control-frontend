class InvestmentRecord {
  final int? id;
  final DateTime? date;
  final double emergency;
  final double fixedIncome;
  final double variableIncome;
  final double contribution;
  final double? variation;
  final double? total;

  InvestmentRecord({
    required this.date,
    required this.emergency,
    required this.fixedIncome,
    required this.variableIncome,
    required this.contribution,
    this.variation,
    this.total,
    this.id,
  });

  factory InvestmentRecord.fromJson(Map<String, dynamic> json) {
    return InvestmentRecord(
      id: json['id'],
      date: json['date'] != '' ? DateTime.parse(json['date']) : null,
      emergency: (json['emergency'] ?? 0).toDouble(),
      fixedIncome: (json['fixed_income'] ?? 0).toDouble(),
      variableIncome: (json['variable_income'] ?? 0).toDouble(),
      contribution: (json['contribution'] ?? 0).toDouble(),
      variation: (json['variation'] ?? 0).toDouble(),
      total: (json['total'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date?.toIso8601String(),
      'emergency': emergency,
      'fixed_income': fixedIncome,
      'variable_income': variableIncome,
      'contribution': contribution,
    };
  }

  @override
  String toString() {
    return 'InvestmentRecord{id: $id, date: $date, emergency: $emergency, fixedIncome: $fixedIncome, variableIncome: $variableIncome, contribution: $contribution, variation: $variation, total: $total}';
  }
}

class AssetsGrowth {
  final int year;
  final double total;

  AssetsGrowth({required this.year, required this.total});

  factory AssetsGrowth.fromJson(Map<String, dynamic> json) {
    return AssetsGrowth(
      year: (json['year'] as num?)?.toInt() ?? 0,
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class CategoryGrowth {
  final DateTime date;
  final double emergency;
  final double fixedIncome;
  final double variableIncome;

  CategoryGrowth({
    required this.date,
    required this.emergency,
    required this.fixedIncome,
    required this.variableIncome,
  });

  factory CategoryGrowth.fromJson(Map<String, dynamic> json) {
    return CategoryGrowth(
      date: DateTime.parse(json['date']),
      emergency: (json['emergency'] ?? 0).toDouble(),
      fixedIncome: (json['fixed_income'] ?? 0).toDouble(),
      variableIncome: (json['variable_income'] ?? 0).toDouble(),
    );
  }
}
