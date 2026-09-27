import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants.dart';
import '../../core/theme.dart';
import '../../core/utils.dart';
import '../common.dart';

class _HeroSlide {
  final String image;
  final String script;
  final String title;
  const _HeroSlide(this.image, this.script, this.title);
}

class HeroSection extends StatefulWidget {
  final VoidCallback onExplore;
  const HeroSection({super.key, required this.onExplore});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> {
  static const _slides = [
    _HeroSlide(AppConstants.gelExtensionImage, 'Artistry', 'SCULPTED GEL EXTENSIONS'),
    _HeroSlide(AppConstants.nailArtImage, 'Elegance', 'BESPOKE HAND-PAINTED NAIL ART'),
    _HeroSlide(AppConstants.manicureImage, 'Your Aura', 'SIGNATURE DRY MANICURE'),
  ];

  int _index = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 6), (_) {
      if (mounted) setState(() => _index = (_index + 1) % _slides.length);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final mobile = Responsive.isMobile(context);
    final height = size.height < 640 ? 640.0 : size.height;
    final slide = _slides[_index];

    return SizedBox(
      height: height,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Crossfading background with a slow zoom
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 1400),
            child: SizedBox.expand(
              key: ValueKey(_index),
              child: Image.asset(slide.image, fit: BoxFit.cover)
                  .animate()
                  .scale(
                    begin: const Offset(1.0, 1.0),
                    end: const Offset(1.12, 1.12),
                    duration: 7.seconds,
                    curve: Curves.easeOut,
                  ),
            ),
          ),
          // Dark wash so the gold type stays readable
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xCC0C0B0A), Color(0x990C0B0A), Color(0xF20C0B0A)],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
          ),
          // Content
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Responsive.gutter(context)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                Text(
                  'KULATHOOR  •  TRIVANDRUM',
                  textAlign: TextAlign.center,
                  style: AppText.eyebrow(
                    color: AppTheme.white.withValues(alpha: 0.8),
                    size: mobile ? 10.5 : 12.5,
                  ),
                ).animate().fadeIn(duration: 900.ms).slideY(begin: 0.4),
                SizedBox(height: mobile ? 8 : 4),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 900),
                  switchInCurve: const Interval(0.5, 1.0, curve: Curves.easeOut),
                  switchOutCurve: const Interval(0.5, 1.0, curve: Curves.easeIn),
                  transitionBuilder: (child, anim) => FadeTransition(
                    opacity: anim,
                    child: SlideTransition(
                      position: Tween(begin: const Offset(0, 0.15), end: Offset.zero)
                          .animate(anim),
                      child: child,
                    ),
                  ),
                  child: Text(
                    slide.script,
                    key: ValueKey(slide.script),
                    textAlign: TextAlign.center,
                    style: AppText.script(
                      size: mobile ? 92 : (Responsive.isTablet(context) ? 150 : 190),
                    ).copyWith(
                      foreground: Paint()
                        ..shader = AppTheme.goldGradient.createShader(
                          const Rect.fromLTWH(0, 0, 600, 200),
                        ),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 900),
                  switchInCurve: const Interval(0.5, 1.0, curve: Curves.easeOut),
                  switchOutCurve: const Interval(0.5, 1.0, curve: Curves.easeIn),
                  child: Text(
                    slide.title,
                    key: ValueKey(slide.title),
                    textAlign: TextAlign.center,
                    style: AppText.heading(
                      size: mobile ? 15 : 22,
                      color: AppTheme.white,
                    ).copyWith(letterSpacing: mobile ? 4 : 8),
                  ),
                ),
                const SizedBox(height: 26),
                const ZigZagDivider(width: 72),
                const SizedBox(height: 26),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: Text(
                    'Hand-sculpted extensions, flawless manicures and bespoke nail art, crafted with care in the heart of Trivandrum.',
                    textAlign: TextAlign.center,
                    style: AppText.body(
                      color: AppTheme.white.withValues(alpha: 0.75),
                      size: mobile ? 14 : 16,
                    ),
                  ),
                ).animate().fadeIn(delay: 300.ms, duration: 900.ms),
                const SizedBox(height: 40),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 16,
                  runSpacing: 14,
                  children: [
                    NailauraButton(
                      label: 'BOOK APPOINTMENT',
                      onTap: () => Utils.showBookingOptions(context),
                    ),
                    NailauraButton(
                      label: 'EXPLORE STUDIO',
                      filled: false,
                      onTap: widget.onExplore,
                    ),
                  ],
                ).animate().fadeIn(delay: 500.ms, duration: 900.ms).slideY(begin: 0.3),
              ],
            ),
          ),
          // Slide counter
          Positioned(
            left: Responsive.gutter(context),
            bottom: 36,
            child: Row(
              children: List.generate(_slides.length, (i) {
                final active = i == _index;
                return GestureDetector(
                  onTap: () => setState(() => _index = i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    margin: const EdgeInsets.only(right: 10),
                    width: active ? 40 : 18,
                    height: 2,
                    color: active
                        ? AppTheme.primaryGold
                        : AppTheme.white.withValues(alpha: 0.35),
                  ),
                );
              }),
            ),
          ),
          // Scroll cue
          if (!mobile)
            Positioned(
              right: Responsive.gutter(context),
              bottom: 30,
              child: GestureDetector(
                onTap: widget.onExplore,
                child: Column(
                  children: [
                    RotatedBox(
                      quarterTurns: 1,
                      child: Text(
                        'SCROLL',
                        style: AppText.eyebrow(
                          color: AppTheme.white.withValues(alpha: 0.6),
                          size: 10,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(width: 1, height: 50, color: AppTheme.primaryGold)
                        .animate(onPlay: (c) => c.repeat())
                        .scaleY(begin: 0, end: 1, alignment: Alignment.topCenter, duration: 1400.ms)
                        .then()
                        .fadeOut(duration: 400.ms),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
