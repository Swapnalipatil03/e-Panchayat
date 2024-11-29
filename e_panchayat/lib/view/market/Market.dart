import 'package:flutter/material.dart';

void main() => runApp(MarketRatesApp());

class MarketRatesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Market Rates',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color.fromRGBO(0, 137, 123, 1), // AppBar color
        scaffoldBackgroundColor:
            Color.fromRGBO(229, 230, 248, 1), // Scaffold color
      ),
      home: MarketRatesPage(),
    );
  }
}

class MarketRatesPage extends StatefulWidget {
  @override
  _MarketRatesPageState createState() => _MarketRatesPageState();
}

class _MarketRatesPageState extends State<MarketRatesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Product> vegetables = [
    Product(
        name: "Tomatoes", rate: "₹40/kg", image: "assets/images/tomatoes.png"),
    Product(name: "Onions", rate: "₹30/kg", image: "assets/images/onions.jpg"),
    Product(
        name: "Potatoes", rate: "₹20/kg", image: "assets/images/potatoes.jpg"),
    Product(
        name: "Carrots", rate: "₹60/kg", image: "assets/images/carrots.jpg"),
    Product(
        name: "Cucumbers",
        rate: "₹50/kg",
        image: "assets/images/cucumbers.jpg"),
    Product(
        name: "Spinach", rate: "₹40/kg", image: "assets/images/spinach.jpg"),
  ];

  final List<Product> fruits = [
    Product(name: "Apples", rate: "₹120/kg", image: "assets/images/apples.jpg"),
    Product(
        name: "Bananas", rate: "₹50/dozen", image: "assets/images/bananas.png"),
    Product(
        name: "Mangoes", rate: "₹150/kg", image: "assets/images/mangoes.jpg"),
    Product(
        name: "Oranges", rate: "₹80/kg", image: "assets/images/oranges.jpg"),
    Product(name: "Grapes", rate: "₹90/kg", image: "assets/images/grapes.jpg"),
    Product(
        name: "Pineapple",
        rate: "₹60/kg",
        image: "assets/images/pineapple.jpg"),
  ];

  final List<Product> grains = [
    Product(name: "Rice", rate: "₹60/kg", image: "assets/images/rice.jpg"),
    Product(name: "Wheat", rate: "₹45/kg", image: "assets/images/wheat.jpg"),
    Product(name: "Barley", rate: "₹70/kg", image: "assets/images/barley.jpg"),
    Product(name: "Oats", rate: "₹80/kg", image: "assets/images/oats.jpg"),
    Product(name: "Maize", rate: "₹50/kg", image: "assets/images/maize.jpg"),
    Product(
        name: "Millets", rate: "₹75/kg", image: "assets/images/millets.jpg"),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            const Size.fromHeight(100.0), // Set the height of the AppBar
        child: AppBar(
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
            'Current Market Rates',
            style: TextStyle(color: Colors.white), // White text color
          ),
          centerTitle: true,
          bottom: TabBar(
            controller: _tabController,
            indicatorColor:
                Colors.white, // White underline indicator for active tab
            labelColor: Colors.white, // Active tab text color
            unselectedLabelColor: Colors.black, // Inactive tab text color
            tabs: const [
              Tab(text: 'Vegetables'),
              Tab(text: 'Fruits'),
              Tab(text: 'Grains'),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildProductList(vegetables),
          _buildProductList(fruits),
          _buildProductList(grains),
        ],
      ),
    );
  }

  Widget _buildProductList(List<Product> products) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          color: Color(0xFFF9F9F9), // Off-white card color
          child: Container(
            height: 150,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Image.asset(
                  product.image,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        product.name,
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        product.rate,
                        style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class Product {
  final String name;
  final String rate;
  final String image;

  Product({required this.name, required this.rate, required this.image});
}
