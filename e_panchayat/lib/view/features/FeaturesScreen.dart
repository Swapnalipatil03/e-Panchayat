import 'package:e_panchayat/view/login/login.dart';
import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: IntroScreen(),
//     );
//   }
// }

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int currentIndex = 0;

  late AnimationController _animationController;
  late Animation<double> _animation;

  final List<Map<String, String>> features = [
    {
      'title': 'Government Schemes Funds',
      'image': 'assets/images/money-bag.png',
      'description':
          'Provides detailed information on various government-funded initiatives, including fund allocation and utilization.'
    },
    {
      'title': 'Panchayat Details',
      'image': 'assets/images/office-building.png',
      'description':
          'Key details about the Sarpanch, Gramsevak, and village, along with Panchayat responsibilities and initiatives.'
    },
    {
      'title': 'Weather Info',
      'image': 'assets/images/cloudy.gif',
      'description': 'Connects users with available weather info ...'
    },
    {
      'title': 'All Schemes',
      'image': 'assets/images/scheme.png',
      'description':
          'List of ongoing and past government schemes, including eligibility, application, and benefits.'
    },
    {
      'title': 'Certificates, Documents',
      'image': 'assets/images/approved.png',
      'description':
          'Request essential documents like birth and death certificates from the Panchayat.'
    },
    {
      'title': 'Meetings',
      'image': 'assets/images/board-meeting.png',
      'description':
          'Details about upcoming and past Gramsabha meetings, including agenda, date, and location.'
    },
    {
      'title': 'Complaints',
      'image': 'assets/images/talk.png',
      'description':
          'Submit and track complaints regarding local infrastructure, services, and grievances.'
    },
    {
      'title': 'Area & Population',
      'image': 'assets/images/population.png',
      'description':
          'Statistics about the area, population density, and demographic distribution of the village or Panchayat.'
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
    _animation =
        Tween<double>(begin: 0.9, end: 1.1).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void nextPage() {
    if (currentIndex < features.length ~/ 2 - 1) {
      _pageController.nextPage(
          duration: const Duration(milliseconds: 600), curve: Curves.easeInOut);
    } else {
      // Navigate to the main part of the application (Get Started logic)
    }
  }

  void skip() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const Login()),
      (route) => false, // Remove all previous routes
    );
    // Directly navigate to the main part of the app or final screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient background
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green, Colors.blue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            itemCount: (features.length ~/ 2),
            itemBuilder: (context, index) {
              return IntroFeaturePage(
                feature1: features[index * 2],
                feature2: features[index * 2 + 1],
                animation: _animation,
              );
            },
          ),
          Positioned(
            bottom: 60,
            left: 20,
            child: TextButton(
              onPressed: skip,
              child: const Text(
                "Skip",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold, // Make text bold
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 60,
            right: 20,
            child: TextButton(
              onPressed: () {
                if (currentIndex == (features.length ~/ 2 - 1)) {
                  // Navigate to the registration screen or main part of the app
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const Login()),
                    (route) => false, // Remove all previous routes
                  );
                } else {
                  nextPage(); // Go to the next feature/page
                }
              },
              child: Text(
                currentIndex == (features.length ~/ 2 - 1)
                    ? "Get Started..!!"
                    : "Next", // Change text based on the current index
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold, // Make text bold
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class IntroFeaturePage extends StatelessWidget {
  final Map<String, String> feature1;
  final Map<String, String> feature2;
  final Animation<double> animation;

  const IntroFeaturePage({
    super.key,
    required this.feature1,
    required this.feature2,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FeatureItemLeftRight(feature: feature1, animation: animation),
          const SizedBox(height: 150), // Increased middle space
          FeatureItemRightLeft(feature: feature2, animation: animation),
        ],
      ),
    );
  }
}

class FeatureItemLeftRight extends StatelessWidget {
  final Map<String, String> feature;
  final Animation<double> animation;

  const FeatureItemLeftRight(
      {super.key, required this.feature, required this.animation});

  void _showFeatureDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(feature['title'] ?? ''),
          content: Text(feature['description'] ?? 'No description available.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showFeatureDetails(context), // Show dialog on tap
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ScaleTransition(
            scale: animation,
            child: Image.asset(
              feature['image'] ?? '',
              width: 100, // Reduced width of the image
              height: 100, // Reduced height of the image
            ),
          ),
          const SizedBox(width: 35), // Increased space between image and text
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                feature['title'] ?? '',
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold), // Smaller text size
              ),
              const SizedBox(height: 5),
              SizedBox(
                width: 160, // Reduced width for text
                child: Text(
                  feature['description'] ?? '',
                  style: const TextStyle(
                      fontSize: 14), // Smaller font size for the description
                  overflow: TextOverflow.ellipsis, // Ellipsis to avoid overflow
                  maxLines: 2, // Limit to two lines
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class FeatureItemRightLeft extends StatelessWidget {
  final Map<String, String> feature;
  final Animation<double> animation;

  const FeatureItemRightLeft(
      {super.key, required this.feature, required this.animation});

  void _showFeatureDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(feature['title'] ?? ''),
          content: Text(feature['description'] ?? 'No description available.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showFeatureDetails(context), // Show dialog on tap
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                feature['title'] ?? '',
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold), // Smaller text size
              ),
              const SizedBox(height: 5),
              SizedBox(
                width: 160, // Reduced width for text
                child: Text(
                  feature['description'] ?? '',
                  style: const TextStyle(
                      fontSize: 14), // Smaller font size for the description
                  overflow: TextOverflow.ellipsis, // Ellipsis to avoid overflow
                  maxLines: 2, // Limit to two lines
                ),
              ),
            ],
          ),
          const SizedBox(width: 25), // Increased space between text and image
          ScaleTransition(
            scale: animation,
            child: Image.asset(
              feature['image'] ?? '',
              width: 100, // Reduced width of the image
              height: 100, // Reduced height of the image
            ),
          ),
        ],
      ),
    );
  }
}
