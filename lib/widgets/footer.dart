import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme.dart';
import '../core/constants.dart';

class Footer extends StatelessWidget {
  const Footer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width <= 800;
    
    return Container(
      width: double.infinity,
      color: AppTheme.textDark,
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : 64, vertical: 48),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _buildFooterContent(context, true)
                  .map(
                    (widget) => Padding(
                      padding: const EdgeInsets.only(bottom: 32),
                      child: widget,
                    ),
                  )
                  .toList(),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _buildFooterContent(context, false),
            ),
    );
  }

  Widget _wrapExpanded({required int flex, required bool isMobile, required Widget child}) {
    if (isMobile) return child;
    return Expanded(flex: flex, child: child);
  }

  List<Widget> _buildFooterContent(BuildContext context, bool isMobile) {
    return [
      // Column 1: Brand
      _wrapExpanded(
        flex: 2,
        isMobile: isMobile,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  AppConstants.logoIcon,
                  height: 48,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 14),
                Flexible(
                  child: Image.asset(
                    AppConstants.logoTextGold,
                    height: 40,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Precision craftsmanship meets luxury. Specializing in flawless dry manicures, structured gel extensions, and bespoke nail artistry to elevate your aura.',
              style: GoogleFonts.montserrat(
                color: AppTheme.white.withOpacity(0.7),
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
      if (!isMobile) const SizedBox(width: 32),
      // Column 2: Links
      _wrapExpanded(
        flex: 1,
        isMobile: isMobile,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Links',
              style: GoogleFonts.montserrat(
                color: AppTheme.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildFooterLink('Services'),
            _buildFooterLink('About Us'),
            _buildFooterLink('Contact'),
            _buildFooterLink('Booking Policy'),
          ],
        ),
      ),
      if (!isMobile) const SizedBox(width: 32),
      // Column 3: Contact
      _wrapExpanded(
        flex: 1,
        isMobile: isMobile,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Contact Us',
              style: GoogleFonts.montserrat(
                color: AppTheme.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildContactInfo(
              Icons.location_on,
              'Kulathoor, Thiruvananthapuram,\nKerala 695583',
            ),
            const SizedBox(height: 8),
            _buildContactInfo(Icons.phone, '+91 8281791180'),
            const SizedBox(height: 8),
            _buildContactInfo(Icons.email, 'thenailauraofficial@gmail.com'),
          ],
        ),
      ),
    ];
  }

  Widget _buildFooterLink(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: InkWell(
        onTap: () {},
        child: Text(
          text,
          style: GoogleFonts.montserrat(
            color: AppTheme.white.withOpacity(0.7),
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildContactInfo(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppTheme.primaryGold, size: 16),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.montserrat(
              color: AppTheme.white.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
