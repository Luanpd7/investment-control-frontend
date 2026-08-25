import 'dart:math' as math;
import 'package:controle_investimento/util/text_style.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../domain/entities/investiment_record.dart';

class FinancialBarChart extends StatelessWidget {
  const FinancialBarChart({
    super.key,
    required this.evolutions,
    required this.loading,
  });

  final List<CategoryGrowth> evolutions;

  final bool loading;

  @override
  Widget build(BuildContext context) {
    double getMaxValue() {
      if (evolutions.isEmpty) {
        return 0.0;
      }

      double maxValue = 0.0;

      for (final e in evolutions) {
        maxValue = math.max(maxValue, e.emergency);
        maxValue = math.max(maxValue, e.fixedIncome);
        maxValue = math.max(maxValue, e.variableIncome);
      }

      return maxValue + 300;
    }

    final maxValue = getMaxValue();

    return Column(
      children: [
        SizedBox(
          height: 300,
          width: double.infinity,
          child: loading == true
              ? Center(child: CircularProgressIndicator())
              : evolutions.isEmpty
              ? Center(child: Text('Sem dados', style: AppTextStyles.label))
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: BarChart(
                    BarChartData(
                      maxY: maxValue,
                      alignment: BarChartAlignment.spaceAround,
                      gridData: FlGridData(show: true),
                      borderData: FlBorderData(show: false),

                      titlesData: FlTitlesData(
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),

                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: maxValue / 4,
                            reservedSize: 80,
                            minIncluded: false,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                NumberFormat.compactCurrency(
                                  locale: 'pt_BR',
                                  symbol: 'R\$',
                                ).format(value),
                              );
                            },
                          ),
                        ),

                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              final index = value.toInt();

                              if (index < 0 || index >= evolutions.length) {
                                return const SizedBox.shrink();
                              }

                              final date = evolutions[index].date;

                              return Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  DateFormat(
                                    'MMM/yyyy',
                                    'pt_BR',
                                  ).format(date).replaceAll('.', ''),
                                  style: const TextStyle(fontSize: 11),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      barTouchData: BarTouchData(
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipColor: (group) {
                            return Colors.grey.shade800;
                          },

                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            return BarTooltipItem(
                              'R\$ ${NumberFormat.currency(locale: 'pt_BR', symbol: '', decimalDigits: 2).format(rod.toY)}',
                              TextStyle(
                                color: colorLabelTooltip(rodIndex),
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                      ),

                      barGroups: evolutions.asMap().entries.map((entry) {
                        final index = entry.key;
                        final item = entry.value;

                        return makeGroup(
                          index,
                          item.emergency,
                          item.fixedIncome,
                          item.variableIncome,
                          evolutions.length,
                        );
                      }).toList(),
                    ),
                  ),
                ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              subtitle(colorLabelTooltip(0), "Emergência"),
              const SizedBox(width: 20),
              subtitle(colorLabelTooltip(1), "Renda Fixa"),
              const SizedBox(width: 20),
              subtitle(colorLabelTooltip(2), "Variável"),
            ],
          ),
        ),
      ],
    );
  }

  static BarChartGroupData makeGroup(
    int x,
    double emergency,
    double fixedIncome,
    double variableIncome,
    int totalItems,
  ) {
    double barWidth;

    if (totalItems <= 6) {
      barWidth = 16;
    } else if (totalItems <= 12) {
      barWidth = 12;
    } else if (totalItems <= 18) {
      barWidth = 9;
    } else {
      barWidth = 6;
    }

    return BarChartGroupData(
      x: x,
      barsSpace: totalItems > 12 ? 2 : 4,

      barRods: [
        BarChartRodData(
          toY: emergency,
          width: barWidth,
          color: colorLabelTooltip(0),
          borderRadius: BorderRadius.circular(4),
        ),
        BarChartRodData(
          toY: fixedIncome,
          width: barWidth,
          color: colorLabelTooltip(1),
          borderRadius: BorderRadius.circular(4),
        ),
        BarChartRodData(
          toY: variableIncome,
          width: barWidth,
          color: colorLabelTooltip(2),
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }
}

Widget subtitle(Color cor, String texto) {
  return Row(
    children: [
      Container(width: 14, height: 14, color: cor),
      const SizedBox(width: 6),
      Text(texto),
    ],
  );
}

Color colorLabelTooltip(int index) {
  switch (index) {
    case 0:
      return Color(0xFFF28B82);
    case 1:
      return Color(0xFF81C995);
    case 2:
      return Color(0xFFF6D365);
  }
  return Colors.white;
}
