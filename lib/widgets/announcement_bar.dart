import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/theme.dart';

class AnnouncementBar extends StatelessWidget {
  const AnnouncementBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth <= 800;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 64,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: AppTheme.primaryGold,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.auto_awesome,
            color: AppTheme.white,
            size: 14,
          )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .scale(begin: const Offset(0.8, 0.8), end: const Offset(1.2, 1.2), duration: 1200.ms),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              isMobile
                  ? '✨ THE NAIL STUDIO • BOOK YOUR APPOINTMENT TODAY ✨'
                  : '✨ WELCOME TO NAILAURA • THE LUXURY NAIL ART STUDIO • BOOK YOUR APPOINTMENT TODAY ✨',
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                color: AppTheme.white,
                fontSize: isMobile ? 11 : 13,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.auto_awesome,
            color: AppTheme.white,
            size: 14,
          )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .scale(begin: const Offset(1.2, 1.2), end: const Offset(0.8, 0.8), duration: 1200.ms),
        ],
      ),
    );
  }
}
