import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../core/theme.dart';
import '../core/utils.dart';
import 'common.dart';

class Footer extends StatelessWidget {
  final void Function(String link) onNavTap;
  const Footer({super.key, required this.onNavTap});

  @override
  Widget build(BuildContext context) {
    final mobile = Responsive.isMobile(context);
    return Container(
      color: AppTheme.ink,
      padding: EdgeInsets.only(top: mobile ? 80 : 110, bottom: 36),
      child: ContentWidth(
        child: Column(
          children: [
            Image.asset(AppConstants.logoIcon, height: mobile ? 64 : 80),
            const SizedBox(height: 16),
            Image.asset(AppConstants.logoTextGold, height: mobile ? 40 : 52),
            const SizedBox(height: 28),
            const ZigZagDivider(),
            const SizedBox(height: 28),
            Text(
              'Where every nail tells a story',
              textAlign: TextAlign.center,
              style: AppText.script(size: mobile ? 36 : 46),
            ),
            const SizedBox(height: 44),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: mobile ? 22 : 40,
              runSpacing: 16,
              children: [
                for (final link in AppConstants.navLinks)
                  _FooterLink(label: link.toUpperCase(), onTap: () => onNavTap(link)),
              ],
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _Social(
                  icon: Icons.camera_alt_outlined,
                  tooltip: 'Instagram',
                  onTap: () => Utils.openUrl(AppConstants.instagramUrl),
                ),
                const SizedBox(width: 14),
                const _Social(
                  icon: Icons.chat_bubble_outline,
                  tooltip: 'WhatsApp',
                  onTap: Utils.launchWhatsApp,
                ),
                const SizedBox(width: 14),
                const _Social(
                  icon: Icons.phone_outlined,
                  tooltip: 'Call',
                  onTap: Utils.launchPhone,
                ),
                const SizedBox(width: 14),
                const _Social(
                  icon: Icons.mail_outline,
                  tooltip: 'Email',
                  onTap: Utils.launchEmail,
                ),
              ],
            ),
            const SizedBox(height: 60),
            Container(height: 1, color: AppTheme.white.withValues(alpha: 0.08)),
            const SizedBox(height: 26),
            Text(
              '© ${DateTime.now().year} NAILAURA  •  THE NAILART STUDIO  •  TRIVANDRUM',
              textAlign: TextAlign.center,
              style: AppText.eyebrow(
                color: AppTheme.white.withValues(alpha: 0.4),
                size: 10,
              ).copyWith(letterSpacing: 2.5, height: 1.8),
            ),
          ],
        ),
      ),
    );
  }
}

class _FooterLink extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _FooterLink({required this.label, required this.onTap});

  @override
  State<_FooterLink> createState() => _FooterLinkState();
}

class _FooterLinkState extends State<_FooterLink> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Text(
          widget.label,
          style: AppText.eyebrow(
            color: _hover ? AppTheme.primaryGold : AppTheme.white.withValues(alpha: 0.75),
            size: 11,
          ),
        ),
      ),
    );
  }
}

class _Social extends StatefulWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  const _Social({required this.icon, required this.tooltip, required this.onTap});

  @override
  State<_Social> createState() => _SocialState();
}

class _SocialState extends State<_Social> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _hover ? AppTheme.primaryGold : Colors.transparent,
              border: Border.all(color: AppTheme.primaryGold.withValues(alpha: 0.6)),
            ),
            child: Icon(
              widget.icon,
              size: 18,
              color: _hover ? AppTheme.ink : AppTheme.primaryGold,
            ),
          ),
        ),
      ),
    );
  }
}
