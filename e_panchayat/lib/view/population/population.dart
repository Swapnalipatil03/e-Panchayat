import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class Population extends StatefulWidget {
  const Population({super.key});
  @override
  State createState() => _Population();
}

class _Population extends State<Population>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // Define animation to go from 0 to 360 degrees
    _animation = Tween<double>(begin: 0, end: 360).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    // Start the animation
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(229, 230, 248, 1),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(0, 137, 123, 1),
                Color.fromRGBO(0, 204, 255, 1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Row(
          children: [
            Image.asset(
              "assets/images/logo.png",
              height: 50,
              width: 50,
            ),
            const SizedBox(width: 10),
            const Text(
              'e-Panchayat',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 25),
            ),
          ],
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate to the previous screen
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ElevatedButton(
                  onPressed: () {},
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.white),
                  child: Text(
                    "Population Dashboard",
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.black,
                        fontWeight: FontWeight.w600),
                  )),
              const SizedBox(height: 20),

              // Line Chart for Literacy Rate
              const Text(
                "Literacy Rate (Male, Female, Children)",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 300,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(show: true), // Show grid
                      borderData: FlBorderData(
                        show: true,
                        border: const Border(
                          bottom: BorderSide(color: Colors.black, width: 1),
                          left: BorderSide(color: Colors.black, width: 1),
                        ),
                      ),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 1,
                            getTitlesWidget: (value, _) {
                              switch (value.toInt()) {
                                case 0:
                                  return const Text('2020');
                                case 1:
                                  return const Text('2021');
                                case 2:
                                  return const Text('2022');
                                case 3:
                                  return const Text('2023');
                                case 4:
                                  return const Text('2024');
                                case 5:
                                  return const Text('2025');
                                default:
                                  return const Text('');
                              }
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 10,
                            reservedSize: 40,
                            getTitlesWidget: (value, _) {
                              return Text('${value.toInt()}%');
                            },
                          ),
                        ),
                        topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                      ),
                      lineBarsData: [
                        LineChartBarData(
                          spots: const [
                            FlSpot(0, 70), // 2020
                            FlSpot(1, 72), // 2021
                            FlSpot(2, 75), // 2022
                            FlSpot(3, 78), // 2023
                            FlSpot(4, 80), // 2024
                            FlSpot(5, 82), // 2025
                          ],
                          isCurved: true,
                          color: Colors.blue, // Male
                          barWidth: 4,
                          dotData: FlDotData(show: true),
                        ),
                        LineChartBarData(
                          spots: const [
                            FlSpot(0, 65), // 2020
                            FlSpot(1, 67), // 2021
                            FlSpot(2, 70), // 2022
                            FlSpot(3, 73), // 2023
                            FlSpot(4, 76), // 2024
                            FlSpot(5, 79), // 2025
                          ],
                          isCurved: true,
                          color: Colors.green, // Female
                          barWidth: 4,
                          dotData: FlDotData(show: true),
                        ),
                        LineChartBarData(
                          spots: const [
                            FlSpot(0, 50), // 2020
                            FlSpot(1, 52), // 2021
                            FlSpot(2, 55), // 2022
                            FlSpot(3, 58), // 2023
                            FlSpot(4, 60), // 2024
                            FlSpot(5, 63), // 2025
                          ],
                          isCurved: true,
                          color: Colors.pink, // Children
                          barWidth: 4,
                          dotData: FlDotData(show: true),
                        ),
                      ],
                      minX: 0,
                      maxX: 5,
                      minY: 40,
                      maxY: 90,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              // Legend Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildLegend("Male", Colors.blue),
                  _buildLegend("Female", Colors.red),
                  _buildLegend("Children", Colors.green),
                ],
              ),
              const SizedBox(height: 40),

              // Pie Chart for Population Distribution
              const Text(
                "Population Distribution",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Center(
                child: SizedBox(
                  height: 200,
                  child: AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return PieChart(
                        PieChartData(
                          startDegreeOffset: _animation.value,
                          sections: [
                            PieChartSectionData(
                              value: 40,
                              color: Colors.blue,
                              title: 'Male',
                              radius: 50,
                            ),
                            PieChartSectionData(
                              value: 45,
                              color: Colors.pink,
                              title: 'Female',
                              radius: 50,
                            ),
                            PieChartSectionData(
                              value: 15,
                              color: Colors.green,
                              title: 'Children',
                              radius: 50,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Cards for Population Counts
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildInfoCard("Male", "3000", Colors.blue),
                  _buildInfoCard("Female", "2500", Colors.pink),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildInfoCard("Children (0-12)", "300", Colors.green),
                  _buildInfoCard("Newborns", "40", Colors.orange),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, Color color) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      color: color,
      child: Container(
        width: 150,
        height: 100,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildLegend(String label, Color color) {
  return Row(
    children: [
      Container(
        width: 20,
        height: 20,
        color: color,
      ),
      const SizedBox(width: 8),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          //Text(code, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    ],
  );
}
