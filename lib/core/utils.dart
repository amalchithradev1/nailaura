import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'theme.dart';

class Utils {
  // Contact Details
  static const String studioPhone = '+916282596790'; // Assuming +91 for WhatsApp to work correctly
  static const String studioEmail = 'aswathyprasad6790@gmail.com';

  static void showBookingOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'BOOK AN APPOINTMENT',
                  style: GoogleFonts.inter(
                    color: AppTheme.primaryGold,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'How would you like to book?',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.playfairDisplay(
                    color: AppTheme.textDark,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 32),
                _buildContactOption(
                  icon: Icons.chat_bubble_outline,
                  title: 'WhatsApp Message',
                  subtitle: 'Fastest response time',
                  onTap: () {
                    Navigator.pop(context);
                    _launchWhatsApp();
                  },
                ),
                const SizedBox(height: 16),
                _buildContactOption(
                  icon: Icons.phone_outlined,
                  title: 'Call Us Directly',
                  subtitle: 'Speak with our reception',
                  onTap: () {
                    Navigator.pop(context);
                    _launchPhone();
                  },
                ),
                const SizedBox(height: 32),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.inter(
                      color: AppTheme.textDark.withOpacity(0.5),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Widget _buildContactOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.primaryGold.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.backgroundCream,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppTheme.primaryGold),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      color: AppTheme.textDark,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      color: AppTheme.textDark.withOpacity(0.6),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 14, color: AppTheme.primaryGold),
          ],
        ),
      ),
    );
  }

  // --- URL Launchers ---

  static Future<void> _launchWhatsApp() async {
    final message = Uri.encodeComponent("Hi Nailaura! I would like to book an appointment.");
    final url = Uri.parse('https://wa.me/$studioPhone?text=$message');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      debugPrint("Could not launch WhatsApp");
    }
  }

  static Future<void> _launchPhone() async {
    final url = Uri.parse('tel:$studioPhone');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      debugPrint("Could not launch phone dialer");
    }
  }

  static Future<void> _launchEmail() async {
    final url = Uri.parse('mailto:$studioEmail?subject=Appointment%20Booking');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      debugPrint("Could not launch email client");
    }
  }
}
