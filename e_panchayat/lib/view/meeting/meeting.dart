import 'package:flutter/material.dart';
import 'package:e_panchayat/model/meeting_data.dart';

class Meeting extends StatefulWidget {
  const Meeting({super.key});
  @override
  State createState() => _Meeting();
}

class _Meeting extends State {
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
            Text(
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

        //Icon(Icons.notifications),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Header with Filter
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Panchayat Meetings",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Icon(Icons.filter_list),
                ],
              ),
            ),
            // Grid of Meeting Cards
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemCount: meetings.length, // Adjust based on your data
                itemBuilder: (context, index) {
                  return MeetingCard(meeting: meetings[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MeetingCard extends StatelessWidget {
  final Map<String, String> meeting;
  const MeetingCard({required this.meeting});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MeetingDetailsScreen(meeting: meeting)),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 111,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                image: DecorationImage(
                  image: AssetImage("assets/images/meet.jpeg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  color: Colors.black,
                  padding: const EdgeInsets.all(4),
                  margin: const EdgeInsets.all(5),
                  child: const Text(
                    '0:27',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meeting["name"]!,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(height: 4),
                  const Row(
                    children: [
                      Icon(Icons.calendar_today, size: 12, color: Colors.black),
                      SizedBox(width: 4),
                      Text(
                        "02-11-2024 05:32 PM",
                        style: TextStyle(fontSize: 12, color: Colors.black),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  const Text(
                    "Uploaded 10 day(s) ago\n[02-11-2024 05:32 PM]",
                    style: TextStyle(fontSize: 10, color: Colors.black),
                  ),
                  const Align(
                    alignment: Alignment.centerRight,
                    child:
                        Icon(Icons.location_on, color: Colors.black, size: 20),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MeetingDetailsScreen extends StatelessWidget {
  final Map<String, String> meeting;

  const MeetingDetailsScreen({required this.meeting});
  void _showBottomSheet(BuildContext context, String title, String details) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: double.infinity,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                details,
                style: const TextStyle(
                  fontSize: 16, // Adjust this value to make the text larger
                  fontWeight:
                      FontWeight.w500, // Add weight to make it stand out
                  color: Colors.black,
                ),
                textAlign: TextAlign.left,
              ),
            ],
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
        title: const Text('Meeting Details',
            style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromRGBO(0, 137, 123, 1),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          const SizedBox(height: 8),
          const Center(
            child: Text('Meeting Details',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white)),
          ),
          const Divider(),
          Image.asset(
            "assets/images/meet.jpeg",
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 5),
          Padding(
            padding: EdgeInsets.only(left: 18.0),
            child: Text(
              meeting["name"]!,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 18.0),
            child: Text(meeting["location"]!),
          ),
          ListTile(
            leading: Icon(Icons.date_range),
            title: const Text(
              'Recorded Date',
              style: TextStyle(color: Colors.black),
            ),
            subtitle: Text(meeting["date"]!),
          ),
          ListTile(
            leading: Icon(Icons.location_on),
            title: Text(
              'Meeting Venue',
              style: TextStyle(color: Colors.black),
            ),
            subtitle: Text(meeting["venue"]!),
          ),
          const ListTile(
            leading: Icon(Icons.person),
            title: Text(
              'PPC',
              style: TextStyle(color: Colors.black),
            ),
            subtitle: Text(
              'People Plan Campaign',
              style: TextStyle(color: Colors.black),
            ),
          ),
          const Divider(),
          GestureDetector(
            onTap: () => _showBottomSheet(
              context,
              'Meeting Chairperson',
              meeting["chairperson"]!,
            ),
            child: const ListTile(
              title: Text('Meeting Chairperson'),
              trailing: Icon(Icons.visibility),
            ),
          ),
          GestureDetector(
            onTap: () => _showBottomSheet(
              context,
              'Meeting Agenda',
              meeting["agenda"]!,
            ),
            child: const ListTile(
              title: Text('Meeting Agenda'),
              trailing: Icon(Icons.visibility),
            ),
          ),
          GestureDetector(
            onTap: () =>
                _showBottomSheet(context, 'Meeting Invitee', 'Jayesh Jain"'),
            child: const ListTile(
              title: Text('Meeting Invitee'),
              trailing: Icon(Icons.visibility),
            ),
          ),
          GestureDetector(
            onTap: () =>
                _showBottomSheet(context, 'Meeting Assistant', 'Shyam Majhi'),
            child: const ListTile(
              title: Text('Meeting Assistant'),
              trailing: Icon(Icons.visibility),
            ),
          ),
          GestureDetector(
            onTap: () =>
                _showBottomSheet(context, 'Attendance', 'Jayesh Jain.'),
            child: const ListTile(
              title: Text('Attendance'),
              trailing: Icon(Icons.visibility),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
