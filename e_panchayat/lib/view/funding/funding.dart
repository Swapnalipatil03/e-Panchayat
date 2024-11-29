import 'dart:developer';

import 'package:e_panchayat/model/fundingModel.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../model/funding_pie_chart.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Funding extends StatefulWidget {
  const Funding({super.key});

  @override
  State createState() => _Funding();
}

class _Funding extends State<Funding> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  // Track the selected section
  String selectedSection = "Govt. of India";

  // Separate lists for each type of scheme
  List<Fundingmodel> govtIndiaSchemes = [];
  List<Fundingmodel> stateGovtSchemes = [];
  List<Fundingmodel> otherSchemes = [];

  // Loading state
  bool isDataLoading = false;

  // Legend color mapping
  final Map<String, Color> legendColors = {
    "Govt. of India": const Color.fromRGBO(38, 166, 154, 1),
    "State Govt.": const Color.fromRGBO(41, 121, 255, 1),
    "Other": const Color.fromRGBO(255, 138, 101, 1),
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
    _animationController.forward();

    // Fetch data on initialization
    getDataFromFirebase();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> getDataFromFirebase() async {
    setState(() {
      isDataLoading = true; // Start loading
    });

    try {
      QuerySnapshot response =
          await FirebaseFirestore.instance.collection("funding_data").get();

      for (var doc in response.docs) {
        var schemes = doc["schemes"] as List<dynamic>;

        for (var scheme in schemes) {
          Fundingmodel fundingModel = Fundingmodel(
            scheme: scheme["scheme"] ?? "N/A", // Provide default value if null
            component: scheme["component"] ?? "N/A",
            expected: scheme["expected"] ?? "N/A",
            received: scheme["received"] ?? "N/A",
            expenditure: scheme["expenditure"] ?? "N/A",
            reverted: scheme["reverted"] ?? "N/A",
            remaining: scheme["remaining"] ?? "N/A",
          );

          String type = (scheme["type"] ?? "other")
              .toString()
              .trim()
              .toLowerCase(); // Handle null and trim whitespace

          // Categorize based on the type field
          if (type == "central") {
            govtIndiaSchemes.add(fundingModel);
          } else if (type == "state") {
            stateGovtSchemes.add(fundingModel);
          } else {
            otherSchemes.add(fundingModel);
          }
        }
      }

      // End loading after successful fetch
      setState(() {
        isDataLoading = false;
      });
    } catch (e) {
      log("Error fetching data: $e");

      setState(() {
        isDataLoading = false; // End loading even on error
      });
    }
  }

  List<Fundingmodel> getListForSelectedSection(String section) {
    switch (section) {
      case "Govt. of India":
        return govtIndiaSchemes;
      case "State Govt.":
        return stateGovtSchemes;
      case "Other":
        return otherSchemes;
      default:
        return [];
    }
  }

  Widget buildLegend() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: legendColors.keys.map((section) {
        return Row(
          children: [
            Container(
              width: 16,
              height: 16,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: legendColors[section],
                shape: BoxShape.circle,
              ),
            ),
            Text(
              section,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(245, 245, 245, 1),
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
              height: 100,
              width: 50,
            ),
            const SizedBox(
              width: 10,
            ),
            const Text(
              'e-Panchayat',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 25),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate to the previous screen
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              await getDataFromFirebase();
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
        children: [
          const SizedBox(height: 10),
          Center(
            child: Column(
              children: [
                const SizedBox(height: 5),
                const Text(
                  "Funding Distribution",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Legend
                    Expanded(flex: 1, child: buildLegend()),
                    // Pie Chart
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                        height: 200,
                        child: PieChart(
                          PieChartData(
                            sections:
                                FundingPieChart.buildSections(_animation.value),
                            sectionsSpace: 2,
                            centerSpaceRadius: 70,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
              onPressed: showBottomSheet,
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(38, 166, 154, 1)),
              child: Text(
                "Total Fund Report",
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
              )),
          const SizedBox(height: 40),
          const Text(
            "Scheme-wise Fund Receipt & Expenditure",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedSection = "Govt. of India";
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedSection == "Govt. of India"
                      ? const Color.fromRGBO(38, 166, 154, 1)
                      : Colors.white,
                ),
                child: Text("Govt. of India",
                    style: TextStyle(
                        color: selectedSection == "Govt. of India"
                            ? Colors.white
                            : Colors.black)),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedSection = "State Govt.";
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedSection == "State Govt."
                      ? const Color.fromRGBO(38, 166, 154, 1)
                      : Colors.white,
                ),
                child: Text("State Govt.",
                    style: TextStyle(
                        color: selectedSection == "State Govt."
                            ? Colors.white
                            : Colors.black)),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedSection = "Other";
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedSection == "Other"
                      ? const Color.fromRGBO(38, 166, 154, 1)
                      : Colors.white,
                ),
                child: Text("Other",
                    style: TextStyle(
                        color: selectedSection == "Other"
                            ? Colors.white
                            : Colors.black)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          isDataLoading
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: CircularProgressIndicator(),
                  ),
                )
              : ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: getListForSelectedSection(selectedSection).length,
                  itemBuilder: (context, index) {
                    final funding =
                        getListForSelectedSection(selectedSection)[index];
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Scheme: ${funding.scheme}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 5),
                            Text("Component: ${funding.component}"),
                            Text("Expected: ${funding.expected}"),
                            Text("Received: ${funding.received}"),
                            Text("Expenditure: ${funding.expenditure}"),
                            Text("Remaining Funds: ${funding.remaining}"),
                            Text("Reverted: ${funding.reverted}"),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }

  void showBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Panchayat Fund Summary",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(0, 137, 123, 1)),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(38, 166, 154, 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Column(
                      children: [
                        Text(
                          "Total Received Funds",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "₹8,25,020",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(38, 166, 154, 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Column(
                      children: [
                        Text(
                          "Total Used Funds",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "₹5,55,000",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(0, 150, 136, 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Column(
                  children: [
                    Text(
                      "Total Remaining Funds",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "₹2,70,020",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}
