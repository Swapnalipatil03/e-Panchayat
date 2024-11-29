import 'package:flutter/material.dart';

// void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Panchayat Selector',
      theme: ThemeData(
        primaryColor: const Color.fromRGBO(0, 137, 123, 1),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(38, 166, 154, 1),
          ),
        ),
      ),
      home: PanchayatSelector(),
    );
  }
}

class PanchayatSelector extends StatefulWidget {
  @override
  _PanchayatSelectorState createState() => _PanchayatSelectorState();
}

class _PanchayatSelectorState extends State<PanchayatSelector> {
  final Map<String, List<String>> statesAndDistricts = {
    'Maharashtra': ['Pune', 'Mumbai', 'Nagpur'],
    'Karnataka': ['Bangalore', 'Mysore', 'Hubli'],
  };

  final Map<String, List<String>> districtsAndTalukas = {
    'Pune': ['Haveli', 'Mulshi', 'Baramati'],
    'Mumbai': ['Andheri', 'Borivali', 'Colaba'],
  };

  final Map<String, List<String>> talukasAndVillages = {
    'Haveli': ['Wagholi', 'Kharadi', 'Shivapur'],
    'Mulshi': ['Pirangut', 'Paud', 'Tamhini'],
  };

  String? selectedState;
  String? selectedDistrict;
  String? selectedTaluka;
  String? selectedVillage;

  List<String> get districts =>
      selectedState != null ? statesAndDistricts[selectedState]! : [];

  List<String> get talukas =>
      selectedDistrict != null ? districtsAndTalukas[selectedDistrict]! : [];

  List<String> get villages =>
      selectedTaluka != null ? talukasAndVillages[selectedTaluka]! : [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Panchayat'),
        backgroundColor: const Color.fromRGBO(0, 137, 123, 1),
      ),
      body: Container(
        color: const Color.fromRGBO(229, 230, 248, 1),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Select State'),
              value: selectedState,
              items: statesAndDistricts.keys
                  .map((state) => DropdownMenuItem(
                        value: state,
                        child: Text(state),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedState = value;
                  selectedDistrict = null;
                  selectedTaluka = null;
                  selectedVillage = null;
                });
              },
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Select District'),
              value: selectedDistrict,
              items: districts
                  .map((district) => DropdownMenuItem(
                        value: district,
                        child: Text(district),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedDistrict = value;
                  selectedTaluka = null;
                  selectedVillage = null;
                });
              },
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Select Taluka'),
              value: selectedTaluka,
              items: talukas
                  .map((taluka) => DropdownMenuItem(
                        value: taluka,
                        child: Text(taluka),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedTaluka = value;
                  selectedVillage = null;
                });
              },
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Select Village'),
              value: selectedVillage,
              items: villages
                  .map((village) => DropdownMenuItem(
                        value: village,
                        child: Text(village),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedVillage = value;
                });
              },
            ),
            Spacer(),
            ElevatedButton(
              onPressed: selectedVillage != null
                  ? () {
                      // Handle the "Set Panchayat" action
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Panchayat set to: $selectedVillage, $selectedTaluka, $selectedDistrict, $selectedState'),
                        ),
                      );
                    }
                  : null,
              child: Text('Set Panchayat'),
            ),
          ],
        ),
      ),
    );
  }
}
