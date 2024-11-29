// carousel_widget.dart
import 'dart:async';
import 'package:e_panchayat/view/schemes/schemes.dart';
import 'package:flutter/material.dart';
//import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CarouselData {
  final String title;
  final String description;
  final String image;

  CarouselData({
    required this.title,
    required this.description,
    required this.image,
  });
}

class CustomCarousel extends StatefulWidget {
  final List<CarouselData> items;
  final double height;
  final Color backgroundColor;
  final Duration autoPlayInterval;
  final bool showIndicator;
  final Function(int)? onPageChanged;
  final VoidCallback? onTap;

  const CustomCarousel({
    super.key,
    required this.items,
    this.height = 180,
    this.backgroundColor = const Color(0xFFFFF0F0),
    this.autoPlayInterval = const Duration(seconds: 3),
    this.showIndicator = true,
    this.onPageChanged,
    this.onTap,
  });

  @override
  State<CustomCarousel> createState() => _CustomCarouselState();
}

class _CustomCarouselState extends State<CustomCarousel> {
  final PageController _pageController = PageController();
  Timer? _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _startAutoPlay();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(widget.autoPlayInterval, (timer) {
      if (_currentPage < widget.items.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeIn,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          SizedBox(
            height: widget.height,
            child: Stack(
              children: [
                PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                      widget.onPageChanged?.call(index);
                    });
                  },
                  itemCount: widget.items.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: widget.onTap,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.items[index].title,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    widget.items[index].description,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  const SizedBox(height: 8),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SchemesPage()),
                                      );
                                    },
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text('Click here'),
                                        SizedBox(width: 4),
                                        //Icon(Icons.arrow_forward, size: 16),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Image.asset(
                              widget.items[index].image,
                              height: 100,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                // Navigation arrows
                Positioned.fill(
                  child: Row(
                    children: [
                      // IconButton(
                      //   icon: const Icon(Icons.arrow_back_ios),
                      //   onPressed: () {
                      //     _pageController.previousPage(
                      //       duration: const Duration(milliseconds: 350),
                      //       curve: Curves.easeIn,
                      //     );
                      //   },
                      // ),
                      const Spacer(),
                      // IconButton(
                      //   icon: const Icon(Icons.arrow_forward_ios),
                      //   onPressed: () {
                      //     _pageController.nextPage(
                      //       duration: const Duration(milliseconds: 350),
                      //       curve: Curves.easeIn,
                      //     );
                      //   },
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          //   if (widget.showIndicator)
          //     // Padding(
          //     //   padding: const EdgeInsets.only(bottom: 16),
          //     //   child: SmoothPageIndicator(
          //     //     controller: _pageController,
          //     //     count: widget.items.length,
          //     //     effect: const WormEffect(
          //     //       dotHeight: 8,
          //     //       dotWidth: 8,
          //     //       spacing: 8,
          //     //       activeDotColor: Colors.blue,
          //     //       dotColor: Colors.grey,
          //     //     ),
          //     //   ),
          //     // ),
        ],
      ),
    );
  }
}
