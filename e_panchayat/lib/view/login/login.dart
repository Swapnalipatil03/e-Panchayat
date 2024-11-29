import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:e_panchayat/view/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import './registration_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserState(),
      child: const MyApp(),
    ),
  );
}

class UserState extends ChangeNotifier {
  String? _userId;

  String? get userId => _userId;

  void setUserId(String id) {
    _userId = id;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Login(),
    );
  }
}

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State createState() => _Login();
}

class _Login extends State<Login> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _buttonWidthAnimation;
  bool _isLoading = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _buttonWidthAnimation = Tween<double>(begin: 200, end: 60).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onLoginPressed() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email and Password cannot be empty.")),
      );

      return;
    }

    setState(() {
      _isLoading = true; // Show loading animation
    });

    // Start shrinking the button
    await _animationController.forward();

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      print("C2W :UserCredentials:${userCredential.user!.uid}");
      // Firebase Login Logic
      print("hiiiiiiiiiiiiiiiiiiiiiiii");

      // Navigate to the next screen
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const NavBar()),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = e.message ?? "An error occurred.";
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } finally {
      // Revert the button animation after "processing"
      await _animationController.reverse();
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: 1000,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(92, 185, 222, 1),
                Color.fromRGBO(115, 235, 170, 1),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            children: [
              ClipPath(
                clipper: UShapeClipper(),
                child: Container(
                  height: 400,
                  width: double.infinity,
                  color: Colors.black,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      AnimatedTextKit(
                        animatedTexts: [
                          TypewriterAnimatedText(
                            'e-Panchayat',
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 40,
                              color: Colors.white,
                            ),
                            speed: const Duration(milliseconds: 150),
                          ),
                        ],
                        totalRepeatCount: 1,
                        pause: const Duration(milliseconds: 1000),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 30),
                        child: Image.asset(
                          "assets/images/logo.png",
                          height: 180,
                          width: 200,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AnimatedTextKit(
                      animatedTexts: [
                        TypewriterAnimatedText(
                          'Welcome 🙏🏻', // English
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Colors.black,
                          ),
                          speed: const Duration(milliseconds: 100),
                        ),
                        TypewriterAnimatedText(
                          'नमस्कार 🙏🏻', // Marathi
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Colors.black,
                          ),
                          speed: const Duration(milliseconds: 100),
                        ),
                        TypewriterAnimatedText(
                          'नमस्ते 🙏🏻', // Hindi
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Colors.black,
                          ),
                          speed: const Duration(milliseconds: 100),
                        ),
                      ],
                      repeatForever: true,
                      pause: const Duration(milliseconds: 1000),
                    ),
                    const SizedBox(height: 50),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Enter Registered Email',
                        labelStyle: const TextStyle(color: Colors.black),
                        prefixIcon:
                            const Icon(Icons.email, color: Colors.black),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        fillColor: Colors.grey[200],
                        filled: true,
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 40),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Enter mPIN',
                        labelStyle: const TextStyle(color: Colors.black),
                        prefixIcon: const Icon(Icons.lock, color: Colors.black),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        fillColor: Colors.grey[200],
                        filled: true,
                      ),
                      maxLength: 6,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: AnimatedBuilder(
                        animation: _buttonWidthAnimation,
                        builder: (context, child) {
                          return GestureDetector(
                            onTap: _isLoading ? null : _onLoginPressed,
                            child: Container(
                              width: _buttonWidthAnimation.value,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              alignment: Alignment.center,
                              child: _isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    )
                                  : const Text(
                                      "Login",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegistrationPage()),
                        );
                      },
                      child: const Text(
                        'Citizen Registration / Sign Up',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Image.asset(
                      "assets/images/emblem.png",
                      height: 90,
                      width: 90,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    path.lineTo(0, size.height - 100);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 100,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
