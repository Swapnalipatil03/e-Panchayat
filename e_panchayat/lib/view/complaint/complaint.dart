import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: ComplaintScreen(),
//     );
//   }
// }

class ComplaintScreen extends StatefulWidget {
  const ComplaintScreen({super.key});

  @override
  ComplaintScreenState createState() => ComplaintScreenState();
}

class ComplaintScreenState extends State<ComplaintScreen>
    with TickerProviderStateMixin {
  String? selectedComplaintType;
  TextEditingController complaintController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  final List<Map<String, dynamic>> complaintTypes = [
    {'label': 'Dead Animal', 'icon': Icons.pets},
    {'label': 'Construction Work Quality', 'icon': Icons.construction},
    {'label': 'Cleanliness', 'icon': Icons.cleaning_services},
    {'label': 'Street light', 'icon': Icons.lightbulb},
    {'label': 'Water Supply', 'icon': Icons.water_drop},
    {'label': 'Public Toilet Cleanliness', 'icon': Icons.wc},
  ];

  File? _image;
  bool isAllComplaints = false;

  // Two lists for storing "My Complaints" and "All Complaints"
  List<Map<String, String>> myComplaints = [
    {
      'type': 'Dead Animal',
      'description': 'Dead dog near the park.',
      'address': 'Park Avenue, Block C',
    },
  ];
  List<Map<String, String>> allComplaints = [
    {
      'type': 'Dead Animal',
      'description': 'Dead dog near the park.',
      'address': 'Park Avenue, Block C',
    },
    {
      'type': 'Street light',
      'description': 'Streetlight not working for 2 days.',
      'address': 'Main Road, Sector 4',
    },
    {
      'type': 'Cleanliness',
      'description': 'Garbage not collected in the street.',
      'address': 'Rose Garden Colony',
    },
  ];

  Future<void> _pickImageFromCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _showComplaintTypeBottomSheet({bool showTextArea = false}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height:
              MediaQuery.of(context).size.height * (showTextArea ? 0.8 : 0.5),
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'File Complaint',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                if (showTextArea && selectedComplaintType != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Complaint Type: $selectedComplaintType',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: complaintController,
                        decoration: const InputDecoration(
                          labelText: 'Write your complaint here',
                          border: OutlineInputBorder(),
                          hintText: 'Enter your complaint...',
                        ),
                        maxLines: 5,
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: addressController,
                        decoration: const InputDecoration(
                          labelText: 'Enter your address',
                          border: OutlineInputBorder(),
                          hintText: 'Enter your address...',
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.camera_alt,
                                color: Colors.black),
                            onPressed: _pickImageFromCamera,
                          ),
                          IconButton(
                            icon: const Icon(Icons.photo_library,
                                color: Colors.black),
                            onPressed: _pickImageFromGallery,
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      if (_image != null)
                        Container(
                          height: 150,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: FileImage(_image!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      const SizedBox(height: 16),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              var complaint = {
                                'type': selectedComplaintType!,
                                'description': complaintController.text,
                                'address': addressController.text,
                              };
                              myComplaints.add(complaint);
                              allComplaints.add(complaint); // Adding to "All"
                              complaintController.clear();
                              addressController.clear();
                              _image = null;
                            });
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 14, horizontal: 30),
                            backgroundColor:
                                const Color.fromRGBO(38, 166, 154, 1),
                            textStyle: const TextStyle(
                                fontSize: 16, color: Colors.black),
                          ),
                          child: const Text(
                            'Submit',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Please select a complaint type',
                          style: TextStyle(fontSize: 16)),
                      const SizedBox(height: 16),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: complaintTypes.length,
                        itemBuilder: (BuildContext context, int index) {
                          var complaint = complaintTypes[index];
                          return ListTile(
                            leading:
                                Icon(complaint['icon'], color: Colors.black54),
                            title: Text(complaint['label']),
                            onTap: () {
                              setState(() {
                                selectedComplaintType = complaint['label'];
                              });
                              Navigator.pop(context);
                              _showComplaintTypeBottomSheet(showTextArea: true);
                            },
                          );
                        },
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate to the previous screen
          },
        ),
        title: const Text('Complaint App'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16), // Space between AppBar and ToggleButtons
          ToggleButtons(
            isSelected: [!isAllComplaints, isAllComplaints],
            onPressed: (index) {
              setState(() {
                isAllComplaints = index == 1;
              });
            },
            borderRadius: BorderRadius.circular(8),
            selectedColor: Colors.white,
            fillColor: const Color.fromRGBO(38, 166, 154, 1),
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: Text('My Complaints'),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: Text('All Complaints'),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: ListView.builder(
              itemCount:
                  isAllComplaints ? allComplaints.length : myComplaints.length,
              itemBuilder: (context, index) {
                var complaint = isAllComplaints
                    ? allComplaints[index]
                    : myComplaints[index];
                return Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Complaint Type: ${complaint['type']}',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Description: ${complaint['description']}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Address: ${complaint['address']}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showComplaintTypeBottomSheet();
        },
        backgroundColor: const Color.fromRGBO(38, 166, 154, 1),
        child: const Icon(Icons.add),
      ),
    );
  }
}
