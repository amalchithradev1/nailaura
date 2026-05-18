import 'dart:async';
import 'dart:ui' as ui;
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
                      height: MediaQuery.of(context).size.width > 800 ? 75 : 70,
                    ),
                    Container(child: const HeroSlider()),
                    Container(
                      key: _aboutKey,
                      child: _buildWelcomeSection(context),
                    ),
                    Container(
                      key: _servicesKey,
                      child: _buildServicesSection(context),
                    ),
                    _buildWhyChooseUs(context),
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

  Widget _buildWelcomeSection(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth <= 800;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 64,
        vertical: 100,
      ),
      color: AppTheme.white,
      child: isMobile
          ? Column(
              children: [
                _buildWelcomeText(context, isMobile),
                const SizedBox(height: 48),
                _buildWelcomeImage(),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: _buildWelcomeText(context, isMobile)),
                const SizedBox(width: 80),
                Expanded(child: _buildWelcomeImage()),
              ],
            ),
    );
  }

  Widget _buildWelcomeText(BuildContext context, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'WELCOME TO NAILAURA',
          style: GoogleFonts.inter(
            color: AppTheme.primaryGold,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
          ),
        ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.1),
        const SizedBox(height: 16),
        Text(
          'A Sanctuary for Your Hands & Feet',
          style: GoogleFonts.playfairDisplay(
            color: AppTheme.textDark,
            fontSize: isMobile ? 36 : 48,
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
        ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.1),
        const SizedBox(height: 24),
        Text(
          "Welcome to Nailaura, your upcoming destination for premium nail artistry! Opening our doors next month, we can't wait to pamper you in our luxurious, comforting studio. With a curated menu of flawless dry manicures, durable gel extensions, and bespoke nail art, our services are brought to life by a passionate technical team with over 5 years of expert experience. We focus on meticulous attention to detail, high-end international products, and warm hospitality to ensure you leave with a beautiful smile after every single visit.",
          style: GoogleFonts.inter(
            color: AppTheme.textDark.withOpacity(0.8),
            fontSize: 16,
            height: 1.8,
          ),
        ).animate().fadeIn(delay: 400.ms).slideX(begin: -0.1),
        const SizedBox(height: 40),
        OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          ),
          child: Text(
            'Read Our Story',
            style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ).animate().fadeIn(delay: 600.ms),
      ],
    );
  }

  Widget _buildWelcomeImage() {
    return Container(
      height: 500,
      decoration: BoxDecoration(
        color: AppTheme.backgroundCream,
        borderRadius: BorderRadius.circular(20),
        image: const DecorationImage(
          image: AssetImage(AppConstants.polishImage),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 800.ms).scale(begin: const Offset(0.95, 0.95));
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'OUR SERVICES',
            style: GoogleFonts.inter(
              color: AppTheme.primaryGold,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
            ),
          ).animate().fadeIn().slideY(begin: 0.2),
          const SizedBox(height: 16),
          Text(
            'Signature Treatments',
            style: GoogleFonts.playfairDisplay(
              color: AppTheme.textDark,
              fontSize: isMobile ? 36 : 48,
              fontWeight: FontWeight.bold,
            ),
          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
          const SizedBox(height: 64),
          Builder(
            builder: (context) {
              double desktopCardWidth =
                  (screenWidth - 128 - 64) / 3; // 3 columns max
              if (desktopCardWidth < 300) desktopCardWidth = 300;
              final double cardWidth = isMobile
                  ? double.infinity
                  : desktopCardWidth;

              Widget buildCard(String title, String desc, String img) {
                return SizedBox(
                  width: cardWidth,
                  child: HoverServiceCard(
                    title: title,
                    description: desc,
                    imagePath: img,
                  ),
                );
              }

              return Wrap(
                spacing: 32,
                runSpacing: 40,
                alignment: WrapAlignment.center,
                children: [
                  buildCard(
                    'Nail Art',
                    'Express your unique style with intricate, hand-painted minimal designs.',
                    AppConstants.nailArtImage,
                  ),
                  buildCard(
                    'Gel Polish',
                    'High-shine, long-lasting protective color for weeks.',
                    AppConstants.gelImage,
                  ),
                  buildCard(
                    'Soft Gel Extension',
                    'Sculpted to absolute perfection for incredible length.',
                    AppConstants.gelExtensionImage,
                  ),
                  buildCard(
                    'Poly Gel Extension',
                    'The best of both worlds: lighter than acrylics, stronger than hard gel.',
                    AppConstants.extensionsImage,
                  ),
                  buildCard(
                    'Dry Manicure',
                    'A timeless finish for healthy, naturally glowing nails and pristine cuticles.',
                    AppConstants.manicureImage,
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
        horizontal: isMobile ? 24 : 64,
        vertical: 100,
      ),
      color: AppTheme.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'THE EXPERIENCE',
            style: GoogleFonts.inter(
              color: AppTheme.primaryGold,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Why Choose Nailaura',
            style: GoogleFonts.playfairDisplay(
              color: AppTheme.textDark,
              fontSize: isMobile ? 36 : 48,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 64),
          Wrap(
            spacing: 40,
            runSpacing: 40,
            alignment: WrapAlignment.center,
            children: [
              HoverFeatureItem(
                title: 'Premium Products',
                icon: Icons.diamond_outlined,
                desc:
                    'We use industry-leading, non-toxic products to ensure healthy, vibrant nails.',
              ),
              HoverFeatureItem(
                title: 'Expert Artists',
                icon: Icons.brush_outlined,
                desc:
                    'Our licensed technicians are trained in the latest nail art techniques.',
              ),
              HoverFeatureItem(
                title: 'Ultimate Hygiene',
                icon: Icons.clean_hands_outlined,
                desc:
                    'Strict sterilization protocols for a safe, worry-free pampering session.',
              ),
              HoverFeatureItem(
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
  final String description;
  final String imagePath;
  const HoverServiceCard({
    Key? key,
    required this.title,
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
        transform: Matrix4.identity()..translate(0.0, _isHovered ? -10.0 : 0.0),
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(_isHovered ? 0.15 : 0.05),
              blurRadius: _isHovered ? 32 : 24,
              offset: Offset(0, _isHovered ? 12 : 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: AnimatedScale(
                scale: _isHovered ? 1.05 : 1.0,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOut,
                child: Image.asset(
                  widget.imagePath,
                  height: 400,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(16),
                ),
                child: BackdropFilter(
                  filter: ui.ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    padding: const EdgeInsets.all(24.0),
                    decoration: BoxDecoration(
                      color: AppTheme.white.withOpacity(0.85),
                      border: Border(
                        top: BorderSide(color: Colors.white.withOpacity(0.5)),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                widget.title,
                                style: GoogleFonts.playfairDisplay(
                                  color: AppTheme.textDark,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.description,
                          style: GoogleFonts.inter(
                            color: AppTheme.textDark.withOpacity(0.8),
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 16),
                        InkWell(
                          onTap: () {
                            Utils.showBookingOptions(context);
                          },
                          child: Row(
                            children: [
                              Text(
                                'Book Now',
                                style: GoogleFonts.inter(
                                  color: AppTheme.primaryGold,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(width: 8),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                transform: Matrix4.identity()
                                  ..translate(_isHovered ? 5.0 : 0.0, 0.0),
                                child: const Icon(
                                  Icons.arrow_forward,
                                  color: AppTheme.primaryGold,
                                  size: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
  final String title;
  final IconData icon;
  final String desc;
  const HoverFeatureItem({
    Key? key,
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
        width: 250,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: _isHovered ? AppTheme.white : AppTheme.backgroundCream,
          borderRadius: BorderRadius.circular(16),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ]
              : [],
        ),
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _isHovered ? AppTheme.primaryGold : AppTheme.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: AnimatedRotation(
                turns: _isHovered ? 0.05 : 0,
                duration: const Duration(milliseconds: 300),
                child: Icon(
                  widget.icon,
                  color: _isHovered ? AppTheme.white : AppTheme.primaryGold,
                  size: 32,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              widget.title,
              style: GoogleFonts.inter(
                color: AppTheme.textDark,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              widget.desc,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: AppTheme.textDark.withOpacity(0.7),
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ],
        ),
      ).animate().fadeIn().scale(begin: const Offset(0.9, 0.9)),
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
      AppConstants.nailArtImage,
      AppConstants.gelExtensionImage,
      AppConstants.manicureImage,
      AppConstants.polishImage,
      AppConstants.gelImage,
      AppConstants.extensionsImage,
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 80),
      color: AppTheme.white,
      child: Column(
        children: [
          Text(
            'Follow Us @nailaura',
            style: GoogleFonts.playfairDisplay(
              color: AppTheme.textDark,
              fontSize: isMobile ? 28 : 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 48),
          SizedBox(
            height: 350,
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
                  width: 300,
                  margin: const EdgeInsets.only(right: 24, left: 0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(
                      image: AssetImage(imagePath),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
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
