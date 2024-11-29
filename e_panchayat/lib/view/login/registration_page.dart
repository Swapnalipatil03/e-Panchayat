import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:e_panchayat/view/login/login.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage>
    with SingleTickerProviderStateMixin {
  int currentStep = 0;
  final int totalSteps = 3;
  late AnimationController _animationController;
  late Animation<double> _buttonWidthAnimation;
  bool _isLoading = false;

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

  String? _selectedState;
  String? _selectedDistrict;
  String? _selectedTaluka;
  String? _selectedVillage;

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _onRegisterPressed() async {
    setState(() {
      _isLoading = true; // Start loading animation
    });

    // Start shrinking the button
    await _animationController.forward();

    if (_emailController.text.trim().isNotEmpty &&
        _passwordController.text.trim().isNotEmpty &&
        _passwordController.text.trim() ==
            _confirmPasswordController.text.trim()) {
      try {
        // Create user in Firebase Authentication
        UserCredential userCredential =
            await _firebaseAuth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // Store user data in Firestore
        await _firestore.collection("users").doc(userCredential.user!.uid).set({
          "full_name": _fullNameController.text.trim(),
          "phone": _phoneController.text.trim(),
          "email": _emailController.text.trim(),
          "state": _selectedState,
          "district": _selectedDistrict,
          "taluka": _selectedTaluka,
          "village": _selectedVillage,
          "pincode": _pincodeController.text.trim(),
          "created_at": FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("User Registered Successfully"),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate to the login page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Login()),
        );
      } on FirebaseAuthException catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: ${error.message}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all fields correctly."),
          backgroundColor: Colors.red,
        ),
      );
    }

    // Revert the button animation
    await _animationController.reverse();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
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
                  height: size.height * 0.35,
                  width: double.infinity,
                  color: Colors.black,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Text Animation for "e-Panchayat"
                      AnimatedTextKit(
                        animatedTexts: [
                          TypewriterAnimatedText(
                            'e-Panchayat',
                            speed: const Duration(milliseconds: 150),
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 40,
                              color: Colors.white,
                            ),
                          ),
                        ],
                        totalRepeatCount: 1,
                        displayFullTextOnTap: true,
                        stopPauseOnTap: true,
                      ),
                    ],
                  ),
                ),
              ),
              Image.asset(
                "assets/images/emblem.png",
                height: 90,
                width: 90,
              ),
              // "Register" text above steps
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: size.height * 0.02,
                ),
                child: const Text(
                  'Register',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                child: Stepper(
                  currentStep: currentStep,
                  onStepContinue: () {
                    if (currentStep < totalSteps - 1) {
                      setState(() {
                        currentStep += 1;
                      });
                    }
                  },
                  onStepCancel: () {
                    if (currentStep > 0) {
                      setState(() {
                        currentStep -= 1;
                      });
                    }
                  },
                  steps: [
                    Step(
                      title: const Text(
                        'Step 1: Personal Info',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      content: Column(
                        children: [
                          TextField(
                            controller: _fullNameController,
                            decoration: InputDecoration(
                              labelText: 'Enter Full Name',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          SizedBox(height: size.height * 0.02),
                          TextField(
                            controller: _phoneController,
                            decoration: InputDecoration(
                              labelText: 'Enter Phone Number',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            keyboardType: TextInputType.phone,
                          ),
                        ],
                      ),
                    ),
                    Step(
                      title: const Text(
                        'Step 2: Village Info',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      content: Column(
                        children: [
                          DropdownButtonFormField<String>(
                            onChanged: (newValue) {
                              setState(() {
                                _selectedState = newValue;
                              });
                            },
                            decoration: InputDecoration(
                              labelText: 'Select State',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            items: [
                              'Maharashtra',
                              'Gujarat',
                              'Karnataka',
                              'Rajasthan'
                            ]
                                .map((state) => DropdownMenuItem<String>(
                                      value: state,
                                      child: Text(state),
                                    ))
                                .toList(),
                          ),
                          SizedBox(height: size.height * 0.02),
                          DropdownButtonFormField<String>(
                            onChanged: (newValue) {
                              setState(() {
                                _selectedDistrict = newValue;
                              });
                            },
                            decoration: InputDecoration(
                              labelText: 'Select District',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            items: _getDistrictsByState(_selectedState)
                                .map((district) => DropdownMenuItem<String>(
                                      value: district,
                                      child: Text(district),
                                    ))
                                .toList(),
                          ),
                          SizedBox(height: size.height * 0.02),
                          DropdownButtonFormField<String>(
                            onChanged: (newValue) {
                              setState(() {
                                _selectedTaluka = newValue;
                              });
                            },
                            decoration: InputDecoration(
                              labelText: 'Select Taluka',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            items: _getTalukasByDistrict(_selectedDistrict)
                                .map((taluka) => DropdownMenuItem<String>(
                                      value: taluka,
                                      child: Text(taluka),
                                    ))
                                .toList(),
                          ),
                          SizedBox(height: size.height * 0.02),
                          DropdownButtonFormField<String>(
                            onChanged: (newValue) {
                              setState(() {
                                _selectedVillage = newValue;
                              });
                            },
                            decoration: InputDecoration(
                              labelText: 'Select Village',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            items: _getVillagesByTaluka(_selectedTaluka)
                                .map((village) => DropdownMenuItem<String>(
                                      value: village,
                                      child: Text(village),
                                    ))
                                .toList(),
                          ),
                          SizedBox(height: size.height * 0.02),
                          TextField(
                            controller: _pincodeController,
                            decoration: InputDecoration(
                              labelText: 'Enter PinCode',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            keyboardType: TextInputType.phone,
                          ),
                        ],
                      ),
                    ),
                    Step(
                      title: const Text(
                        'Step 3: Account Info',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      content: Column(
                        children: [
                          TextField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'Enter Email Address',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                          ),
                          SizedBox(height: size.height * 0.02),
                          TextField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              labelText: 'Enter Password',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            obscureText: true,
                          ),
                          SizedBox(height: size.height * 0.02),
                          TextField(
                            controller: _confirmPasswordController,
                            decoration: InputDecoration(
                              labelText: 'Confirm Password',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            obscureText: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: AnimatedBuilder(
                  animation: _buttonWidthAnimation,
                  builder: (context, child) {
                    return ElevatedButton(
                      onPressed: _onRegisterPressed,
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(_buttonWidthAnimation.value, 50),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              'Register',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<String> _getDistrictsByState(String? state) {
    if (state == 'Maharashtra') {
      return ['Pune', 'Mumbai', 'Chhatrapati Sambhajinagar'];
    }
    if (state == 'Gujarat') {
      return ['Ahmedabad', 'Surat', 'Vadodara'];
    }
    if (state == 'Karnataka') {
      return ['Bengaluru', 'Mysuru', 'Hubli'];
    }
    return [];
  }

  List<String> _getTalukasByDistrict(String? district) {
    if (district == 'Pune') {
      return ['Pune City', 'Haveli', 'Maval'];
    }
    if (district == 'Mumbai') {
      return ['Mumbai City', 'Andheri', 'Bandra'];
    }
    if (district == 'Chhatrapati Sambhajinagar') {
      return ['Sillod', 'Jalna', 'Paithan'];
    }
    return [];
  }

  List<String> _getVillagesByTaluka(String? taluka) {
    if (taluka == 'Pune City') {
      return ['Haveli', 'Mulshi', 'Bhor'];
    }
    if (taluka == 'Dadar') {
      return ['Village 4', 'Village 5', 'Village 6'];
    }
    if (taluka == 'Sillod') {
      return ['Kaigaon', 'Alland', 'Naygaon'];
    }
    return [];
  }
}

class UShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, 0);
    path.quadraticBezierTo(size.width * 0.25, size.height * 0.5, size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
