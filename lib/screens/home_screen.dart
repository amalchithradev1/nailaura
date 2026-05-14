import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/constants.dart';
import '../core/theme.dart';
import '../widgets/navbar.dart';
import '../widgets/footer.dart';
import '../widgets/hero_slider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MobileDrawer(),
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(
            child: NavBar(),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                const HeroSlider(),
                _buildWelcomeSection(context),
                _buildServicesSection(context),
                _buildWhyChooseUs(context),
                _buildGalleryPlaceholder(context),
                const Footer(),
              ],
            ),
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
          'At Nailaura, we elevate the art of nail care into a luxury experience. Whether you seek a classic manicure, intricate nail extensions, or a durable gel finish, our expert technicians use only the finest products to ensure your nails look spectacular and remain healthy. Step into our relaxing ambience and let us take care of you.',
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
          if (isMobile)
            Column(
              children: [
                _buildServiceCard('Classic Polish', 'A timeless finish with premium lacquers.', AppConstants.polishImage, '\$35+'),
                const SizedBox(height: 32),
                _buildServiceCard('Nail Extensions', 'Sculpted perfection for length and strength.', AppConstants.extensionsImage, '\$75+'),
                const SizedBox(height: 32),
                _buildServiceCard('Gel Polish', 'High-shine, long-lasting protective color.', AppConstants.gelImage, '\$50+'),
              ],
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildServiceCard('Classic Polish', 'A timeless finish with premium lacquers.', AppConstants.polishImage, '\$35+')),
                const SizedBox(width: 32),
                Expanded(child: _buildServiceCard('Nail Extensions', 'Sculpted perfection for length and strength.', AppConstants.extensionsImage, '\$75+')),
                const SizedBox(width: 32),
                Expanded(child: _buildServiceCard('Gel Polish', 'High-shine, long-lasting protective color.', AppConstants.gelImage, '\$50+')),
              ],
            ),
          const SizedBox(height: 64),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
            ),
            child: Text(
              'View All Services',
              style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(String title, String description, String imagePath, String price) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.asset(
              imagePath,
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: GoogleFonts.playfairDisplay(
                          color: AppTheme.textDark,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      price,
                      style: GoogleFonts.inter(
                        color: AppTheme.primaryGold,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  description,
                  style: GoogleFonts.inter(
                    color: AppTheme.textDark.withOpacity(0.7),
                    fontSize: 15,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 24),
                InkWell(
                  onTap: () {},
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
                      const Icon(Icons.arrow_forward, color: AppTheme.primaryGold, size: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.1);
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
              _buildFeatureItem('Premium Products', Icons.diamond_outlined, 'We use industry-leading, non-toxic products to ensure healthy, vibrant nails.'),
              _buildFeatureItem('Expert Artists', Icons.brush_outlined, 'Our licensed technicians are trained in the latest nail art techniques.'),
              _buildFeatureItem('Ultimate Hygiene', Icons.clean_hands_outlined, 'Strict sterilization protocols for a safe, worry-free pampering session.'),
              _buildFeatureItem('Relaxing Vibe', Icons.spa_outlined, 'A serene environment designed for you to unwind and relax completely.'),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String title, IconData icon, String desc) {
    return Container(
      width: 250,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.backgroundCream,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
              ],
            ),
            child: Icon(icon, color: AppTheme.primaryGold, size: 32),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: GoogleFonts.inter(
              color: AppTheme.textDark,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            desc,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: AppTheme.textDark.withOpacity(0.7),
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    ).animate().fadeIn().scale(begin: const Offset(0.9, 0.9));
  }

  Widget _buildGalleryPlaceholder(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth <= 800;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 80),
      color: AppTheme.backgroundCream,
      child: Column(
        children: [
          Text(
            'Follow Us @NailauraStudio',
            style: GoogleFonts.playfairDisplay(
              color: AppTheme.textDark,
              fontSize: isMobile ? 28 : 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 48),
          SizedBox(
            height: 300,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 6,
              itemBuilder: (context, index) {
                // Alternating images just for the placeholder gallery
                final images = [AppConstants.polishImage, AppConstants.gelImage, AppConstants.extensionsImage];
                return Container(
                  width: 300,
                  margin: const EdgeInsets.only(right: 16, left: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: AssetImage(images[index % 3]),
                      fit: BoxFit.cover,
                    ),
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
