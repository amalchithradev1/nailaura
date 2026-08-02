import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/constants.dart';
import '../core/theme.dart';
import '../core/utils.dart';
import '../widgets/navbar.dart';
import '../widgets/footer.dart';
import '../widgets/hero_slider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ScrollController _scrollController;
  bool _isScrolled = false;

  final GlobalKey _homeKey = GlobalKey();
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _servicesKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.offset > 50 && !_isScrolled) {
      setState(() {
        _isScrolled = true;
      });
    } else if (_scrollController.offset <= 50 && _isScrolled) {
      setState(() {
        _isScrolled = false;
      });
    }
  }

  void _scrollToSection(String link) {
    GlobalKey? key;
    switch (link) {
      case 'Home':
        key = _homeKey;
        break;
      case 'About':
      case 'About Us':
        key = _aboutKey;
        break;
      case 'Services':
        key = _servicesKey;
        break;
      case 'Contact':
        key = _contactKey;
        break;
    }
    if (key != null && key.currentContext != null) {
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
        // Optional: offset if you want it to stop below the navbar
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MobileDrawer(onNavTap: _scrollToSection),
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    SizedBox(
                      key: _homeKey,
                      height: MediaQuery.of(context).size.width > 800 ? 70 : 60,
                    ),
                    Container(child: const HeroSlider()),
                    Container(
                      key: _servicesKey,
                      child: _buildServicesSection(context),
                    ),
                    Container(
                      key: _aboutKey,
                      child: _buildWhyChooseUs(context),
                    ),
                    _buildGalleryPlaceholder(context),
                    Container(key: _contactKey, child: const Footer()),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: NavBar(isScrolled: _isScrolled, onNavTap: _scrollToSection),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesSection(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth <= 800;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 64,
        vertical: 100,
      ),
      color: AppTheme.backgroundCream,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Signature Treatments',
            style: GoogleFonts.cormorantGaramond(
              color: AppTheme.textDark,
              fontSize: isMobile ? 38 : 52,
              fontWeight: FontWeight.w400,
            ),
          ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.2),
          const SizedBox(height: 56),
          Builder(
            builder: (context) {
              double desktopCardWidth =
                  (screenWidth - 128 - 64) / 3; // 3 columns max
              if (desktopCardWidth < 300) desktopCardWidth = 300;
              final double cardWidth = isMobile
                  ? double.infinity
                  : desktopCardWidth;

              Widget buildCard(
                  String title, String price, String desc, String img) {
                return SizedBox(
                  width: cardWidth,
                  child: HoverServiceCard(
                    title: title,
                    price: price,
                    description: desc,
                    imagePath: img,
                  ),
                );
              }

              return Wrap(
                spacing: 32,
                runSpacing: 48,
                alignment: WrapAlignment.start,
                children: [
                  buildCard(
                    'Nail Art',
                    '\$45.00',
                    'Express your unique style with intricate, hand-painted minimal designs.',
                    AppConstants.nailArtImage,
                  ),
                  buildCard(
                    'Dry Manicure',
                    '\$50.00',
                    'A timeless finish for healthy, naturally glowing nails and pristine cuticles.',
                    AppConstants.manicureImage,
                  ),
                  buildCard(
                    'Gap Filling',
                    '\$40.00',
                    'Precision acrylic and gel maintenance to restore strength, structure, and flawless look.',
                    AppConstants.gapFillingImage,
                  ),
                  buildCard(
                    'Nail Strengthening',
                    '\$35.00',
                    'Intensive keratin and botanical infusion to restore damaged, brittle nails to full health.',
                    AppConstants.strengtheningImage,
                  ),
                  buildCard(
                    'Soft Gel Extension',
                    '\$75.00',
                    'Sculpted to absolute perfection with lightweight, natural-looking gel for incredible length.',
                    AppConstants.cuticleCareImage,
                  ),
                  buildCard(
                    'Poly Gel Extension',
                    '\$85.00',
                    'The best of both worlds: lighter than acrylics, stronger than hard gel for flawless structure.',
                    AppConstants.gelExtensionImage,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWhyChooseUs(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth <= 800;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 80,
        vertical: 100,
      ),
      color: const Color(0xFFF7F4EE),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'THE EXPERIENCE',
                      style: GoogleFonts.montserrat(
                        color: AppTheme.primaryGold,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 3.0,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Why Choose Nailaura',
                      style: GoogleFonts.cormorantGaramond(
                        color: AppTheme.textDark,
                        fontSize: 40,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Our studio combines luxury, hygiene, and art. We use industry-leading, non-toxic products to ensure your nails remain healthy, vibrant, and flawlessly styled.',
                      style: GoogleFonts.montserrat(
                        color: AppTheme.textDark.withOpacity(0.75),
                        fontSize: 14,
                        height: 1.6,
                      ),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'THE EXPERIENCE',
                          style: GoogleFonts.montserrat(
                            color: AppTheme.primaryGold,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 3.0,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Why Choose Nailaura',
                          style: GoogleFonts.cormorantGaramond(
                            color: AppTheme.textDark,
                            fontSize: 52,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 420,
                      child: Text(
                        'Our studio combines luxury, hygiene, and art. We use industry-leading, non-toxic products to ensure your nails remain healthy, vibrant, and flawlessly styled.',
                        style: GoogleFonts.montserrat(
                          color: AppTheme.textDark.withOpacity(0.75),
                          fontSize: 14,
                          height: 1.6,
                        ),
                      ),
                    ),
                  ],
                ),
          const SizedBox(height: 36),
          Container(
            height: 1,
            width: double.infinity,
            color: AppTheme.primaryGold.withOpacity(0.3),
          ),
          const SizedBox(height: 50),
          Wrap(
            spacing: 32,
            runSpacing: 32,
            alignment: WrapAlignment.start,
            children: [
              HoverFeatureItem(
                number: '01',
                title: 'Premium Products',
                icon: Icons.diamond_outlined,
                desc:
                    'We use industry-leading, non-toxic products to ensure healthy, vibrant nails.',
              ),
              HoverFeatureItem(
                number: '02',
                title: 'Expert Artists',
                icon: Icons.brush_outlined,
                desc:
                    'Our licensed technicians are trained in the latest nail art techniques.',
              ),
              HoverFeatureItem(
                number: '03',
                title: 'Ultimate Hygiene',
                icon: Icons.clean_hands_outlined,
                desc:
                    'Strict sterilization protocols for a safe, worry-free pampering session.',
              ),
              HoverFeatureItem(
                number: '04',
                title: 'Relaxing Vibe',
                icon: Icons.spa_outlined,
                desc:
                    'A serene environment designed for you to unwind and relax completely.',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGalleryPlaceholder(BuildContext context) {
    return const MarqueeGallery();
  }
}

// --- New Premium Widgets ---

class HoverServiceCard extends StatefulWidget {
  final String title;
  final String price;
  final String description;
  final String imagePath;
  const HoverServiceCard({
    Key? key,
    required this.title,
    required this.price,
    required this.description,
    required this.imagePath,
  }) : super(key: key);

  @override
  State<HoverServiceCard> createState() => _HoverServiceCardState();
}

class _HoverServiceCardState extends State<HoverServiceCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        transform: Matrix4.identity()..translate(0.0, _isHovered ? -6.0 : 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Photo (Clean rectangle with hover zoom)
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: AspectRatio(
                aspectRatio: 0.95,
                child: AnimatedScale(
                  scale: _isHovered ? 1.05 : 1.0,
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeOutCubic,
                  child: Image.asset(
                    widget.imagePath,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // 2. Service Title
            Text(
              widget.title,
              style: GoogleFonts.cormorantGaramond(
                color: AppTheme.textDark,
                fontSize: 26,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 4),
            // 3. Price Tag
            Text(
              widget.price,
              style: GoogleFonts.montserrat(
                color: AppTheme.textDark.withOpacity(0.75),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 14),
            // 4. Description
            Text(
              widget.description,
              style: GoogleFonts.montserrat(
                color: AppTheme.textDark.withOpacity(0.85),
                fontSize: 14,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 24),
            // 5. Full-Width Solid Black Pill Button
            InkWell(
              onTap: () {
                Utils.showBookingOptions(context);
              },
              borderRadius: BorderRadius.circular(30),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: _isHovered ? AppTheme.primaryGold : AppTheme.textDark,
                  borderRadius: BorderRadius.circular(30),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Book appointment',
                  style: GoogleFonts.montserrat(
                    color: _isHovered ? AppTheme.textDark : AppTheme.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.1),
    );
  }
}

class HoverFeatureItem extends StatefulWidget {
  final String number;
  final String title;
  final IconData icon;
  final String desc;
  const HoverFeatureItem({
    Key? key,
    required this.number,
    required this.title,
    required this.icon,
    required this.desc,
  }) : super(key: key);

  @override
  State<HoverFeatureItem> createState() => _HoverFeatureItemState();
}

class _HoverFeatureItemState extends State<HoverFeatureItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 270,
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: _isHovered ? const Color(0xFF161514) : const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _isHovered
                ? AppTheme.primaryGold
                : AppTheme.primaryGold.withOpacity(0.25),
            width: 1,
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: AppTheme.primaryGold.withOpacity(0.12),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  widget.icon,
                  color: AppTheme.primaryGold,
                  size: 28,
                ),
                Text(
                  widget.number,
                  style: GoogleFonts.cormorantGaramond(
                    color: AppTheme.primaryGold,
                    fontSize: 24,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            Text(
              widget.title,
              style: GoogleFonts.cormorantGaramond(
                color: _isHovered ? AppTheme.white : AppTheme.textDark,
                fontWeight: FontWeight.w600,
                fontSize: 26,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              widget.desc,
              style: GoogleFonts.montserrat(
                color: _isHovered
                    ? AppTheme.white.withOpacity(0.8)
                    : AppTheme.textDark.withOpacity(0.75),
                fontSize: 13.5,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 28),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              child: Row(
                children: [
                  Container(
                    width: _isHovered ? 24 : 16,
                    height: 1,
                    color: AppTheme.primaryGold,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Discover',
                    style: GoogleFonts.montserrat(
                      color: AppTheme.primaryGold,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.1),
    );
  }
}

class MarqueeGallery extends StatefulWidget {
  const MarqueeGallery({Key? key}) : super(key: key);

  @override
  State<MarqueeGallery> createState() => _MarqueeGalleryState();
}

class _MarqueeGalleryState extends State<MarqueeGallery> {
  late ScrollController _scrollController;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startMarquee();
    });
  }

  void _startMarquee() {
    _timer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      if (_scrollController.hasClients) {
        double maxScroll = _scrollController.position.maxScrollExtent;
        double currentScroll = _scrollController.position.pixels;
        double delta = 1.0;
        if (maxScroll - currentScroll <= delta) {
          _scrollController.jumpTo(0.0);
        } else {
          _scrollController.jumpTo(currentScroll + delta);
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth <= 800;

    // Use multiple images to create a long scrolling list
    final List<String> images = [
      AppConstants.gelExtensionImage,
      AppConstants.manicureImage,
      AppConstants.gelImage,
      AppConstants.extensionsImage,
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 100),
      color: const Color(0xFF161514),
      child: Column(
        children: [
          Text(
            'INSTAGRAM PORTFOLIO',
            style: GoogleFonts.montserrat(
              color: AppTheme.primaryGold,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 3.0,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Follow Us @nailauraofficial_',
            style: GoogleFonts.cormorantGaramond(
              color: AppTheme.white,
              fontSize: isMobile ? 36 : 48,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 48),
          SizedBox(
            height: 360,
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              // Intentionally large number to simulate infinite loop
              itemCount: 1000,
              physics:
                  const NeverScrollableScrollPhysics(), // User shouldn't scroll it manually
              itemBuilder: (context, index) {
                final imagePath = images[index % images.length];
                return Container(
                  width: 280,
                  margin: const EdgeInsets.only(right: 24, left: 0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.primaryGold.withOpacity(0.3),
                      width: 1,
                    ),
                    image: DecorationImage(
                      image: AssetImage(imagePath),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
