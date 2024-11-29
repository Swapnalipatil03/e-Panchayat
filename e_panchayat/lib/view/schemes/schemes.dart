import 'package:flutter/material.dart';

class MySchemes {
  final String title;
  final String registeredDate;
  final String scheme;
  final String activityType;
  final double expenditure;
  final double estimatedCost;
  final String startDate;
  final String endDate;
  final int reviews;
  final bool isOngoing;
  final String period;
  final bool
      isMyScheme; // New field to differentiate between My Schemes and All Schemes

  MySchemes({
    required this.title,
    required this.registeredDate,
    required this.scheme,
    required this.activityType,
    required this.expenditure,
    required this.estimatedCost,
    required this.startDate,
    required this.endDate,
    this.reviews = 0,
    required this.isOngoing,
    required this.period,
    required this.isMyScheme,
  });
}

class SchemesPage extends StatefulWidget {
  const SchemesPage({super.key});

  @override
  State<SchemesPage> createState() => _SchemesPageState();
}

class _SchemesPageState extends State<SchemesPage> {
  bool showMySchemes = true;

  void _displaySchemeDetails(BuildContext context, MySchemes scheme) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Bottom Sheet Header
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(38, 166, 154, 1),
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                scheme.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton(
                              icon:
                                  const Icon(Icons.close, color: Colors.white),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Period: ${scheme.period}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Scheme Details
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailSection('Basic Information', [
                          _buildDetailRow(
                              'Registered Date', scheme.registeredDate),
                          _buildDetailRow('Scheme Type', scheme.scheme),
                          _buildDetailRow('Activity Type', scheme.activityType),
                        ]),
                        const SizedBox(height: 20),
                        _buildDetailSection('Financial Details', [
                          _buildDetailRow('Expenditure',
                              '₹${scheme.expenditure.toStringAsFixed(0)}'),
                          _buildDetailRow('Estimated Cost',
                              '₹${scheme.estimatedCost.toStringAsFixed(0)}'),
                          _buildDetailRow('Utilization',
                              '${((scheme.expenditure / scheme.estimatedCost) * 100).toStringAsFixed(1)}%'),
                        ]),
                        const SizedBox(height: 20),
                        _buildDetailSection('Timeline', [
                          _buildDetailRow('Start Date', scheme.startDate),
                          _buildDetailRow('End Date', scheme.endDate),
                          _buildDetailRow('Status',
                              scheme.isOngoing ? 'Ongoing' : 'Completed'),
                        ]),
                        const SizedBox(height: 20),
                        _buildDetailSection('Reviews & Feedback', [
                          _buildDetailRow(
                              'Total Reviews', scheme.reviews.toString()),
                        ]),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  final List<MySchemes> allSchemes = [
    // My Schemes
    MySchemes(
      title: 'Materials Required For Composting',
      registeredDate: '2024-02-10',
      scheme: 'XV Finance Commission',
      activityType: 'New/Fresh',
      expenditure: 201993,
      estimatedCost: 201993,
      startDate: '10 Feb 2024',
      endDate: '13 Nov 2024',
      isOngoing: true,
      period: '2024-2025',
      isMyScheme: true,
    ),
    MySchemes(
      title: 'Solar Panel Installation Project',
      registeredDate: '2024-01-15',
      scheme: 'Green Energy Initiative',
      activityType: 'New/Fresh',
      expenditure: 350000,
      estimatedCost: 400000,
      startDate: '15 Jan 2024',
      endDate: '15 Jul 2024',
      isOngoing: true,
      period: '2024-2025',
      isMyScheme: true,
    ),
    // All Schemes (including ones not registered by current user)
    MySchemes(
      title: 'Road Infrastructure Development',
      registeredDate: '2024-03-01',
      scheme: 'PMGSY',
      activityType: 'Infrastructure',
      expenditure: 1500000,
      estimatedCost: 2000000,
      startDate: '1 Mar 2024',
      endDate: '1 Sep 2024',
      isOngoing: true,
      period: '2024-2025',
      isMyScheme: false,
    ),
    MySchemes(
      title: 'Water Conservation Project',
      registeredDate: '2024-02-20',
      scheme: 'Jal Shakti Abhiyan',
      activityType: 'Conservation',
      expenditure: 450000,
      estimatedCost: 500000,
      startDate: '20 Feb 2024',
      endDate: '20 Aug 2024',
      isOngoing: true,
      period: '2024-2025',
      isMyScheme: false,
    ),
    MySchemes(
      title: 'Rural Housing Development',
      registeredDate: '2024-01-25',
      scheme: 'PMAY-G',
      activityType: 'Housing',
      expenditure: 2500000,
      estimatedCost: 3000000,
      startDate: '25 Jan 2024',
      endDate: '25 Dec 2024',
      isOngoing: true,
      period: '2024-2025',
      isMyScheme: false,
    ),
  ];

  List<MySchemes> get filteredSchemes {
    return allSchemes
        .where((scheme) => scheme.isMyScheme == showMySchemes)
        .toList();
  }

  Widget _buildDetailSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color.fromRGBO(38, 166, 154, 1),
          ),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

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
        backgroundColor: const Color.fromRGBO(0, 137, 123, 1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    'Schemes',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildFilterButton('My Schemes', showMySchemes, true),
                    const SizedBox(width: 12),
                    _buildFilterButton('All Schemes', !showMySchemes, false),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredSchemes.length,
              itemBuilder: (context, index) {
                return _buildWorkCard(filteredSchemes[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String text, bool isSelected, bool isMySchemes) {
    return InkWell(
      onTap: () {
        setState(() {
          showMySchemes = isMySchemes;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          color:
              isSelected ? Color.fromRGBO(38, 166, 154, 1) : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.black,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildWorkCard(MySchemes scheme) {
    return GestureDetector(
      // Add this GestureDetector
      onTap: () => _displaySchemeDetails(context, scheme),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          scheme.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Text(
                        scheme.period,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow('Registered on:', scheme.registeredDate),
                  _buildInfoRow('Scheme:', scheme.scheme),
                  _buildInfoRow('Activity Type:', scheme.activityType),
                  _buildInfoRow('Expenditure:',
                      '₹ ${scheme.expenditure.toStringAsFixed(0)}'),
                  _buildInfoRow('Estimated Cost:',
                      '₹ ${scheme.estimatedCost.toStringAsFixed(0)}'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star,
                          color: Color(0xFF5CB9DE), size: 20),
                      Text(' ${scheme.reviews}'),
                      const Spacer(),
                    ],
                  ),
                ],
              ),
            ),
            _buildTimelineBar(scheme),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineBar(MySchemes scheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 70,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF5CB9DE),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const Expanded(
                  flex: 30,
                  child: SizedBox(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(scheme.startDate),
              Text(scheme.endDate),
            ],
          ),
        ],
      ),
    );
  }
}
