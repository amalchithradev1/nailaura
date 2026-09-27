import 'package:flutter/material.dart';
import '../core/theme.dart';

/// Centers content with the page gutter and a max width.
class ContentWidth extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  const ContentWidth({super.key, required this.child, this.maxWidth = 1240});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Responsive.gutter(context)),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: child,
        ),
      ),
    );
  }
}

/// Script accent word layered behind an eyebrow label and uppercase heading.
class SectionTitle extends StatelessWidget {
  final String script;
  final String eyebrow;
  final String title;
  final bool dark;
  final bool center;

  const SectionTitle({
    super.key,
    required this.script,
    required this.eyebrow,
    required this.title,
    this.dark = false,
    this.center = true,
  });

  @override
  Widget build(BuildContext context) {
    final mobile = Responsive.isMobile(context);
    final scriptSize = mobile ? 78.0 : 120.0;
    final align = center ? CrossAxisAlignment.center : CrossAxisAlignment.start;
    final textAlign = center ? TextAlign.center : TextAlign.left;

    return Stack(
      clipBehavior: Clip.none,
      alignment: center ? Alignment.topCenter : Alignment.topLeft,
      children: [
        Text(
          script,
          textAlign: textAlign,
          style: AppText.script(
            size: scriptSize,
            color: AppTheme.primaryGold.withValues(alpha: dark ? 0.85 : 0.75),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: scriptSize * 0.95),
          child: Column(
            crossAxisAlignment: align,
            children: [
              Text(
                eyebrow,
                textAlign: textAlign,
                style: AppText.eyebrow(
                  color: dark
                      ? AppTheme.white.withValues(alpha: 0.75)
                      : AppTheme.textDark.withValues(alpha: 0.6),
                  size: mobile ? 10.5 : 12,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                title,
                textAlign: textAlign,
                style: AppText.heading(
                  size: mobile ? 24 : 36,
                  color: dark ? AppTheme.white : AppTheme.textDark,
                ),
              ),
              const SizedBox(height: 22),
              const ZigZagDivider(),
            ],
          ),
        ),
      ],
    );
  }
}

/// Thin gold zig-zag separator.
class ZigZagDivider extends StatelessWidget {
  final double width;
  final Color color;
  const ZigZagDivider({
    super.key,
    this.width = 64,
    this.color = AppTheme.primaryGold,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width, 10),
      painter: _ZigZagPainter(color),
    );
  }
}

class _ZigZagPainter extends CustomPainter {
  final Color color;
  _ZigZagPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    const peaks = 4;
    final step = size.width / (peaks * 2);
    final path = Path()..moveTo(0, size.height);
    for (var i = 1; i <= peaks * 2; i++) {
      path.lineTo(step * i, i.isOdd ? 0 : size.height);
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4
        ..strokeJoin = StrokeJoin.miter,
    );
  }

  @override
  bool shouldRepaint(_ZigZagPainter old) => old.color != color;
}

/// Square editorial button. [filled] = gold, otherwise outlined.
class NailauraButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final bool filled;
  final bool onDark;
  final IconData? icon;

  const NailauraButton({
    super.key,
    required this.label,
    required this.onTap,
    this.filled = true,
    this.onDark = true,
    this.icon,
  });

  @override
  State<NailauraButton> createState() => _NailauraButtonState();
}

