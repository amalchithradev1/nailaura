import 'package:flutter/material.dart';
import '../widgets/footer.dart';
import '../widgets/navbar.dart';
import '../widgets/offer_section.dart';
import '../widgets/sections/contact_section.dart';
import '../widgets/sections/gallery_section.dart';
import '../widgets/sections/hero_section.dart';
import '../widgets/sections/parallax_banner.dart';
import '../widgets/sections/services_section.dart';
import '../widgets/sections/story_section.dart';
import '../widgets/sections/team_section.dart';

class HomeScreen extends StatefulWidget {
  static const bool isOfferActive = false;

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _scrollController = ScrollController();
  bool _isScrolled = false;

  final Map<String, GlobalKey> _sectionKeys = {
    'Home': GlobalKey(),
    'Studio': GlobalKey(),
    'Services': GlobalKey(),
    'Artists': GlobalKey(),
    'Gallery': GlobalKey(),
    'Contact': GlobalKey(),
  };

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      final scrolled = _scrollController.offset > 60;
      if (scrolled != _isScrolled) setState(() => _isScrolled = scrolled);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollTo(String link) {
    final ctx = _sectionKeys[link]?.currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: MobileDrawer(onNavTap: _scrollTo),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                HeroSection(
                  key: _sectionKeys['Home'],
                  onExplore: () => _scrollTo('Studio'),
                ),
                if (HomeScreen.isOfferActive) const OfferSection(),
                StorySection(key: _sectionKeys['Studio']),
                ServicesSection(key: _sectionKeys['Services']),
                const ParallaxBanner(),
                const HighlightsSection(),
                TeamSection(key: _sectionKeys['Artists']),
                GallerySection(key: _sectionKeys['Gallery']),
                ContactSection(key: _sectionKeys['Contact']),
                Footer(onNavTap: _scrollTo),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: NavBar(
              isScrolled: _isScrolled,
              onNavTap: _scrollTo,
              onMenuTap: () => _scaffoldKey.currentState?.openEndDrawer(),
            ),
          ),
        ],
      ),
    );
  }
}
