import 'package:e_panchayat/view/features/FeaturesScreen.dart';
import 'package:e_panchayat/view/login/login.dart';
import 'package:flutter/material.dart';
import 'dart:async';

// void main() {
//   runApp(MyApp());
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  // Predefined positions for each image based on the uploaded image reference
  final List<Offset> predefinedPositions = [
    const Offset(-80, -150), // Position for image 1
    const Offset(80, -150), // Position for image 2
    const Offset(150, -50), // Position for image 3
    const Offset(-150, -50), // Position for image 4
    const Offset(-80, 100), // Position for image 5
    const Offset(80, 100), // Position for image 6
    const Offset(-50, 200), // Position for image 7
    const Offset(50, 200), // Position for image 8
    const Offset(0, 0), // Position for image 9
  ];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.forward();

    // Navigate to the home screen after the animation ends
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(245, 245, 245, 1),
        body: Container(
          width: 900,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              //colors: [Color(0xFF003366), Color(0xFF009688)],
              // colors: [
              //   Color.fromRGBO(229, 230, 248, 1),
              //   Color.fromRGBO(128, 122, 194, 1)
              // ],
              colors: [
                Color.fromRGBO(0, 137, 123, 1), // Primary teal
                Color.fromRGBO(0, 150, 136, 1), // Slightly brighter teal
                Color.fromRGBO(38, 198, 218, 1), // Light turquoise for contrast
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Central image that becomes visible after other images move to the center
                FadeTransition(
                  opacity: Tween<double>(begin: 0, end: 1).animate(
                    CurvedAnimation(
                        parent: _controller, curve: const Interval(0.6, 1.0)),
                  ),
                  child: Image.asset(
                    'assets/images/selfie.png', // Central image path
                    width: 150,
                    height: 150,
                  ),
                ),
                // Animated images moving outwards and returning towards the center
                for (int i = 0; i < 9; i++)
                  AnimatedImage(
                    imagePath:
                        'assets/images/image_$i.png', // Replace with actual image paths
                    animation: _animation,
                    targetOffset: predefinedPositions[i],
                  ),
              ],
            ),
          ),
        ));
  }
}

class AnimatedImage extends StatelessWidget {
  final String imagePath;
  final Animation<double> animation;
  final Offset targetOffset;

  const AnimatedImage(
      {super.key,
      required this.imagePath,
      required this.animation,
      required this.targetOffset});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        // Define outward movement first, then return to center
        final outwardMovement = Tween<Offset>(
          begin: const Offset(0, 0),
          end: targetOffset,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
        ));

        final returnMovement = Tween<Offset>(
          begin: targetOffset,
          end: const Offset(0, 0),
        ).animate(CurvedAnimation(
          parent: animation,
          curve: const Interval(0.4, 0.8, curve: Curves.easeIn),
        ));

        final currentOffset = animation.value < 0.4
            ? outwardMovement.value
            : returnMovement.value;

        return Transform.translate(
          offset: currentOffset,
          child: Opacity(
            opacity: animation.value < 0.8 ? 1.0 : 0.0,
            child: Image.asset(
              imagePath,
              width: 50,
              height: 50,
            ),
          ),
        );
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    // Timer to navigate to LoginScreen after 5 seconds
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const IntroScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(245, 245, 245, 1),
      body: Container(
        width: 900,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            //colors: [Color(0xFF003366), Color(0xFF009688)],
            // colors: [
            //   Color.fromRGBO(229, 230, 248, 1),
            //   Color.fromRGBO(128, 122, 194, 1)
            // ],
            colors: [
              Color.fromRGBO(0, 137, 123, 1), // Primary teal
              Color.fromRGBO(0, 150, 136, 1), // Slightly brighter teal
              Color.fromRGBO(38, 198, 218, 1), // Light turquoise for contrast
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/logo.png",
                height: 150,
                width: 150,
              ),
              const SizedBox(
                height: 40,
              ),
              const Text(
                "e-Panchayat",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 50,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
