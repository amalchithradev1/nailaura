import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'theme.dart';

class Utils {
  // Contact Details
  static const String studioPhone = '+918281791180'; // Assuming +91 for WhatsApp to work correctly
  static const String studioEmail = 'thenailauraofficial@gmail.com';

  static void showBookingOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 480),
            padding: EdgeInsets.all(MediaQuery.of(context).size.width <= 600 ? 20 : 36),
            decoration: BoxDecoration(
              color: const Color(0xFF161514), // Deep luxury charcoal
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.primaryGold.withOpacity(0.4),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 40,
                  offset: const Offset(0, 20),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top header row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'NAILAURA CONCIERGE',
                      style: GoogleFonts.montserrat(
                        color: AppTheme.primaryGold,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 3.0,
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.08),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          size: 18,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'Reserve Your Visit',
                  style: GoogleFonts.cormorantGaramond(
                    color: AppTheme.white,
                    fontSize: 38,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Select your preferred booking channel to connect personally with our studio reception.',
                  style: GoogleFonts.montserrat(
                    color: AppTheme.white.withOpacity(0.75),
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  height: 1,
                  width: 48,
                  color: AppTheme.primaryGold,
                ),
                const SizedBox(height: 28),
                _LuxuryBookingOptionCard(
                  icon: Icons.chat_bubble_outline,
                  title: 'WhatsApp Concierge',
                  subtitle: 'Fastest response · Instant chat with reception',
                  badgeText: 'INSTANT',
                  onTap: () {
                    Navigator.pop(context);
                    _launchWhatsApp();
                  },
                ),
                const SizedBox(height: 14),
                _LuxuryBookingOptionCard(
                  icon: Icons.phone_outlined,
                  title: 'Call Studio Directly',
                  subtitle: '+91 8281 791180 · Speak with our team',
                  badgeText: 'DIRECT',
                  onTap: () {
                    Navigator.pop(context);
                    _launchPhone();
                  },
                ),
                const SizedBox(height: 14),
                _LuxuryBookingOptionCard(
                  icon: Icons.mail_outline,
                  title: 'Send an Email Note',
                  subtitle: 'For bridal, events & bespoke nail art inquiries',
                  badgeText: 'INQUIRE',
                  onTap: () {
                    Navigator.pop(context);
                    _launchEmail();
                  },
                ),
                const SizedBox(height: 32),
                Center(
                  child: Text(
                    'STUDIO HOURS: TUESDAY – SUNDAY · 10:00 AM – 7:00 PM',
                    style: GoogleFonts.montserrat(
                      color: AppTheme.white.withOpacity(0.35),
                      fontSize: 10,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      },
    );
  }

  // --- URL Launchers ---

  static Future<void> _launchWhatsApp() async {
    final message = Uri.encodeComponent(
        "Hello nailaura ✧\n\nI would love to schedule an appointment. Could you please let me know your availability?\n\nThank you!");
    final cleanPhone = studioPhone.replaceAll(RegExp(r'\D'), '');
    final url = Uri.parse('https://wa.me/$cleanPhone?text=$message');
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
    final body = Uri.encodeComponent(
        "Hello Nailaura ✧\n\nI would love to schedule an appointment. Could you please let me know your availability?\n\nThank you!");
    final url = Uri.parse('mailto:$studioEmail?subject=Appointment%20Booking&body=$body');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      debugPrint("Could not launch email client");
    }
  }
}

class _LuxuryBookingOptionCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String badgeText;
  final VoidCallback onTap;

  const _LuxuryBookingOptionCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.badgeText,
    required this.onTap,
  }) : super(key: key);

  @override
  State<_LuxuryBookingOptionCard> createState() =>
      _LuxuryBookingOptionCardState();
}

class _LuxuryBookingOptionCardState extends State<_LuxuryBookingOptionCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width <= 450;
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 10 : 16, vertical: isMobile ? 12 : 16),
          decoration: BoxDecoration(
            color: _isHovered
                ? AppTheme.primaryGold
                : const Color(0xFF22201E),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: _isHovered
                  ? AppTheme.primaryGold
                  : AppTheme.primaryGold.withOpacity(0.25),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(isMobile ? 8 : 12),
                decoration: BoxDecoration(
                  color: _isHovered
                      ? const Color(0xFF161514)
                      : AppTheme.primaryGold.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  widget.icon,
                  color: _isHovered ? AppTheme.white : AppTheme.primaryGold,
                  size: 20,
                ),
              ),
              SizedBox(width: isMobile ? 8 : 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: GoogleFonts.cormorantGaramond(
                        color: _isHovered
                            ? const Color(0xFF161514)
                            : AppTheme.white,
                        fontWeight: FontWeight.w600,
                        fontSize: isMobile ? 16 : 20,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.subtitle,
                      style: GoogleFonts.montserrat(
                        color: _isHovered
                            ? const Color(0xFF161514).withOpacity(0.85)
                            : AppTheme.white.withOpacity(0.65),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: _isHovered
                      ? const Color(0xFF161514)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _isHovered
                        ? Colors.transparent
                        : AppTheme.primaryGold.withOpacity(0.4),
                  ),
                ),
                child: Text(
                  widget.badgeText,
                  style: GoogleFonts.montserrat(
                    color: _isHovered ? AppTheme.white : AppTheme.primaryGold,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
