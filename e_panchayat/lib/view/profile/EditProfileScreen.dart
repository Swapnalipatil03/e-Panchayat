import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditProfileScreen extends StatefulWidget {
  final Map<String, dynamic> userData;
  final String userId;

  const EditProfileScreen(
      {Key? key, required this.userData, required this.userId})
      : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController countryController;
  late TextEditingController stateController;
  late TextEditingController cityController;
  late TextEditingController villageController;
  late TextEditingController pinCodeController;
  String? profileImagePath;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.userData['full_name']);
    emailController = TextEditingController(text: widget.userData['email']);
    phoneController = TextEditingController(text: widget.userData['phone']);
    countryController = TextEditingController(text: "India");
    stateController = TextEditingController(text: widget.userData['state']);
    cityController = TextEditingController(text: widget.userData['district']);
    villageController = TextEditingController(text: widget.userData['village']);
    pinCodeController = TextEditingController(text: widget.userData['pincode']);
    profileImagePath = widget.userData['profileImagePath'];
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        profileImagePath = pickedFile.path;
      });
    }
  }

  Future<String?> _uploadImage(File imageFile) async {
    try {
      // Generate a unique file name
      final fileName =
          '${widget.userId}_${DateTime.now().millisecondsSinceEpoch}.jpg';

      // Upload to Firebase Storage
      final ref =
          FirebaseStorage.instance.ref().child('profile_images/$fileName');
      final uploadTask = await ref.putFile(imageFile);

      // Get the download URL
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }

  // Future<void> _saveProfile() async {
  //   try {
  //     final updatedUserData = {
  //       'full_name': nameController.text,
  //       'email': emailController.text,
  //       'phone': phoneController.text,
  //       'country': countryController.text,
  //       'state': stateController.text,
  //       'district': cityController.text,
  //       'village': villageController.text,
  //       'pincode': pinCodeController.text,
  //       'profileImagePath': profileImagePath,
  //     };

  //     await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(widget.userId)
  //         .update(updatedUserData);

  //     Navigator.pop(context, updatedUserData); // Return updated data
  //   } catch (e) {
  //     print("Error updating profile: $e");
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Error updating profile')),
  //     );
  //   }
  // }

  Future<void> _saveProfile() async {
    try {
      String? uploadedImageUrl;
      if (profileImagePath != null && !profileImagePath!.startsWith('http')) {
        // Upload new image if selected
        uploadedImageUrl = await _uploadImage(File(profileImagePath!));
      }

      final updatedUserData = {
        'full_name': nameController.text,
        'email': emailController.text,
        'phone': phoneController.text,
        'country': countryController.text,
        'state': stateController.text,
        'district': cityController.text,
        'village': villageController.text,
        'pincode': pinCodeController.text,
        'profileImagePath': uploadedImageUrl ?? profileImagePath,
      };

      // Update Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .update(updatedUserData);

      Navigator.pop(context, updatedUserData); // Return updated data
    } catch (e) {
      print("Error updating profile: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile')),
      );
    }
  }

// Future<void> _pickImage() async {
//   final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
//   if (pickedFile != null) {
//     setState(() {
//       profileImagePath = pickedFile.path;
//     });
//   }
// }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
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
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: profileImagePath != null
                          ? FileImage(File(profileImagePath!))
                          : const AssetImage(
                                  'assets/images/default_profile.png')
                              as ImageProvider,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt),
                        onPressed: _pickImage,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildTextField("Full Name", nameController),
              _buildTextField("Email", emailController),
              _buildTextField("Phone", phoneController),
              _buildTextField("Country", countryController),
              _buildTextField("State", stateController),
              _buildTextField("District", cityController),
              _buildTextField("Village", villageController),
              _buildTextField("Pincode", pinCodeController),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(0, 137, 123, 1),
                ),
                child: const Text(
                  "   Save   ",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: label,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
