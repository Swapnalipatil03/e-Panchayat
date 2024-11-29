import 'package:flutter/material.dart';

class CertificatesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Certificates Page',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: CertificatesPage(),
    );
  }
}

class CertificatesPage extends StatelessWidget {
  final List<String> certificates = [
    'Birth Certificate',
    'Death Certificate',
    'Marriage Certificate',
  ];

  void _showRequestBottomSheet(BuildContext context, String certificate) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController detailsController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Ensures BottomSheet resizes with keyboard
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 400,
              left: 16,
              right: 16,
              top: 10,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Request $certificate',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Your Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: detailsController,
                  decoration: const InputDecoration(
                    labelText: 'Additional Details',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(0, 137, 123, 1),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context); // Close the bottom sheet
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Request Submitted'),
                          content: Text(
                              'You have successfully requested the $certificate.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Center(
                    child: Text(
                      'Submit',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
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
        title: const Text(
          'Digital Services',
          style: TextStyle(color: Colors.white), // White AppBar text color
        ),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(0, 137, 123, 1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), // White icon
          onPressed: () {
            Navigator.pop(context); // Navigate back to the homepage
          },
        ),
      ),
      backgroundColor: const Color.fromRGBO(
          229, 230, 248, 1), // Set scaffold background color
      body: ListView.builder(
        itemCount: certificates.length,
        itemBuilder: (context, index) {
          return Container(
            height: MediaQuery.of(context).size.height / 4, // Adjusted height
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Card(
              elevation: 4,
              color: const Color(0xFFF8F8F8), // Off-white card color
              child: Center(
                // Center the text inside the container
                child: ListTile(
                  leading: const Icon(
                    Icons.document_scanner,
                    color: Color.fromRGBO(0, 137, 123, 1),
                    size: 48, // Larger icon size
                  ),
                  title: Text(
                    certificates[index],
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center, // Center text horizontally
                  ),
                  trailing: const Icon(Icons.arrow_forward,
                      color: Colors.grey, size: 32),
                  onTap: () {
                    _showRequestBottomSheet(context, certificates[index]);
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
