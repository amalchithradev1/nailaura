import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../core/theme.dart';
import '../../core/utils.dart';
import '../common.dart';
import '../scroll_reveal.dart';

/// Visit us: contact details, working hours and directions.
class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    final desktop = Responsive.isDesktop(context);

    final columns = <Widget>[
      _Column(
        title: 'CONTACT',
        children: [
          _Line(icon: Icons.location_on_outlined, text: AppConstants.address,
              onTap: () => Utils.openUrl(AppConstants.mapsUrl)),
          _Line(icon: Icons.phone_outlined, text: AppConstants.phoneDisplay,
              onTap: Utils.launchPhone),
          _Line(icon: Icons.mail_outline, text: AppConstants.email,
              onTap: Utils.launchEmail),
        ],
      ),
      _Column(
        title: 'WORKING HOURS',
        children: const [
          _Hours(day: 'Open all 7 days', time: '10:00 AM – 10:00 PM'),
          SizedBox(height: 8),
        ],
      ),
      _Column(
        title: 'BOOK & FIND US',
        children: [
          Text(
            'Message us on WhatsApp for the fastest booking, or open directions to the studio.',
            style: AppText.body(size: 14),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              NailauraButton(
                label: 'WHATSAPP',
                icon: Icons.chat_bubble_outline,
                onTap: Utils.launchWhatsApp,
              ),
              NailauraButton(
                label: 'DIRECTIONS',
                icon: Icons.near_me_outlined,
                filled: false,
                onDark: false,
                onTap: () => Utils.openUrl(AppConstants.mapsUrl),
              ),
            ],
          ),
        ],
      ),
    ];

    return Container(
      color: AppTheme.white,
      padding: EdgeInsets.symmetric(vertical: Responsive.sectionPadding(context)),
      child: ContentWidth(
        child: Column(
          children: [
            const ScrollReveal(
              child: SectionTitle(
                script: 'Visit',
                eyebrow: 'WE CAN\'T WAIT TO SEE YOU',
                title: 'THE STUDIO',
              ),
            ),
            const SizedBox(height: 80),
            ScrollReveal(
              child: desktop
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (var i = 0; i < columns.length; i++) ...[
                          if (i > 0)
                            Container(
                              width: 1,
                              height: 190,
                              margin: const EdgeInsets.symmetric(horizontal: 50),
                              color: AppTheme.primaryGold.withValues(alpha: 0.35),
                            ),
                          Expanded(child: columns[i]),
                        ],
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (var i = 0; i < columns.length; i++) ...[
                          if (i > 0) const SizedBox(height: 56),
                          columns[i],
                        ],
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Column extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _Column({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppText.eyebrow(color: AppTheme.textDark, size: 13)),
        const SizedBox(height: 12),
        Container(width: 30, height: 1, color: AppTheme.primaryGold),
        const SizedBox(height: 26),
        ...children,
      ],
    );
  }
}

class _Line extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;
  const _Line({required this.icon, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: InkWell(
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 18, color: AppTheme.primaryGold),
            const SizedBox(width: 14),
            Expanded(child: Text(text, style: AppText.body(size: 14.5).copyWith(height: 1.6))),
          ],
        ),
      ),
    );
  }
}

class _Hours extends StatelessWidget {
  final String day;
  final String time;
  const _Hours({required this.day, required this.time});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppTheme.textDark.withValues(alpha: 0.1)),
        ),
      ),
      child: Row(
        children: [
          Expanded(child: Text(day, style: AppText.body(size: 14.5, color: AppTheme.textDark))),
          Text(
            time,
            style: AppText.body(
              size: 14.5,
              color: time == 'Closed' ? AppTheme.primaryGold : AppTheme.textDark.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}
