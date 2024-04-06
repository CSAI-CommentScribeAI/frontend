import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class FeedbackChart extends StatelessWidget {
  final bool isWeekData; // 주차별로 보여줄 데이터
  const FeedbackChart({super.key, required this.isWeekData});

  @override
  Widget build(BuildContext context) {
    final List<ChartData> thisWeekData = [
      ChartData('MON', 2, 3, 14, 13, 70),
      ChartData('TUE', 4, 14, 12, 14, 12),
      ChartData('WED', 4, 3, 14, 12, 19),
      ChartData('THU', 3, 2, 16, 8, 24),
      ChartData('FRI', 4, 1, 12, 15, 34),
      ChartData('SAT', 4, 2, 15, 22, 26),
      ChartData('SUN', 1, 3, 5, 18, 30),
    ];

    final List<ChartData> lastWeekData = [
      ChartData('MON', 3, 4, 10, 11, 65),
      ChartData('TUE', 5, 13, 11, 13, 15),
      ChartData('WED', 5, 4, 13, 11, 18),
      ChartData('THU', 7, 3, 15, 7, 26),
      ChartData('FRI', 5, 1, 15, 14, 32),
      ChartData('SAT', 5, 3, 14, 26, 25),
      ChartData('SUN', 0, 4, 4, 17, 29),
    ];

    // isWeekData를 home_screen.dart에서 받는데 thisColor 값에 따라 불리안형 값이 달라짐
    // true일 경우 이번주 데이터를, false일 경우 저번주 데이터를 보여줌
    final List<ChartData> weekData = isWeekData ? thisWeekData : lastWeekData;

    return Center(
      child: SfCartesianChart(
        primaryXAxis: const CategoryAxis(), // 그래프 높이 표시
        series: <CartesianSeries>[
          StackedColumnSeries<ChartData, String>(
            dataSource: weekData,
            xValueMapper: (ChartData data, _) => data.x,
            yValueMapper: (ChartData data, _) => data.y1,
            color: const Color(0xFFD9D9D9),
          ),
          StackedColumnSeries<ChartData, String>(
            dataSource: weekData,
            xValueMapper: (ChartData data, _) => data.x,
            yValueMapper: (ChartData data, _) => data.y2,
            color: const Color(0xFFC6C3C3),
          ),
          StackedColumnSeries<ChartData, String>(
            dataSource: weekData,
            xValueMapper: (ChartData data, _) => data.x,
            yValueMapper: (ChartData data, _) => data.y3,
            color: const Color(0xFFD7D7FE),
          ),
          StackedColumnSeries<ChartData, String>(
            dataSource: weekData,
            xValueMapper: (ChartData data, _) => data.x,
            yValueMapper: (ChartData data, _) => data.y4,
            color: const Color(0xFF7B88C2),
          ),
          StackedColumnSeries<ChartData, String>(
            dataSource: weekData,
            xValueMapper: (ChartData data, _) => data.x,
            yValueMapper: (ChartData data, _) => data.y5,
            color: const Color(0xFF374AA3),
          ),
        ],
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y1, this.y2, this.y3, this.y4, this.y5);
  final String x;
  final double y1;
  final double y2;
  final double y3;
  final double y4;
  final double y5;
}
