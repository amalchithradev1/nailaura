import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/constants.dart';
import '../core/theme.dart';
import '../core/utils.dart';

class NavBar extends StatelessWidget {
  final bool isScrolled;
  final Function(String)? onNavTap;
  const NavBar({Key? key, this.isScrolled = false, this.onNavTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 800) {
          return _buildDesktopNav(context);
        } else {
          return _buildMobileNav(context);
        }
      },
    );
  }

  Widget _buildDesktopNav(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: isScrolled ? 12.0 : 0.0, sigmaY: isScrolled ? 12.0 : 0.0),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: isScrolled ? 64 : 70,
          padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 0),
          decoration: BoxDecoration(
            color: AppTheme.backgroundCream,
            boxShadow: isScrolled
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 15,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildLogo(context),
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ...AppConstants.navLinks.map(
                (link) => Padding(
                  padding: const EdgeInsets.only(left: 22),
                  child: TextButton(
                    onPressed: () {
                      if (onNavTap != null) onNavTap!(link);
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.textDark,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    ),
                    child: Text(
                      link,
                      style: GoogleFonts.montserrat(
                        color: AppTheme.textDark,
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 26),
              InkWell(
                onTap: () {
                  Utils.showBookingOptions(context);
                },
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppTheme.buttonDark,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    'Book now',
                    style: GoogleFonts.montserrat(
                      color: AppTheme.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              )
                  .animate(onPlay: (c) => c.repeat(reverse: true))
                  .scale(begin: const Offset(1.0, 1.0), end: const Offset(1.04, 1.04), duration: 1800.ms),
            ],
          ),
        ],
      ),
    ),
  ),
);
}

  Widget _buildMobileNav(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: isScrolled ? 12.0 : 0.0, sigmaY: isScrolled ? 12.0 : 0.0),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: isScrolled ? 60 : 70,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
          decoration: BoxDecoration(
            color: AppTheme.backgroundCream,
            boxShadow: isScrolled
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildLogo(context),
          IconButton(
            icon: const Icon(Icons.menu, color: AppTheme.textDark, size: 28),
            onPressed: () {
              Scaffold.of(context).openEndDrawer();
            },
          ),
        ],
      ),
    ),
  ),
);
}

  Widget _buildLogo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: () {
          if (onNavTap != null) onNavTap!('Home');
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              AppConstants.logoIcon,
              height: isScrolled ? 36 : 42,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 12),
            Image.asset(
              AppConstants.logoTextGold,
              height: isScrolled ? 32 : 38,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }


}

class MobileDrawer extends StatelessWidget {
  final Function(String)? onNavTap;
  const MobileDrawer({Key? key, this.onNavTap}) : super(key: key);

  IconData _getIconForLink(String link) {
    switch (link) {
      case 'Home': return Icons.home_outlined;
      case 'Services': return Icons.spa_outlined;
      case 'About':
      case 'About Us': return Icons.info_outline;
      case 'Contact': return Icons.phone_outlined;
      default: return Icons.circle_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppTheme.textDark, // Elegant dark theme
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            // Header Logo
            Padding(
              padding: const EdgeInsets.only(left: 32.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Image.asset(
                      AppConstants.logoIcon,
                      height: 42,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(width: 12),
                    Image.asset(
                      AppConstants.logoTextGold,
                      height: 36,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 60),
            
            // Navigation Links
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                children: AppConstants.navLinks.map((link) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 32.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context); // Close drawer
                        if (onNavTap != null) onNavTap!(link);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            link,
                            style: GoogleFonts.cormorantGaramond(
                              color: AppTheme.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Icon(_getIconForLink(link), color: AppTheme.primaryGold, size: 20),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            // Bottom Actions
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Utils.showBookingOptions(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryGold,
                        foregroundColor: AppTheme.white,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'BOOK APPOINTMENT',
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