class _NailauraButtonState extends State<NailauraButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final outlineColor = widget.onDark ? AppTheme.white : AppTheme.textDark;
    final Color bg = widget.filled
        ? (_hover ? AppTheme.goldLight : AppTheme.primaryGold)
        : (_hover ? AppTheme.primaryGold : Colors.transparent);
    final Color fg = widget.filled
        ? AppTheme.ink
        : (_hover ? AppTheme.ink : outlineColor);
    final Color border = widget.filled || _hover
        ? AppTheme.primaryGold
        : outlineColor.withValues(alpha: 0.7);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
          decoration: BoxDecoration(
            color: bg,
            border: Border.all(color: border, width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, size: 16, color: fg),
                const SizedBox(width: 10),
              ],
              Text(
                widget.label,
                style: AppText.eyebrow(color: fg, size: 11.5)
                    .copyWith(letterSpacing: 3.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Background image that drifts slower than the page while scrolling.
/// Must be placed inside a Scrollable.
class ParallaxImage extends StatelessWidget {
  final String asset;
  final double height;
  final Widget? child;
  final double overlayOpacity;

  ParallaxImage({
    super.key,
    required this.asset,
    required this.height,
    this.child,
    this.overlayOpacity = 0.6,
  });

  final GlobalKey _imageKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: ClipRect(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Builder(
              builder: (itemContext) => Flow(
                delegate: _ParallaxFlowDelegate(
                  scrollable: Scrollable.of(itemContext),
                  itemContext: itemContext,
                  imageKey: _imageKey,
                ),
                children: [
                  Image.asset(asset, key: _imageKey, fit: BoxFit.cover),
                ],
              ),
            ),
            ColoredBox(
              color: AppTheme.ink.withValues(alpha: overlayOpacity),
            ),
            if (child != null) child!,
          ],
        ),
      ),
    );
  }
}

class _ParallaxFlowDelegate extends FlowDelegate {
  final ScrollableState scrollable;
  final BuildContext itemContext;
  final GlobalKey imageKey;

  _ParallaxFlowDelegate({
    required this.scrollable,
    required this.itemContext,
    required this.imageKey,
  }) : super(repaint: scrollable.position);

  @override
  BoxConstraints getConstraintsForChild(int i, BoxConstraints constraints) {
    return BoxConstraints.tightFor(
      width: constraints.maxWidth,
      height: constraints.maxHeight * 1.4,
    );
  }

  @override
  void paintChildren(FlowPaintingContext context) {
    final scrollBox = scrollable.context.findRenderObject() as RenderBox;
    final itemBox = itemContext.findRenderObject() as RenderBox;
    final itemOffset = itemBox.localToGlobal(
      itemBox.size.centerLeft(Offset.zero),
      ancestor: scrollBox,
    );
    final viewport = scrollable.position.viewportDimension;
    final fraction = (itemOffset.dy / viewport).clamp(0.0, 1.0);
    final alignment = Alignment(0.0, fraction * 2 - 1);
    final imageBox = imageKey.currentContext?.findRenderObject() as RenderBox?;
    if (imageBox == null || !imageBox.hasSize) {
      context.paintChild(0);
      return;
    }
    final rect = alignment.inscribe(imageBox.size, Offset.zero & context.size);
    context.paintChild(
      0,
      transform: Transform.translate(offset: Offset(0.0, rect.top)).transform,
    );
  }

  @override
  bool shouldRepaint(_ParallaxFlowDelegate old) =>
      scrollable != old.scrollable ||
      itemContext != old.itemContext ||
      imageKey != old.imageKey;
}

/// Image that slowly zooms on hover.
class HoverZoomImage extends StatefulWidget {
  final String asset;
  final Widget? overlay;
  final Alignment alignment;
  const HoverZoomImage({
    super.key,
    required this.asset,
    this.overlay,
    this.alignment = Alignment.center,
  });

  @override
  State<HoverZoomImage> createState() => _HoverZoomImageState();
}

class _HoverZoomImageState extends State<HoverZoomImage> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: ClipRect(
        child: Stack(
          fit: StackFit.expand,
          children: [
            AnimatedScale(
              scale: _hover ? 1.07 : 1.0,
              duration: const Duration(milliseconds: 900),
              curve: Curves.easeOutCubic,
              child: Image.asset(
                widget.asset,
                fit: BoxFit.cover,
                alignment: widget.alignment,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            if (widget.overlay != null)
              AnimatedOpacity(
                opacity: _hover ? 1 : 0,
                duration: const Duration(milliseconds: 300),
                child: widget.overlay,
              ),
          ],
        ),
      ),
    );
  }
}
