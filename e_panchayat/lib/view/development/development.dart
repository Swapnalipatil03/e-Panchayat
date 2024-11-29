import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_panchayat/model/growthModel.dart';

class Development extends StatefulWidget {
  const Development({super.key});

  @override
  State<Development> createState() => _DevelopmentState();
}

class _DevelopmentState extends State<Development> {
  // Separate lists for Ongoing and Completed projects
  List<Growthmodel> ongoingProjects = [];
  List<Growthmodel> completedProjects = [];
  bool showOngoing = true; // Toggle state
  bool isLoading = true; // Flag to show loading indicator

  // Fetch data from Firebase and categorize into separate lists
  Future<void> getDataFromFirebase() async {
    setState(() {
      ongoingProjects.clear();
      completedProjects.clear();
      isLoading = true; // Set loading to true while fetching data
    });

    try {
      // Fetching the document from Firestore
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await FirebaseFirestore.instance
              .collection("development_data")
              .doc("growth_info")
              .get();

      // Access the 'data' array inside the document
      List<dynamic>? dataList = documentSnapshot.data()?['data'];

      // Check if dataList is not null and iterate through it
      if (dataList != null) {
        for (var value in dataList) {
          print("Data Entry: $value");

          // Create a Growthmodel object from the data
          Growthmodel project = Growthmodel(
            title: value['title'] ?? "No Title",
            id: value['id'] ?? "N/A",
            date: value['date'] ?? "N/A",
            scheme: value['scheme'] ?? "N/A",
            activityType: value['activityType'] ?? "N/A",
            expenditure: value['expenditure'] ?? "0",
            estimatedCost: value['estimatedCost'] ?? "0",
            startDate: value['startDate'] ?? "N/A",
            endDate: value['endDate'] ?? "N/A",
            progress: (value['progress'] is double)
                ? value['progress']
                : double.tryParse(value['progress'].toString()) ?? 0.0,
            status: value['status'] ?? "N/A",
          );

          // Categorize projects based on 'status'
          if (project.status == 'Ongoing') {
            ongoingProjects.add(project);
          } else if (project.status == 'Completed') {
            completedProjects.add(project);
          }
        }
      }

      setState(() {
        isLoading = false; // Set loading to false after data is fetched
      });
    } catch (e) {
      print("Error fetching data: $e");
      setState(() {
        isLoading = false; // Set loading to false in case of error
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getDataFromFirebase(); // Fetch data when the screen is loaded
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
              height: 100,
              width: 50,
            ),
            const SizedBox(width: 10),
            const Text(
              'e-Panchayat',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 25),
            ),
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () async {
                await getDataFromFirebase();
              },
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate to the previous screen
          },
        ),
        backgroundColor: const Color.fromRGBO(0, 137, 123, 1),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator()) // Show loading indicator
          : Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    "Development (Construction) Works",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                ),
                const Divider(),
                // Toggle buttons for Ongoing and Completed
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ToggleButtons(
                    isSelected: [showOngoing, !showOngoing],
                    onPressed: (int index) {
                      setState(() {
                        showOngoing = index == 0;
                      });
                    },
                    color: Colors.black,
                    selectedColor: Colors.white,
                    fillColor: const Color.fromRGBO(38, 166, 154, 1),
                    borderRadius: BorderRadius.circular(8),
                    children: const [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text("Ongoing", style: TextStyle(fontSize: 15)),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child:
                            Text("Completed", style: TextStyle(fontSize: 15)),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: showOngoing
                        ? ongoingProjects.length
                        : completedProjects.length,
                    itemBuilder: (context, index) {
                      Growthmodel project = showOngoing
                          ? ongoingProjects[index]
                          : completedProjects[index];
                      return Card(
                        margin: const EdgeInsets.all(10),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${project.title} ${project.id}",
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 5),
                              const Text("Onset of work"),
                              Text("Registered on : ${project.date}",
                                  style: const TextStyle(color: Colors.black)),
                              Text("Scheme : ${project.scheme}",
                                  style: const TextStyle(color: Colors.black)),
                              Text("Activity Type : ${project.activityType}",
                                  style: const TextStyle(color: Colors.black)),
                              const SizedBox(height: 5),
                              Text("Expenditure : ₹ ${project.expenditure}"),
                              Text(
                                  "Estimated Cost : ₹ ${project.estimatedCost}"),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      "${project.startDate} - ${project.endDate}"),
                                  const Icon(Icons.star_border),
                                ],
                              ),
                              const SizedBox(height: 5),
                              LinearProgressIndicator(
                                value: project.progress,
                                backgroundColor: Colors.grey[300],
                                color: Colors.green,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
