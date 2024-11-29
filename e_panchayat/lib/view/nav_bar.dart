import 'package:e_panchayat/view/chatbot/chatbot.dart';
import 'package:e_panchayat/view/chatbot/chatsplash.dart';
import 'package:e_panchayat/view/home/home.dart';
import 'package:e_panchayat/view/market/Market.dart';
import 'package:e_panchayat/view/profile/profilePage.dart';
import 'package:flutter/material.dart';

import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<NavBar> {
  late PersistentTabController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        PersistentTabController(initialIndex: 0); // Start with Home Page
  }

  List<Widget> _buildScreens() {
    return [
      const Home(),
      MarketRatesApp(),
      FullScreenGifSplashScreen(),
      const ProfileScreen(
        userId: '3fLXsNfaohfkio1wcbGITsYh5Px2',
      ),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.home),
        title: _controller.index == 0 ? "Home" : null,
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.black,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.store),
        title: _controller.index == 1 ? "Market" : null,
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.black,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.chat),
        title: _controller.index == 2 ? "Chatbot" : null,
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.black,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.person),
        title: _controller.index == 3 ? "Profile" : null,
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.black,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5), // Adjust the padding
      child: PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        // confineInSafeArea: true,
        backgroundColor:
            const Color.fromARGB(255, 11, 186, 169), // Updated color
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        stateManagement: true,
        navBarHeight: 60, // Increase height
        decoration: NavBarDecoration(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12.0),
              topRight: Radius.circular(12.0)), // Rounded corners
          colorBehindNavBar: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        navBarStyle: NavBarStyle.style1, // Sleek modern navbar
        onItemSelected: (index) => setState(() {}),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home Page")),
      body: const Center(child: Text("Welcome to the Home Page!")),
    );
  }
}

class MarketPage extends StatelessWidget {
  const MarketPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Market Page")),
      body: const Center(child: Text("Welcome to the Market Page!")),
    );
  }
}

class ChatbotPage extends StatelessWidget {
  const ChatbotPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chatbot Page")),
      body: const Center(child: Text("Welcome to the Chatbot Page!")),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile Page")),
      body: const Center(child: Text("Welcome to the Profile Page!")),
    );
  }
}
