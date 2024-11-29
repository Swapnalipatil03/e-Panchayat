import 'package:e_panchayat/view/complaint/complaint.dart';
import 'package:e_panchayat/view/development/development.dart';
import 'package:e_panchayat/view/digital_services/DigitalServices.dart';
import 'package:e_panchayat/view/funding/funding.dart';
import 'package:e_panchayat/view/market/Market.dart';
import 'package:e_panchayat/view/meeting/meeting.dart';
import 'package:e_panchayat/view/population/population.dart';
import 'package:e_panchayat/view/schemes/schemes.dart';
import 'package:e_panchayat/view/home/carousel.dart';
import 'package:flutter/material.dart';
import 'package:e_panchayat/view/login/searchVillage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// void main() {
//   runApp(const MainApp());
// }

// class MainApp extends StatelessWidget {
//   const MainApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       home: Home(),
//     );
//   }
// }

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State createState() => _Home();
}

class _Home extends State {
  String _weatherInfo = 'Loading...';
  @override
  void initState() {
    super.initState();
    _fetchWeather(); // Fetch weather data on app load
  }

  // Function to fetch weather data
  Future<void> _fetchWeather() async {
    const String apiKey =
        '11cd191827fb92a4e6df545d12ddcfcc'; // Replace with your OpenWeatherMap API key
    const String villageName = 'Karad'; // Example village
    const String apiUrl =
        'https://api.openweathermap.org/data/2.5/weather?q=Karad&units=metric&appid=11cd191827fb92a4e6df545d12ddcfcc';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final temperature = data['main']['temp'];
        final description = data['weather'][0]['description'];
        setState(() {
          _weatherInfo = '${temperature.toStringAsFixed(1)}°C, $description';
        });
      } else {
        print('Error response: ${response.body}');
        setState(() {
          _weatherInfo = 'Error fetching weather';
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        _weatherInfo = 'Unable to fetch weather';
      });
    }
  }

  // Navigation Logic
  int _selectedIndex = 0;

  // Add the screens here
  final List<Widget> _screens = [
    const Population(), // Replace with your Profile screen widget
    const Development(), // Replace with your Nearby Services screen widget
    MarketRatesApp(), // Replace with your Home screen widget
    const Funding(), // Market screen
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    //debugShowCheckedModeBanner:false;
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              "assets/images/logo.png",
              height: 100,
              width: 50,
            ),
            Text(
              'e-Panchayat',
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 22,
                color:
                    Colors.black, // Set text color to white for better contrast
              ),
            ),
          ],
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Icon(Icons.cloud, color: Colors.white), // Cloud icon
              const SizedBox(width: 6),
              Text(
                _weatherInfo,
                style: const TextStyle(
                  color: Colors
                      .black, // Set text color to white for better contrast
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  _buildServiceItem(
                    'funding',
                    'Funding',
                    'assets/images/money-bag.png',
                  ),

                  _buildServiceItem(
                      'meetings', 'Meetings', 'assets/images/meeting.png'),
                  _buildServiceItem(
                      'schemes', 'Schemes', 'assets/images/scheme.png'),
                  _buildServiceItem('certificates', 'Certificates',
                      'assets/images/rights.png'),
                  _buildServiceItem(
                      'Population', 'Population', 'assets/images/crowd.png'),
                  _buildServiceItem(
                      'Growth', 'Growth', 'assets/images/growth.png'),
                  _buildServiceItem('complaints', 'Complaints',
                      'assets/images/improvement.png'),

                  // _buildServiceItem('area', 'Area', 'assets/images/map.png'),
                ],
              ),
            ),

            // Add Carousel here
            CustomCarousel(
              items: [
                CarouselData(
                  title: 'New Government Schemes',
                  description:
                      'Updates about new government schemes for rural development.',
                  image: 'assets/images/scheme.png',
                ),
                CarouselData(
                  title: 'Panchayat Latest News',
                  description: 'Daily updates on ongoing developments.',
                  image: 'assets/images/press-release.png',
                ),
                CarouselData(
                  title: 'New Road Project',
                  description:
                      'Updates about new government schemes for rural development.',
                  image: 'assets/images/crowd.png',
                ),
                CarouselData(
                  title: 'Water Management Techniques',
                  description:
                      'Water Management techniques for rural development.',
                  image: 'assets/images/scheme.png',
                ),
                CarouselData(
                  title: 'Water Management Techniques',
                  description:
                      'Water Management techniques for rural development.',
                  image: 'assets/images/scheme.png',
                ),
              ],
              height: 160,
              backgroundColor: Colors.white,
              autoPlayInterval: const Duration(seconds: 3),
              showIndicator: true,
              onPageChanged: (index) {
                // Handle page change if needed
              },
              onTap: () {
                // Handle tap if needed
              },
            ),

            // Village Information Container
            // Village Name Container
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              width: 500,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text.rich(
                    TextSpan(
                      text: 'Village Name : ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(
                          text: 'Kaigaon ',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: '\nTaluka : ',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: 'Sillod ',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: '\nDistrict : ',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: 'Maharashtra',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // // Add Change Village Button
                  // Align(
                  //   alignment: Alignment.centerRight,
                  //   child: ElevatedButton(
                  //     onPressed: () {
                  //       Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (context) => PanchayatSelector()),
                  //       );
                  //     },
                  //     style: ElevatedButton.styleFrom(
                  //       backgroundColor: Color.fromRGBO(38, 166, 154, 1),
                  //       foregroundColor: Colors.white,
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(25),
                  //       ),
                  //       padding: const EdgeInsets.symmetric(
                  //           horizontal: 16, vertical: 6),
                  //     ),
                  //     child: const Text('Change Village',
                  //         style: TextStyle(fontSize: 14)),
                  //   ),
                  // ),
                ],
              ),
            ),

            // Current Sarpanch Container
            // Current Sarpanch Information Container
            // Current Sarpanch Container
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Current Sarpanch',
                        style: TextStyle(
                          // color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            'Anuradha Wagh',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '2020 - 2025',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '9845762451',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Current GramSevak',
                        style: TextStyle(
                          // color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Ganesh Vanarase',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '2017 ',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '8752314597',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 30),
                  // SizedBox(
                  //   width: double.infinity,
                  //   child: ElevatedButton(
                  //     onPressed: () {},
                  //     style: ElevatedButton.styleFrom(
                  //       backgroundColor: Color.fromRGBO(38, 166, 154, 1),
                  //       foregroundColor: Colors.white,
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(25),
                  //       ),
                  //     ),
                  //     child: const Text('All Members'),
                  //   ),
                  // ),
                  const SizedBox(height: 8),
                  // Row(
                  //   children: [
                  //     const Icon(Icons.campaign, size: 16, color: Colors.grey),
                  //     const SizedBox(width: 4),
                  //     Text(
                  //       'lorem epsum',
                  //       style: TextStyle(
                  //         fontSize: 12,
                  //         color: Colors.grey[600],
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   type: BottomNavigationBarType.fixed,
      //   selectedItemColor: const Color.fromRGBO(112, 106, 181, 1),
      //   unselectedItemColor: Colors.grey,
      //   currentIndex: _selectedIndex,
      //   onTap: _onItemTapped,
      //   items: const [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.account_circle_rounded),
      //       label: 'Profile',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.amp_stories_rounded),
      //       label: 'Nearby Services',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: 'Home',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(
      //         Icons.show_chart,
      //       ),
      //       label: 'Market',
      //     ),
      //     // BottomNavigationBarItem(
      //     //   icon: Icon(Icons.control_point_duplicate_sharp),
      //     //   label: 'ChatBot',
      //     // ),
      //   ],
      // ),
    );
  }

  Widget _buildServiceItem(String title, String label, String iconPath) {
    return GestureDetector(
      // Wrap with GestureDetector
      onTap: () {
        if (title == 'schemes') {
          // Check if schemes is tapped
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SchemesPage()),
          );
        }
        if (title == 'funding') {
          // Check if schemes is tapped
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Funding()),
          );
        }
        if (title == 'Population') {
          // Check if schemes is tapped
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Population()),
          );
        }
        if (title == 'certificates') {
          // Check if schemes is tapped
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CertificatesPage()),
          );
        }
        if (title == 'Growth') {
          // Check if schemes is tapped
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Development()),
          );
        }
        if (title == 'meetings') {
          // Check if schemes is tapped
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Meeting()),
          );
        }
        if (title == 'complaints') {
          // Check if schemes is tapped
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ComplaintScreen()),
          );
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              color: const Color(0x000000),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image.asset(
              iconPath,
              width: 70,
              height: 70,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildVillageInfo() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Village Name: Karad', style: TextStyle(fontSize: 16)),
          ElevatedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => PanchayatSelector()));
            },
            child: const Text('Change Village'),
          ),
        ],
      ),
    );
  }

  Widget _buildSarpanchInfo() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Current Sarpanch: Suresh Shinde',
              style: TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          const Text('GramSevak: Sambhaji Bhosale',
              style: TextStyle(fontSize: 16)),
          ElevatedButton(onPressed: () {}, child: const Text('All Members')),
        ],
      ),
    );
  }
}
