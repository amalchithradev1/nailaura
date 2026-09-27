import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../core/constants.dart';
import '../../core/theme.dart';
import '../../core/utils.dart';
import '../common.dart';
import '../scroll_reveal.dart';

/// Full-bleed parallax quote with a booking call to action.
class ParallaxBanner extends StatelessWidget {
  const ParallaxBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final mobile = Responsive.isMobile(context);
    return ParallaxImage(
      asset: AppConstants.studioInteriorImage,
      height: mobile ? 560 : 640,
      overlayOpacity: 0.68,
      child: ContentWidth(
        maxWidth: 820,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const ScrollReveal(
              child: SectionTitle(
                script: 'Beauty',
                eyebrow: 'LUXURY IN EVERY DETAIL',
                title: 'YOUR HANDS DESERVE\nA LITTLE ART',
                dark: true,
              ),
            ),
            const SizedBox(height: 30),
            ScrollReveal(
              delay: const Duration(milliseconds: 150),
              child: Text(
                'Sit back in a calm, private studio while we take care of every detail, from shaping and cuticle care to the final glossy top coat.',
                textAlign: TextAlign.center,
                style: AppText.body(color: AppTheme.white.withValues(alpha: 0.75)),
              ),
            ),
            const SizedBox(height: 36),
            NailauraButton(
              label: 'RESERVE YOUR SEAT',
              onTap: () => Utils.showBookingOptions(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _Highlight {
  final int value;
  final String suffix;
  final String label;
  const _Highlight(this.value, this.suffix, this.label);
}

/// Animated count-up promises strip.
class HighlightsSection extends StatelessWidget {
  const HighlightsSection({super.key});

  static const _items = [
    _Highlight(15, '', 'DAY SERVICE\nWARRANTY'),
    _Highlight(100, '%', 'STERILISED\nTOOLS'),
    _Highlight(6, '', 'DAYS OPEN\nEVERY WEEK'),
    _Highlight(1, ':1', 'PERSONAL ARTIST\nATTENTION'),
  ];

  @override
  Widget build(BuildContext context) {
    final columns = Responsive.isMobile(context) ? 2 : 4;
    return Container(
      color: AppTheme.white,
      padding: EdgeInsets.symmetric(vertical: Responsive.isMobile(context) ? 70 : 100),
      child: ContentWidth(
        child: LayoutBuilder(
          builder: (context, c) {
            final w = c.maxWidth / columns;
            return Wrap(
              runSpacing: 48,
              children: [
                for (final item in _items)
                  SizedBox(width: w, child: _Counter(item: item)),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Counter extends StatefulWidget {
  final _Highlight item;
  const _Counter({required this.item});

  @override
  State<_Counter> createState() => _CounterState();
}

class _CounterState extends State<_Counter> {
  bool _started = false;

  @override
  Widget build(BuildContext context) {
    final mobile = Responsive.isMobile(context);
    return VisibilityDetector(
      key: ValueKey('counter-${widget.item.label}'),
      onVisibilityChanged: (info) {
        if (!_started && info.visibleFraction > 0.4 && mounted) {
          setState(() => _started = true);
        }
      },
      child: Column(
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: _started ? widget.item.value.toDouble() : 0),
            duration: const Duration(milliseconds: 1600),
            curve: Curves.easeOutCubic,
            builder: (context, v, _) => Text(
              '${v.round()}${widget.item.suffix}',
              style: AppText.serif(
                size: mobile ? 52 : 68,
                color: AppTheme.primaryGold,
              ).copyWith(fontWeight: FontWeight.w400),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            widget.item.label,
            textAlign: TextAlign.center,
            style: AppText.eyebrow(
              color: AppTheme.textDark,
              size: mobile ? 10 : 11,
            ).copyWith(height: 1.7, letterSpacing: 3),
          ),
        ],
      ),
    );
  }
}
