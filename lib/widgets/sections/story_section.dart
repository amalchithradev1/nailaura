import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../core/theme.dart';
import '../../core/utils.dart';
import '../common.dart';
import '../scroll_reveal.dart';

/// "Our Story" intro with stacked imagery.
class StorySection extends StatelessWidget {
  const StorySection({super.key});

  @override
  Widget build(BuildContext context) {
    final desktop = Responsive.isDesktop(context);
    final mobile = Responsive.isMobile(context);

    final images = SizedBox(
      height: mobile ? 420 : 580,
      child: LayoutBuilder(
        builder: (context, c) {
          final w = c.maxWidth;
          return Stack(
            clipBehavior: Clip.none,
            children: [
              // Gold frame offset behind the main image
              Positioned(
                left: w * 0.06,
                top: 28,
                width: w * 0.62,
                bottom: mobile ? 60 : 90,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppTheme.primaryGold, width: 1),
                  ),
                ),
              ),
              Positioned(
                left: w * 0.1,
                top: 0,
                width: w * 0.6,
                bottom: mobile ? 90 : 120,
                child: const HoverZoomImage(asset: AppConstants.studioBannerImage),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                width: w * 0.44,
                height: mobile ? 220 : 300,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppTheme.ivory, width: 8),
                  ),
                  child: HoverZoomImage(asset: AppConstants.portfolio[0]),
                ),
              ),
            ],
          );
        },
      ),
    );

    final copy = Column(
      crossAxisAlignment: desktop ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        SectionTitle(
          script: 'Story',
          eyebrow: 'KULATHOOR  •  TRIVANDRUM',
          title: 'CRAFTED BY HAND,\nWORN WITH CONFIDENCE',
          center: !desktop,
        ),
        const SizedBox(height: 32),
        Text(
          'Nailaura began with a simple belief: your nails should feel as good as they look. '
          'Our studio blends precise technique with an artist\'s eye, so every set is shaped around your natural nail, your lifestyle and your style.',
          textAlign: desktop ? TextAlign.left : TextAlign.center,
          style: AppText.body(),
        ),
        const SizedBox(height: 18),
        Text(
          'From sculpted gel extensions to minimal hand-painted details, we use premium, non-toxic products and sterilised tools for every appointment.',
          textAlign: desktop ? TextAlign.left : TextAlign.center,
          style: AppText.body(),
        ),
        const SizedBox(height: 28),
        Text(
          'Amal & Aswathy',
          style: AppText.script(size: 44, color: AppTheme.textDark),
        ),
        const SizedBox(height: 32),
        NailauraButton(
          label: 'BOOK YOUR VISIT',
          onDark: false,
          onTap: () => Utils.showBookingOptions(context),
        ),
      ],
    );

    return Container(
      color: AppTheme.ivory,
      padding: EdgeInsets.symmetric(vertical: Responsive.sectionPadding(context)),
      child: ContentWidth(
        child: desktop
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(child: ScrollReveal(child: images)),
                  const SizedBox(width: 90),
                  Expanded(child: ScrollReveal(delay: 150.ms, child: copy)),
                ],
              )
            : Column(
                children: [
                  ScrollReveal(child: copy),
                  const SizedBox(height: 70),
                  ScrollReveal(child: images),
                ],
              ),
      ),
    );
  }
}

extension on int {
  Duration get ms => Duration(milliseconds: this);
}
