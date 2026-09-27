import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../core/theme.dart';
import '../../core/utils.dart';
import '../common.dart';
import '../scroll_reveal.dart';

/// Compact portfolio grid with "view more" paging and a tap-to-enlarge lightbox.
class GallerySection extends StatefulWidget {
  const GallerySection({super.key});

  @override
  State<GallerySection> createState() => _GallerySectionState();
}

class _GallerySectionState extends State<GallerySection> {
  static const _rowsPerPage = 3;
  int _pages = 1;

  @override
  Widget build(BuildContext context) {
    final mobile = Responsive.isMobile(context);
    final columns = mobile ? 3 : (Responsive.isTablet(context) ? 4 : 5);
    final gap = mobile ? 6.0 : 12.0;
    final images = AppConstants.portfolio;
    final visible = (columns * _rowsPerPage * _pages).clamp(0, images.length);

    return Container(
      color: AppTheme.ink,
      padding: EdgeInsets.symmetric(vertical: Responsive.sectionPadding(context)),
      child: ContentWidth(
        child: Column(
          children: [
            const ScrollReveal(
              child: SectionTitle(
                script: 'Portfolio',
                eyebrow: AppConstants.instagramHandle,
                title: 'OUR LATEST WORK',
                dark: true,
              ),
            ),
            SizedBox(height: mobile ? 50 : 70),
            LayoutBuilder(
              builder: (context, c) {
                final tile = (c.maxWidth - gap * (columns - 1)) / columns;
                return Wrap(
                  spacing: gap,
                  runSpacing: gap,
                  children: [
                    for (var i = 0; i < visible; i++)
                      SizedBox(
                        width: tile,
                        child: ScrollReveal(
                          delay: Duration(milliseconds: 60 * (i % columns)),
                          child: _GalleryTile(
                            asset: images[i],
                            aspect: 0.8,
                            onTap: () => _openLightbox(context, i),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
            const SizedBox(height: 44),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 14,
              runSpacing: 14,
              children: [
                if (visible < images.length)
                  NailauraButton(
                    label: 'VIEW MORE',
                    onTap: () => setState(() => _pages++),
                  ),
                NailauraButton(
                  label: 'FOLLOW ON INSTAGRAM',
                  filled: false,
                  onTap: () => Utils.openUrl(AppConstants.instagramUrl),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _openLightbox(BuildContext context, int start) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.92),
      builder: (_) => _Lightbox(images: AppConstants.portfolio, start: start),
    );
  }
}

class _GalleryTile extends StatelessWidget {
  final String asset;
  final double aspect;
  final VoidCallback onTap;
  const _GalleryTile({required this.asset, required this.aspect, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: AspectRatio(
          aspectRatio: aspect,
          child: HoverZoomImage(
            asset: asset,
            overlay: Container(
              color: AppTheme.ink.withValues(alpha: 0.45),
              alignment: Alignment.center,
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.primaryGold),
                ),
                child: const Icon(Icons.add, color: AppTheme.primaryGold, size: 22),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Lightbox extends StatefulWidget {
  final List<String> images;
  final int start;
  const _Lightbox({required this.images, required this.start});

  @override
  State<_Lightbox> createState() => _LightboxState();
}

class _LightboxState extends State<_Lightbox> {
  late final PageController _controller = PageController(initialPage: widget.start);
  late int _page = widget.start;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _go(int delta) {
    final next = (_page + delta).clamp(0, widget.images.length - 1);
    _controller.animateToPage(
      next,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final mobile = Responsive.isMobile(context);
    return Stack(
      children: [
        PageView.builder(
          controller: _controller,
          itemCount: widget.images.length,
          onPageChanged: (p) => setState(() => _page = p),
          itemBuilder: (_, i) => Padding(
            padding: EdgeInsets.symmetric(
              horizontal: mobile ? 12 : 100,
              vertical: 70,
            ),
            child: InteractiveViewer(
              child: Image.asset(widget.images[i], fit: BoxFit.contain),
            ),
          ),
        ),
        Positioned(
          top: 20,
          right: 20,
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close, color: AppTheme.white, size: 28),
          ),
        ),
        Positioned(
          top: 30,
          left: 0,
          right: 0,
          child: IgnorePointer(
            child: Text(
              '${(_page + 1).toString().padLeft(2, '0')} / ${widget.images.length.toString().padLeft(2, '0')}',
              textAlign: TextAlign.center,
              style: AppText.eyebrow(),
            ),
          ),
        ),
        if (!mobile) ...[
          Positioned(
            left: 24,
            top: 0,
            bottom: 0,
            child: Center(
              child: IconButton(
                onPressed: () => _go(-1),
                icon: const Icon(Icons.arrow_back_ios_new, color: AppTheme.white),
              ),
            ),
          ),
          Positioned(
            right: 24,
            top: 0,
            bottom: 0,
            child: Center(
              child: IconButton(
                onPressed: () => _go(1),
                icon: const Icon(Icons.arrow_forward_ios, color: AppTheme.white),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
