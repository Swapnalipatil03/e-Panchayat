// funding_pie_chart.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class FundingPieChart {
  static List<PieChartSectionData> buildSections(double progress) {
    // Define each section with target values
    final double section1Value = 70; // Govt. of India
    final double section2Value = 10; // State Govt.
    final double section3Value = 20; // Other

    // Calculate intermediate values for the fan-out effect
    final double section1Progress =
        (progress >= 0.33) ? section1Value : section1Value * (progress / 0.33);
    final double section2Progress = (progress >= 0.66)
        ? section2Value
        : section2Value * ((progress - 0.33) / 0.33).clamp(0, 1);
    final double section3Progress = (progress == 1.0)
        ? section3Value
        : section3Value * ((progress - 0.66) / 0.34).clamp(0, 1);

    return [
      PieChartSectionData(
        color: Colors.blue,
        value: section1Progress,
        //title: 'Govt. of India',
        titleStyle: const TextStyle(color: Colors.white),
      ),
      PieChartSectionData(
        color: Colors.green,
        value: section2Progress,
        //title: 'State Govt.',
        titleStyle: const TextStyle(color: Colors.white),
      ),
      PieChartSectionData(
        color: Colors.orange,
        value: section3Progress,
        //title: 'Other',
        titleStyle: const TextStyle(color: Colors.white),
      ),
    ];
  }
}
