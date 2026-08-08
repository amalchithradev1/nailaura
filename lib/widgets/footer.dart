import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme.dart';
import '../core/constants.dart';

class Footer extends StatelessWidget {
  const Footer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppTheme.textDark,
      padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 48),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 800) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _buildFooterContent(context),
            );
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _buildFooterContent(context)
                  .map(
                    (widget) => Padding(
                      padding: const EdgeInsets.only(bottom: 32),
                      child: widget,
                    ),
                  )
                  .toList(),
            );
          }
        },
      ),
    );
  }

  List<Widget> _buildFooterContent(BuildContext context) {
    return [
      // Column 1: Brand
      Expanded(
        flex: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  AppConstants.logoIcon,
                  height: 52,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 14),
                Image.asset(
                  AppConstants.logoTextGold,
                  height: 44,
                  fit: BoxFit.contain,
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
      const SizedBox(width: 32),
      // Column 2: Links
      Expanded(
        flex: 1,
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
      const SizedBox(width: 32),
      // Column 3: Contact
      Expanded(
        flex: 1,
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
