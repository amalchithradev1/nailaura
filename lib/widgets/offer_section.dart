import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/theme.dart';
import 'scroll_reveal.dart';

class OfferSection extends StatelessWidget {
  final bool isActive;
  final String title1;
  final String title2;
  final String title3;

  const OfferSection({
    Key? key,
    this.isActive = true,
    this.title1 = 'Onam',
    this.title2 = '& OPENING',
    this.title3 = 'Offer',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isActive) return const SizedBox.shrink();

    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth <= 800;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.backgroundCream, // Matching the flyer background
        image: DecorationImage(
          image: const AssetImage('assets/images/offer_bg.png'),
          fit: BoxFit.cover,
          opacity: 0.8,
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 64,
        vertical: isMobile ? 60 : 100,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Header Row
          isMobile ? _buildMobileHeader() : _buildDesktopHeader(screenWidth),
          const SizedBox(height: 50),

          // Offer Details
          _buildOfferDetails(isMobile),
        ],
      ),
    );
  }

  Widget _buildMobileHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.local_florist,
              color: AppTheme.primaryGold,
              size: 50,
            ).animate().rotate(duration: 2000.ms),
            const SizedBox(width: 12),
            Text(
              title1,
              style: GoogleFonts.greatVibes(
                color: AppTheme.primaryGold,
                fontSize: 120,
                height: 0.8,
              ),
            ).animate().fadeIn(duration: 800.ms).slideX(begin: 0.1),
          ],
        ),
        Text(
          title2,
          style: GoogleFonts.montserrat(
            color: AppTheme.textDark,
            fontSize: 40,
            fontWeight: FontWeight.w800,
            letterSpacing: 2.0,
            height: 1.0,
          ),
        ).animate().fadeIn(duration: 800.ms).slideX(begin: -0.1),
        Text(
          title3,
          style: GoogleFonts.greatVibes(
            color: AppTheme.primaryGold,
            fontSize: 170,
            height: 0.8,
          ),
        ).animate().fadeIn(duration: 800.ms).slideX(begin: 0.1),
      ],
    );
  }

  Widget _buildDesktopHeader(double screenWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end, // Align to the divider
          children: [
            Row(
              children: [
                Icon(
                  Icons.local_florist,
                  color: AppTheme.primaryGold,
                  size: 48,
                ).animate().rotate(duration: 2000.ms),
                const SizedBox(width: 16),
                Text(
                  title1,
                  style: GoogleFonts.greatVibes(
                    color: AppTheme.primaryGold,
                    fontSize: 250,
                    height: 0.8,
                  ),
                ).animate().fadeIn(duration: 800.ms).slideX(begin: 0.1),
              ],
            ),
            Text(
              title2,
              style: GoogleFonts.montserrat(
                color: AppTheme.textDark,
                fontSize: 60,
                fontWeight: FontWeight.w800,
                letterSpacing: 2.0,
                height: 1.0,
              ),
            ).animate().fadeIn(duration: 800.ms).slideX(begin: -0.1),
          ],
        ),
        const SizedBox(width: 48),
        Container(
          width: 2,
          height: 120,
          color: AppTheme.primaryGold.withOpacity(0.5),
        ).animate().scaleY(duration: 800.ms),
        const SizedBox(width: 48),
        Text(
          title3,
          style: GoogleFonts.greatVibes(
            color: AppTheme.primaryGold,
            fontSize: 190,
            height: 0.8,
          ),
        ).animate().fadeIn(duration: 800.ms).slideX(begin: 0.1),
      ],
    );
  }

  Widget _buildOfferDetails(bool isMobile) {
    return Column(
      children: [
        const SizedBox(height: 24),
        ScrollReveal(
          delay: 200.ms,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 0),
            child: Text(
              'Enjoy up to 30% off on premium nail extensions and gel polish.\nTreat yourself to the luxury you deserve.',
              textAlign: TextAlign.center,
              style: GoogleFonts.cormorantGaramond(
                color: AppTheme.textDark.withOpacity(0.8),
                fontSize: isMobile ? 18 : 24,
                fontWeight: FontWeight.w600,
                height: 1.5,
              ),
            ),
          ),
        ),
        const SizedBox(height: 48),
        ScrollReveal(
          delay: 300.ms,
          child: ElevatedButton(
            onPressed: () {
              // TODO: Implement booking navigation or contact action
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryGold,
              foregroundColor: AppTheme.white,
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 32 : 48,
                vertical: isMobile ? 16 : 20,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 8,
              shadowColor: AppTheme.primaryGold.withOpacity(0.5),
            ),
            child: Text(
              'Book Now to Claim Offer',
              style: GoogleFonts.montserrat(
                fontSize: isMobile ? 16 : 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
