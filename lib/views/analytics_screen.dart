import 'package:expense_tracker/providers/analytics_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Getting our screen height
    final height = MediaQuery.of(context).size.height;

    // Retrieve the current view (weekly or monthly)
    final showWeekly = ref.watch(analyticsToggleProvider);

    // Retrieve the expenses from the AnalyticsViewModel
    ref.watch(analyticsViewModelProvider);

    // Access the AnalyticsViewModel methods
    final viewModel = ref.read(analyticsViewModelProvider.notifier);

    // Group expenses by day of the week or month
    final chartData = showWeekly
        ? viewModel.getWeeklyExpenses()
        : viewModel.getYearlyExpenses();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo[700],
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Expense Analytics',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: height * 0.01),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        ref.read(analyticsToggleProvider.notifier).state
                            ? Colors.indigo[100]
                            : Colors.white,
                  ),
                  onPressed: () {
                    ref.read(analyticsToggleProvider.notifier).state =
                        true; // Show weekly expenses
                  },
                  child: const Text('Weekly'),
                ),
                const SizedBox(width: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor:
                          !ref.read(analyticsToggleProvider.notifier).state
                              ? Colors.indigo[100]
                              : Colors.white),
                  onPressed: () {
                    ref.read(analyticsToggleProvider.notifier).state =
                        false; // Show monthly expenses
                  },
                  child: const Text('Yearly'),
                ),
              ],
            ),
            SizedBox(height: height * 0.04),
            SizedBox(
              height: height * 0.35,
              child: BarChart(
                BarChartData(
                  barGroups:
                      viewModel.getBarGroups(chartData), // Get bar groups
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    show: true,
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: false,
                      ),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: false,
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        reservedSize: 25,
                        showTitles: true,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          const style = TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          );
                          String label;

                          if (showWeekly) {
                            // Show weekdays for weekly view
                            switch (value.toInt()) {
                              case 0:
                                label = 'Mon';
                                break;
                              case 1:
                                label = 'Tue';
                                break;
                              case 2:
                                label = 'Wed';
                                break;
                              case 3:
                                label = 'Thu';
                                break;
                              case 4:
                                label = 'Fri';
                                break;
                              case 5:
                                label = 'Sat';
                                break;
                              case 6:
                                label = 'Sun';
                                break;
                              default:
                                label = '';
                            }
                          } else {
                            // Show month numbers for monthly view
                            switch (value.toInt()) {
                              case 0:
                                label = '1';
                                break;
                              case 1:
                                label = '2';
                                break;
                              case 2:
                                label = '3';
                                break;
                              case 3:
                                label = '4';
                                break;
                              case 4:
                                label = '5';
                                break;
                              case 5:
                                label = '6';
                                break;
                              case 6:
                                label = '7';
                                break;
                              case 7:
                                label = '8';
                                break;
                              case 8:
                                label = '9';
                                break;
                              case 9:
                                label = '10';
                                break;
                              case 10:
                                label = '11';
                                break;
                              case 11:
                                label = '12';
                                break;
                              default:
                                label = '';
                            }
                          }

                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            child: Text(label, style: style),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            child: Text(
                              '${value.toInt()}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
