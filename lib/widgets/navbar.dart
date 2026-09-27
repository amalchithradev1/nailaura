import 'dart:ui';
import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../core/theme.dart';
import '../core/utils.dart';
import 'common.dart';

/// Fixed top bar: transparent over the hero, solid black once scrolled.
class NavBar extends StatelessWidget {
  final bool isScrolled;
  final void Function(String link) onNavTap;
  final VoidCallback onMenuTap;

  const NavBar({
    super.key,
    required this.isScrolled,
    required this.onNavTap,
    required this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 1000;
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: isScrolled ? 14 : 0,
          sigmaY: isScrolled ? 14 : 0,
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          height: isScrolled ? 70 : 92,
          padding: EdgeInsets.symmetric(horizontal: Responsive.gutter(context)),
          decoration: BoxDecoration(
            color: isScrolled
                ? AppTheme.ink.withValues(alpha: 0.92)
                : Colors.transparent,
            border: Border(
              bottom: BorderSide(
                color: AppTheme.primaryGold.withValues(alpha: isScrolled ? 0.25 : 0),
              ),
            ),
          ),
          child: Row(
            children: [
              _Logo(compact: isScrolled, onTap: () => onNavTap('Home')),
              const Spacer(),
              if (!compact) ...[
                for (final link in AppConstants.navLinks)
                  _NavLink(label: link, onTap: () => onNavTap(link)),
                const SizedBox(width: 24),
                NailauraButton(
                  label: 'BOOK NOW',
                  onTap: () => Utils.showBookingOptions(context),
                ),
              ] else
                IconButton(
                  onPressed: onMenuTap,
                  icon: const Icon(Icons.menu, color: AppTheme.white, size: 28),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  final bool compact;
  final VoidCallback onTap;
  const _Logo({required this.compact, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 350),
              height: compact ? 38 : 46,
              child: Image.asset(AppConstants.logoIcon, fit: BoxFit.contain),
            ),
            const SizedBox(width: 12),
            AnimatedContainer(
              duration: const Duration(milliseconds: 350),
              height: compact ? 32 : 40,
              child: Image.asset(AppConstants.logoTextGold, fit: BoxFit.contain),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavLink extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _NavLink({required this.label, required this.onTap});

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.label.toUpperCase(),
                style: AppText.eyebrow(
                  color: _hover ? AppTheme.primaryGold : AppTheme.white,
                  size: 11.5,
                ).copyWith(letterSpacing: 2.5),
              ),
              const SizedBox(height: 6),
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: _hover ? 22 : 0,
                height: 1,
                color: AppTheme.primaryGold,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Full-height menu for phones and tablets.
class MobileDrawer extends StatelessWidget {
  final void Function(String link) onNavTap;
  const MobileDrawer({super.key, required this.onNavTap});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppTheme.ink,
      shape: const RoundedRectangleBorder(),
      width: MediaQuery.sizeOf(context).width < 500
          ? MediaQuery.sizeOf(context).width
          : 420,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(AppConstants.logoIcon, height: 40),
                  const SizedBox(width: 10),
                  Image.asset(AppConstants.logoTextGold, height: 34),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: AppTheme.white, size: 28),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              Expanded(
                child: ListView(
                  children: [
                    for (var i = 0; i < AppConstants.navLinks.length; i++)
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          onNavTap(AppConstants.navLinks[i]);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          child: Row(
                            children: [
                              Text(
                                '0${i + 1}',
                                style: AppText.serif(
                                  size: 18,
                                  color: AppTheme.primaryGold,
                                  style: FontStyle.italic,
                                ),
                              ),
                              const SizedBox(width: 20),
                              Text(
                                AppConstants.navLinks[i].toUpperCase(),
                                style: AppText.heading(size: 20, color: AppTheme.white)
                                    .copyWith(letterSpacing: 5),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Text('Book your visit', style: AppText.script(size: 40)),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: NailauraButton(
                  label: 'BOOK APPOINTMENT',
                  onTap: () {
                    Navigator.pop(context);
                    Utils.showBookingOptions(context);
                  },
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'TUE – SUN  •  10 AM – 7 PM',
                style: AppText.eyebrow(
                  color: AppTheme.white.withValues(alpha: 0.5),
                  size: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
