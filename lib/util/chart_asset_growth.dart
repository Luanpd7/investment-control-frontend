import 'package:controle_investimento/domain/entities/investiment_record.dart';
import 'package:controle_investimento/util/text_style.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math' as math;
import 'package:intl/intl.dart';

class FinancialEvolutionChart extends StatelessWidget {
  const FinancialEvolutionChart({
    super.key,
    required this.evolutions,
    required this.loading,
  });

  final List<AssetsGrowth> evolutions;

  final bool loading;

  @override
  Widget build(BuildContext context) {
    final maxValue = evolutions.isNotEmpty
        ? evolutions.map((e) => math.max(e.total, 0)).reduce(math.max)
        : 0;

    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 12, vertical: 20),
      child: SizedBox(
        height: 300,
        width: double.infinity,
        child: loading == true
            ? Center(child: CircularProgressIndicator())
            : evolutions.isEmpty
            ? Center(child: Text('Sem dados', style: AppTextStyles.label))
            : Padding(
                padding: const EdgeInsets.all(16),
                child: LineChart(
                  LineChartData(
                    maxX: evolutions.isNotEmpty
                        ? evolutions.last.year.toDouble()
                        : 1,
                    maxY: maxValue * 1.1,

                    gridData: FlGridData(show: true, drawVerticalLine: false),

                    borderData: FlBorderData(
                      show: true,
                      border: Border(
                        left: BorderSide(color: Colors.grey.shade400),
                        bottom: BorderSide(color: Colors.grey.shade400),
                      ),
                    ),

                    titlesData: FlTitlesData(
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),

                      bottomTitles: AxisTitles(
                        axisNameWidget: const Text("Anos"),
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 5,
                          getTitlesWidget: (value, meta) {
                            return Text(value.toInt().toString());
                          },
                        ),
                      ),

                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: maxValue == 0 ? 1 : maxValue / 4,
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
                    ),

                    lineTouchData: LineTouchData(
                      touchTooltipData: LineTouchTooltipData(
                        getTooltipColor: (group) {
                          return Colors.grey.shade800;
                        },
                        getTooltipItems: (List<LineBarSpot> touchedSpots) {
                          return touchedSpots.map((spot) {
                            return LineTooltipItem(
                              'R\$ ${NumberFormat.currency(locale: 'pt_BR', symbol: '', decimalDigits: 2).format(spot.y)}',
                              TextStyle(
                                color: Color(0xFF7DB7E8),
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }).toList();
                        },
                        tooltipBorderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),

                    lineBarsData: [
                      LineChartBarData(
                        isCurved: true,
                        color: Color(0xFF7DB7E8),
                        barWidth: 4,
                        dotData: const FlDotData(show: true),
                        spots: evolutions
                            .map((e) => FlSpot(e.year.toDouble(), e.total))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
