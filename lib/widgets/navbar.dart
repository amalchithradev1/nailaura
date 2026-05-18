import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/constants.dart';
import '../core/theme.dart';
import '../core/utils.dart';
import '../core/theme.dart';

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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: isScrolled ? 60 : 70, // Reduced height and shrink when scrolled
      padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 0),
      decoration: BoxDecoration(
        color: isScrolled ? AppTheme.white.withOpacity(0.98) : AppTheme.white,
        boxShadow: isScrolled
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
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
          Row(
            children: [
              ...AppConstants.navLinks.map(
                (link) => Padding(
                  padding: const EdgeInsets.only(left: 32),
                  child: TextButton(
                    onPressed: () {
                      if (onNavTap != null) onNavTap!(link);
                    },
                    child: Text(
                      link,
                      style: GoogleFonts.inter(
                        color: AppTheme.textDark,
                        fontWeight: FontWeight.w500,
                        fontSize: 13, // Reduced font size
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 32),
              InkWell(
                onTap: () {
                  Utils.showBookingOptions(context);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppTheme.primaryGold.withOpacity(0.5)),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.phone_in_talk_outlined, color: AppTheme.primaryGold, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        '+91 6282596790',
                        style: GoogleFonts.inter(
                          color: AppTheme.textDark,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMobileNav(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: isScrolled ? 55 : 65,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
      decoration: BoxDecoration(
        color: isScrolled ? AppTheme.white.withOpacity(0.98) : AppTheme.white,
        boxShadow: isScrolled
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
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
            icon: const Icon(Icons.menu, color: AppTheme.textDark),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLogo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: isScrolled ? 110 : 130, // Shrink logo size when scrolled
        child: Image.asset(
          AppConstants.logoImage,
          fit: BoxFit.contain,
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
              padding: const EdgeInsets.only(left: 40.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Image.asset(
                  AppConstants.logoDarkImage, // Gold/White on dark background
                  height: 50,
                  fit: BoxFit.contain,
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
                        children: [
                          Icon(_getIconForLink(link), color: AppTheme.primaryGold, size: 28),
                          const SizedBox(width: 24),
                          Text(
                            link,
                            style: GoogleFonts.playfairDisplay(
                              color: AppTheme.white,
                              fontSize: 26,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.2,
                            ),
                          ),
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
                        style: GoogleFonts.inter(
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
