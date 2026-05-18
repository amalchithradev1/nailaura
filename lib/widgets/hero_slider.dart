import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/constants.dart';
import '../core/theme.dart';
import '../core/utils.dart';

class SlideData {
  final String imagePath;
  final String title;
  final String subtitle;

  SlideData({
    required this.imagePath,
    required this.title,
    required this.subtitle,
  });
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
      imagePath: AppConstants.studioBannerImage,
      title: 'Welcome to Nailaura',
      subtitle:
          'Experience luxury and precision craftsmanship at our beautiful new studio.',
    ),
    SlideData(
      imagePath: AppConstants.nailArtImage,
      title: 'Nail Art',
      subtitle:
          'Express your unique style with our intricate, hand-painted minimal designs.',
    ),
    SlideData(
      imagePath: AppConstants.gelExtensionImage,
      title: 'Gel Extension',
      subtitle:
          'Sculpted to absolute perfection for incredible length and strength.',
    ),
    SlideData(
      imagePath: AppConstants.manicureImage,
      title: 'Manicure',
      subtitle:
          'A timeless finish for healthy, naturally glowing nails and pristine cuticles.',
    ),
    SlideData(
      imagePath: AppConstants.extensionsImage, // Poly Gel
      title: 'Poly Gel Extension',
      subtitle:
          'The best of both worlds: lighter than acrylics, stronger than hard gel.',
    ),
    SlideData(
      imagePath: AppConstants.gelImage,
      title: 'Gel Manicure',
      subtitle:
          'High-shine, chip-free color that protects and lasts for weeks.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        setState(() {
          if (_currentPage < slides.length - 1) {
            _currentPage++;
          } else {
            _currentPage = 0;
          }
        });
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
    final height = isMobile
        ? MediaQuery.of(context).size.height - 70.0
        : MediaQuery.of(context).size.height - 75.0;

    return SizedBox(
      height: height,
      width: double.infinity,
      child: Stack(
        children: [
          Positioned.fill(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 1000),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              layoutBuilder: (currentChild, previousChildren) {
                return Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    ...previousChildren,
                    if (currentChild != null) currentChild,
                  ],
                );
              },
              child: _buildSlide(
                key: ValueKey<int>(_currentPage),
                slide: slides[_currentPage],
                isMobile: isMobile,
                isActive: true,
              ),
            ),
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
                    color: _currentPage == index
                        ? AppTheme.primaryGold
                        : Colors.white.withOpacity(0.8),
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

  Widget _buildSlide({
    Key? key,
    required SlideData slide,
    required bool isMobile,
    required bool isActive,
  }) {
    return Stack(
      key: key,
      fit: StackFit.expand,
      clipBehavior: Clip
          .hardEdge, // Prevent scaled image from overflowing the shaded area
      children: [
        // Background Image with zooming effect (explicitly clipped to prevent overflow)
        Positioned.fill(
          child: ClipRect(
            child: ImageFiltered(
              imageFilter: ui.ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
              child: Image.asset(slide.imagePath, fit: BoxFit.cover)
                  .animate()
                  .scale(
                    begin: const Offset(1.0, 1.0),
                    end: const Offset(1.1, 1.1),
                    duration: 6000.ms,
                  ),
            ),
          ),
        ),
        // Dark Overlay for readability
        Positioned.fill(
          child: Container(
            color: Colors.black.withOpacity(
              0.3,
            ), // Increased opacity to darken image
          ),
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
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      )
                      .animate()
                      .fadeIn(duration: 800.ms)
                      .slideX(begin: -0.2, end: 0),
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
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.8),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                      )
                      .animate()
                      .fadeIn(delay: 200.ms, duration: 800.ms)
                      .slideX(begin: 0.2, end: 0),
                const SizedBox(height: 24),
                if (isActive)
                  SizedBox(
                        width: isMobile ? double.infinity : 600,
                        child: Text(
                          slide.subtitle,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            color: Colors.white.withOpacity(0.95),
                            fontSize: isMobile ? 16 : 20,
                            height: 1.5,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.8),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      )
                      .animate()
                      .fadeIn(delay: 400.ms, duration: 800.ms)
                      .slideX(begin: -0.2, end: 0),
                const SizedBox(height: 48),
                if (isActive)
                  ElevatedButton(
                        onPressed: () {
                          Utils.showBookingOptions(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryGold.withOpacity(
                            0.9,
                          ),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 48,
                            vertical: 22,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          elevation: 15,
                          shadowColor: AppTheme.primaryGold.withOpacity(0.4),
                        ),
                        child: Text(
                          'BOOK APPOINTMENT',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2.0,
                          ),
                        ),
                      )
                      .animate()
                      .fadeIn(delay: 600.ms, duration: 600.ms)
                      .scale(begin: const Offset(0.9, 0.9)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
