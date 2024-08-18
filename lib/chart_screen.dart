import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'data_provider.dart';

class ChartScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(dataProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Year-wise Funds Allocation'),
      ),
      body: data.when(
        data: (data) {
          double minY = data
              .map((e) => e['budget_allocation'].toDouble())
              .reduce((a, b) => a < b ? a : b);
          double maxY = data
              .map((e) => e['budget_allocation'].toDouble())
              .reduce((a, b) => a > b ? a : b);

          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                // Header Section
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Year-wise Details of Funds Allocated for Mahila Kisan Sashaktikaran Pariyojana (MKSP) - a sub-Scheme under DAY-NRLM from 2018-19 to 2023-24",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      InkWell(
                        onTap: () {
                          _showMoreInfo(context);
                        },
                        child: Text(
                          'Show More',
                          style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Chart Section
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        RotatedBox(
                          quarterTurns: -1,
                          child: Text(
                            'Value in Rs. Crore',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Container(
                          width: data.length * 100,
                          height: 400,
                          child: LineChart(
                            LineChartData(
                              minY: minY > 0 ? minY - 10 : 0,
                              maxY: maxY + 10,
                              titlesData: FlTitlesData(
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 40,
                                    getTitlesWidget: (value, meta) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: Text(
                                          value.toInt().toString(),
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    interval: 1,
                                    getTitlesWidget: (value, meta) {
                                      int yearIndex = value.toInt();
                                      if (yearIndex >= 0 &&
                                          yearIndex < data.length) {
                                        return SideTitleWidget(
                                          axisSide: meta.axisSide,
                                          space: 5,
                                          child: Text(
                                            data[yearIndex]['financial_year']
                                                .toString(),
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                        );
                                      }
                                      return const SizedBox.shrink();
                                    },
                                  ),
                                ),
                                topTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                rightTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                              ),
                              borderData: FlBorderData(show: true),
                              lineBarsData: [
                                LineChartBarData(
                                  spots: data.asMap().entries.map((entry) {
                                    int index = entry.key;
                                    final year = index.toDouble();
                                    final allocation = entry
                                        .value['budget_allocation']
                                        .toDouble();
                                    return FlSpot(year, allocation);
                                  }).toList(),
                                  isCurved: true,
                                  color: Colors.pink,
                                  barWidth: 4,
                                  belowBarData: BarAreaData(
                                    show: true,
                                    color: Colors.pink.withOpacity(0.3),
                                  ),
                                  dotData: FlDotData(show: true),
                                ),
                              ],
                              gridData: FlGridData(
                                show: true,
                                horizontalInterval: 50,
                                getDrawingHorizontalLine: (value) {
                                  return FlLine(
                                    color: Colors.grey,
                                    strokeWidth: 1,
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Footer Section
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Budget Allocation Year-wise',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  void _showMoreInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Full Details'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text(
                  'August 9, 2024\nAuthor: Akhilesh Kumar Srivastava\n\n'
                  'The graph shows the year-wise details of funds allocated for Mahila Kisan Sashaktikaran Pariyojana (MKSP) – a sub-Scheme under Deendayal Antyodaya Yojana-National Rural Livelihoods Mission (DAY-NRLM) from 2018-19 to 2023-24. '
                  'The total allocated fund was Rs. 424.91 crore for Mahila Kisan Sashaktikaran Pariyojana (MKSP)-a sub-Scheme under (DAY-NRLM). The highest allocated fund was Rs. 300 Crore for Mahila Kisan Sashaktikaran Pariyojana (MKSP)-a sub-Scheme under (DAY-NRLM) in 2023-24. '
                  'The lowest allocated funds was Rs.10.74 crore for Mahila Kisan Sashaktikaran Pariyojana (MKSP)-a sub-Scheme under (DAY-NRLM) in 2022-23.\n\n'
                  'Note: Source – RAJYA SABHA SESSION – 263 UNSTARRED QUESTION No 36. ANSWERED ON, 2nd February 2024. Data Figures are in Rs. Crore. Deendayal Antyodaya Yojana-National Rural Livelihoods Mission (DAY-NRLM).\n\n'
                  'Dataset URL: https://www.data.gov.in/resource/year-wise-amount-funds-allocated-and-utilizedreleased-mahila-kisan-sashaktikaran\n\n'
                  'Resource Title: Year-wise Amount of Funds Allocated and Utilized/Released for Mahila Kisan Sashaktikaran Pariyojana (MKSP)-a sub-Scheme under (DAY-NRLM) from 2018-19 to 2023-24',
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
