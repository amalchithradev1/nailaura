import 'dart:async';
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
      imagePath: AppConstants.gelExtensionImage,
      title: 'Structured Gel Extensions',
      subtitle:
          'Sculpted to flawless symmetry for exceptional length, strength, and elegance.',
    ),
    SlideData(
      imagePath: AppConstants.manicureImage,
      title: 'Signature Dry Manicure',
      subtitle:
          'Meticulous cuticle care for clean, naturally radiant nails and lasting perfection.',
    ),
    SlideData(
      imagePath: AppConstants.extensionsImage, // Poly Gel
      title: 'Advanced Poly Gel',
      subtitle:
          'The best of both worlds: lighter than acrylics, stronger than hard gel.',
    ),
    SlideData(
      imagePath: AppConstants.gelImage,
      title: 'High-Gloss Gel Polish',
      subtitle:
          'Luminous, chip-resistant color with a mirror finish that endures for weeks.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
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
        ? 620.0
        : (MediaQuery.of(context).size.height - 88.0 < 600
            ? 600.0
            : MediaQuery.of(context).size.height - 88.0);

    return Container(
      height: height,
      width: double.infinity,
      color: AppTheme.backgroundCream,
      child: Stack(
        children: [
          Positioned.fill(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 1000),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: _buildSlide(
                key: ValueKey<int>(_currentPage),
                slide: slides[_currentPage],
                isMobile: isMobile,
                screenWidth: screenWidth,
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
    required double screenWidth,
  }) {
    if (isMobile) {
      return Container(
        key: key,
        color: AppTheme.backgroundCream,
        width: double.infinity,
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                slide.title,
                maxLines: 2,
                style: GoogleFonts.cormorantGaramond(
                  color: AppTheme.textDark,
                  fontSize: 42,
                  fontWeight: FontWeight.w400,
                  height: 1.05,
                  letterSpacing: -1.0,
                ),
              ).animate().fadeIn(duration: 700.ms).slideY(begin: 0.1, end: 0),
              const SizedBox(height: 12),
              Text(
                slide.subtitle,
                style: GoogleFonts.montserrat(
                  color: AppTheme.textDark.withOpacity(0.85),
                  fontSize: 14,
                  height: 1.5,
                ),
              ).animate().fadeIn(delay: 200.ms, duration: 700.ms),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Utils.showBookingOptions(context);
                },
                child: Text(
                  'Book now',
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ).animate().fadeIn(delay: 350.ms, duration: 700.ms),
              const SizedBox(height: 24),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: double.infinity,
                  height: 300,
                  child: Image.asset(
                    slide.imagePath,
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                  ).animate().scale(
                        begin: const Offset(1.05, 1.05),
                        end: const Offset(1.0, 1.0),
                        duration: 8000.ms,
                      ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Squarespace 7.1 Editorial Desktop Layout (Title overlapping across photo)
    return Container(
      key: key,
      color: AppTheme.backgroundCream,
      child: Stack(
        children: [
          // Right Side Photo Box
          Positioned(
            right: 64,
            top: 40,
            bottom: 60,
            width: screenWidth * 0.48,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.asset(slide.imagePath, fit: BoxFit.cover)
                  .animate()
                  .scale(
                    begin: const Offset(1.08, 1.08),
                    end: const Offset(1.0, 1.0),
                    duration: 8000.ms,
                    curve: Curves.easeOutCubic,
                  ),
            ),
          ),
          // Left Side Headline (Overlapping onto right image)
          Positioned(
            left: 64,
            top: 110,
            right: 40, // Allows text to stretch horizontally without wrapping
            child: Text(
              slide.title,
              maxLines: 2,
              style: GoogleFonts.cormorantGaramond(
                color: AppTheme.textDark,
                fontSize: screenWidth > 1400 ? 118 : 98,
                fontWeight: FontWeight.w300,
                height: 0.94,
                letterSpacing: -1.5,
              ),
            ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.08, end: 0),
          ),
          // Subtitle & CTA Buttons below headline on the left
          Positioned(
            left: 64,
            bottom: 80,
            width: 440,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                      slide.subtitle,
                      style: GoogleFonts.montserrat(
                        color: AppTheme.textDark.withOpacity(0.85),
                        fontSize: 16,
                        height: 1.6,
                      ),
                    )
                    .animate()
                    .fadeIn(delay: 200.ms, duration: 800.ms)
                    .slideY(begin: 0.08, end: 0),
                const SizedBox(height: 32),
                Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Utils.showBookingOptions(context);
                          },
                          child: Text(
                            'Book now',
                            style: GoogleFonts.montserrat(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        OutlinedButton(
                          onPressed: () {
                            // Scroll down to services
                          },
                          child: Text(
                            'Explore services',
                            style: GoogleFonts.montserrat(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    )
                    .animate()
                    .fadeIn(delay: 400.ms, duration: 800.ms)
                    .slideY(begin: 0.08, end: 0),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
