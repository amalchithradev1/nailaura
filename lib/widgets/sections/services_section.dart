import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../core/theme.dart';
import '../../core/utils.dart';
import '../common.dart';
import '../scroll_reveal.dart';

class _Service {
  final String title;
  final String description;
  final String image;
  const _Service(this.title, this.description, this.image);
}

class ServicesSection extends StatelessWidget {
  const ServicesSection({super.key});

  static const _services = [
    _Service(
      'Gel Polish',
      'Long-lasting, chip-resistant colour with a high-gloss finish that stays flawless for weeks.',
      'assets/images/svc_gel_polish.jpg',
    ),
    _Service(
      'Gel Extensions',
      'Sculpted extensions shaped to your natural nail for elegant length and lasting strength.',
      'assets/images/svc_gel_extensions.jpg',
    ),
    _Service(
      'Polygel Extensions',
      'Lighter than acrylic, stronger than gel: natural-looking length with a comfortable feel.',
      AppConstants.extensionsImage,
    ),
    _Service(
      'Dry Manicure',
      'Precise waterless cuticle care for clean, healthy and naturally radiant nails.',
      AppConstants.manicureImage,
    ),
    _Service(
      'French Nails',
      'Timeless French tips, from classic white to modern chrome and colour-pop edges.',
      'assets/images/work_01.jpg',
    ),
    _Service(
      'Ombre Nails',
      'Soft, seamless colour fades, from nude-to-white baby boomer to bold gradients.',
      'assets/images/svc_ombre.jpg',
    ),
    _Service(
      'Special Polish',
      'Cat-eye, chrome, velvet and pearl finishes that catch the light from every angle.',
      'assets/images/svc_special_polish.jpg',
    ),
    _Service(
      'Nail Art',
      'Hand-painted designs, from minimal details to statement sets, made to match your style.',
      'assets/images/work_02.jpg',
    ),
  ];

  static const _care = [
    _Service(
      'Gap Filling',
      'Refill the regrowth on your extensions to restore balance, strength and a fresh look.',
      'assets/images/svc_gap_filling.jpg',
    ),
    _Service(
      'Removal',
      'Safe, gentle removal of gel and extensions that protects your natural nails.',
      'assets/images/svc_removal.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final columns = Responsive.isMobile(context)
        ? 1
        : (Responsive.isTablet(context) ? 2 : 4);

    return Container(
      color: AppTheme.ink,
      padding: EdgeInsets.symmetric(vertical: Responsive.sectionPadding(context)),
      child: ContentWidth(
        child: Column(
          children: [
            const ScrollReveal(
              child: SectionTitle(
                script: 'Menu',
                eyebrow: 'SIGNATURE TREATMENTS',
                title: 'WHAT WE CREATE',
                dark: true,
              ),
            ),
            const SizedBox(height: 70),
            LayoutBuilder(
              builder: (context, c) {
                const spacing = 24.0;
                final cardWidth = (c.maxWidth - spacing * (columns - 1)) / columns;
                return Wrap(
                  spacing: spacing,
                  runSpacing: 52,
                  children: [
                    for (var i = 0; i < _services.length; i++)
                      SizedBox(
                        width: cardWidth,
                        child: ScrollReveal(
                          delay: Duration(milliseconds: 100 * (i % columns)),
                          child: _ServiceCard(index: i + 1, service: _services[i]),
                        ),
                      ),
                  ],
                );
              },
            ),
            const SizedBox(height: 90),
            ScrollReveal(
              child: Row(
                children: [
                  Expanded(child: Container(height: 1, color: AppTheme.primaryGold.withValues(alpha: 0.3))),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text('CARE & MAINTENANCE', style: AppText.eyebrow(size: 11.5)),
                  ),
                  Expanded(child: Container(height: 1, color: AppTheme.primaryGold.withValues(alpha: 0.3))),
                ],
              ),
            ),
            const SizedBox(height: 40),
            LayoutBuilder(
              builder: (context, c) {
                final stacked = !Responsive.isDesktop(context);
                const spacing = 24.0;
                final w = stacked ? c.maxWidth : (c.maxWidth - spacing) / 2;
                return Wrap(
                  spacing: spacing,
                  runSpacing: spacing,
                  children: [
                    for (var i = 0; i < _care.length; i++)
                      SizedBox(
                        width: w,
                        child: ScrollReveal(
                          delay: Duration(milliseconds: 120 * i),
                          child: _CareCard(service: _care[i]),
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ServiceCard extends StatefulWidget {
  final int index;
  final _Service service;
  const _ServiceCard({required this.index, required this.service});

  @override
  State<_ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<_ServiceCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: () => Utils.showBookingOptions(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 0.8,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  HoverZoomImage(asset: widget.service.image),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Color(0xB30C0B0A)],
                        stops: [0.55, 1.0],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 20,
                    bottom: 14,
                    child: Text(
                      widget.index.toString().padLeft(2, '0'),
                      style: AppText.serif(
                        size: 42,
                        color: AppTheme.primaryGold,
                        style: FontStyle.italic,
                      ),
                    ),
                  ),
                  // Gold inner frame appears on hover
                  AnimatedOpacity(
                    opacity: _hover ? 1 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: Container(
                      margin: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppTheme.primaryGold, width: 1),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              widget.service.title.toUpperCase(),
              style: AppText.heading(size: 16, color: AppTheme.white),
            ),
            const SizedBox(height: 10),
            Text(
              widget.service.description,
              style: AppText.body(
                color: AppTheme.white.withValues(alpha: 0.6),
                size: 13.5,
              ),
            ),
            const SizedBox(height: 16),
            _BookLink(hover: _hover),
          ],
        ),
      ),
    );
  }
}

/// Horizontal card for maintenance services.
class _CareCard extends StatefulWidget {
  final _Service service;
  const _CareCard({required this.service});

  @override
  State<_CareCard> createState() => _CareCardState();
}

class _CareCardState extends State<_CareCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final details = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.service.title.toUpperCase(),
          style: AppText.heading(size: 16, color: AppTheme.white),
        ),
        const SizedBox(height: 8),
        Text(
          widget.service.description,
          style: AppText.body(
            color: AppTheme.white.withValues(alpha: 0.6),
            size: 13.5,
          ).copyWith(height: 1.6),
        ),
        const SizedBox(height: 12),
        _BookLink(hover: _hover),
      ],
    );

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: () => Utils.showBookingOptions(context),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.charcoal,
            border: Border.all(
              color: AppTheme.primaryGold.withValues(alpha: _hover ? 0.9 : 0.25),
            ),
          ),
          child: LayoutBuilder(
            builder: (context, c) {
              // Very narrow cards put the photo on top instead of beside the text.
              if (c.maxWidth < 380) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AspectRatio(
                      aspectRatio: 16 / 10,
                      child: HoverZoomImage(asset: widget.service.image),
                    ),
                    const SizedBox(height: 18),
                    details,
                  ],
                );
              }
              final imageSize = c.maxWidth < 520 ? 120.0 : 150.0;
              return Row(
                children: [
                  SizedBox(
                    width: imageSize,
                    height: imageSize,
                    child: HoverZoomImage(asset: widget.service.image),
                  ),
                  const SizedBox(width: 22),
                  Expanded(child: details),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _BookLink extends StatelessWidget {
  final bool hover;
  const _BookLink({required this.hover});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: hover ? 40 : 22,
          height: 1,
          color: AppTheme.primaryGold,
        ),
        const SizedBox(width: 12),
        Text('BOOK NOW', style: AppText.eyebrow(size: 10.5)),
      ],
    );
  }
}
