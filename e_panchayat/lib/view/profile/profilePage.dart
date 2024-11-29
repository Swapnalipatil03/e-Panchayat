import 'package:e_panchayat/view/profile/EditProfileScreen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;

  const ProfileScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .get();

      if (userDoc.exists) {
        setState(() {
          userData = userDoc.data() as Map<String, dynamic>;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User not found')),
        );
      }
    } catch (e) {
      print("Error fetching user data: $e");
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching data')),
      );
    }
  }

  void _navigateToEditProfile() async {
    final updatedUserData = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(
          userData: userData!,
          userId: widget.userId,
        ),
      ),
    );

    if (updatedUserData != null) {
      setState(() {
        userData = updatedUserData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      backgroundColor: const Color.fromRGBO(229, 230, 248, 1),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : userData == null
              ? const Center(child: Text("User data not found"))
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: mediaQuery.size.height * 0.2,
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
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: CircleAvatar(
                                radius: 60,
                                backgroundImage: userData![
                                                'profileImagePath'] !=
                                            null &&
                                        userData!['profileImagePath']
                                            .startsWith('http')
                                    ? NetworkImage(
                                        userData!['profileImagePath'])
                                    : const AssetImage(
                                            "assets/images/swapnali_pic.jpg")
                                        as ImageProvider,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    userData!['full_name'] ?? 'No Name',
                                    style: const TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    userData!['email'] ?? 'No Email',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    userData!['phone'] ?? 'No Phone',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildProfileField("COUNTRY", "India"),
                            Row(
                              children: [
                                Expanded(
                                    child: _buildProfileField("STATE",
                                        userData!['state'] ?? 'No State')),
                                Expanded(
                                    child: _buildProfileField("District",
                                        userData!['district'] ?? 'No City')),
                              ],
                            ),
                            _buildProfileField("VILLAGE NAME",
                                userData!['village'] ?? 'No Village'),
                            _buildProfileField("PIN CODE",
                                userData!['pincode'] ?? 'No PinCode'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToEditProfile,
        backgroundColor: Color.fromRGBO(38, 166, 154, 1),
        child: const Icon(Icons.edit, color: Colors.white),
      ),
    );
  }

  Widget _buildProfileField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontSize: 16)),
        const Divider(),
      ],
    );
  }
}
