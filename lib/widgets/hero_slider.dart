import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/constants.dart';
import '../core/theme.dart';

class SlideData {
  final String imagePath;
  final String title;
  final String subtitle;

  SlideData({required this.imagePath, required this.title, required this.subtitle});
}

class HeroSlider extends StatefulWidget {
  const HeroSlider({Key? key}) : super(key: key);

  @override
  State<HeroSlider> createState() => _HeroSliderState();
}

class _HeroSliderState extends State<HeroSlider> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  final List<SlideData> slides = [
    SlideData(
      imagePath: AppConstants.nailArtImage,
      title: 'Nail Art',
      subtitle: 'Express your unique style with our intricate, hand-painted minimal designs.',
    ),
    SlideData(
      imagePath: AppConstants.gelExtensionImage,
      title: 'Gel Extension',
      subtitle: 'Sculpted to absolute perfection for incredible length and strength.',
    ),
    SlideData(
      imagePath: AppConstants.manicureImage,
      title: 'Manicure',
      subtitle: 'A timeless finish for healthy, naturally glowing nails and pristine cuticles.',
    ),
    SlideData(
      imagePath: AppConstants.extensionsImage, // Poly Gel
      title: 'Poly Gel Extension',
      subtitle: 'The best of both worlds: lighter than acrylics, stronger than hard gel.',
    ),
    SlideData(
      imagePath: AppConstants.gelImage,
      title: 'Gel Manicure',
      subtitle: 'High-shine, chip-free color that protects and lasts for weeks.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_currentPage < slides.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth <= 800;
    // Make the slider take up almost the full screen height (minus navbar)
    final height = isMobile ? 500.0 : MediaQuery.of(context).size.height * 0.85;

    return SizedBox(
      height: height,
      width: double.infinity,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: slides.length,
            itemBuilder: (context, index) {
              return _buildSlide(slides[index], isMobile, index == _currentPage);
            },
          ),
          // Page Indicators
          Positioned(
            bottom: 32,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                slides.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index ? AppTheme.primaryGold : Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlide(SlideData slide, bool isMobile, bool isActive) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background Image
        Image.asset(
          slide.imagePath,
          fit: BoxFit.cover,
        ),
        // Dark Overlay for readability
        Container(
          color: Colors.black.withOpacity(0.4),
        ),
        // Content
        Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : 64),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isActive)
                  Text(
                    'ELEVATE YOUR AURA',
                    style: GoogleFonts.inter(
                      color: AppTheme.primaryGold,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4.0,
                    ),
                  ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.5, end: 0),
                const SizedBox(height: 16),
                if (isActive)
                  Text(
                    slide.title,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.playfairDisplay(
                      color: Colors.white,
                      fontSize: isMobile ? 48 : 72,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ).animate().fadeIn(delay: 200.ms, duration: 800.ms).slideY(begin: 0.2, end: 0),
                const SizedBox(height: 24),
                if (isActive)
                  SizedBox(
                    width: isMobile ? double.infinity : 600,
                    child: Text(
                      slide.subtitle,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: isMobile ? 16 : 20,
                        height: 1.5,
                      ),
                    ),
                  ).animate().fadeIn(delay: 400.ms, duration: 800.ms),
                const SizedBox(height: 48),
                if (isActive)
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryGold,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
                    ),
                    child: Text(
                      'Book Appointment',
                      style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ).animate().fadeIn(delay: 600.ms, duration: 600.ms).scale(begin: const Offset(0.9, 0.9)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
