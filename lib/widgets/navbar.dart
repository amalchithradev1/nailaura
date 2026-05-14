import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/constants.dart';
import '../core/theme.dart';

class NavBar extends StatelessWidget implements PreferredSizeWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 800) {
          return _buildDesktopNav(context);
        } else {
          return _buildMobileNav(context);
        }
      },
    );
  }

  Widget _buildDesktopNav(BuildContext context) {
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 0),
      decoration: BoxDecoration(
        color: AppTheme.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildLogo(context),
          Row(
            children: [
              ...AppConstants.navLinks.map(
                (link) => Padding(
                  padding: const EdgeInsets.only(left: 32),
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      link,
                      style: GoogleFonts.inter(
                        color: AppTheme.textDark,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 32),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Book Appointment'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMobileNav(BuildContext context) {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
      decoration: BoxDecoration(
        color: AppTheme.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildLogo(context),
          IconButton(
            icon: const Icon(Icons.menu, color: AppTheme.textDark),
            onPressed: () {
              Scaffold.of(context).openEndDrawer();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLogo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Image.asset(
        AppConstants.logoImage,
        width: 180, // Using width is usually safer for logos with extra whitespace
        fit: BoxFit.contain,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}

class MobileDrawer extends StatelessWidget {
  const MobileDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppTheme.backgroundCream,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: AppTheme.primaryGold),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Image(
                image: AssetImage(
                  AppConstants.logoDarkImage,
                ), // The dark background version
                height: 48,
              ),
            ),
          ),
          ...AppConstants.navLinks.map(
            (link) => ListTile(
              title: Text(
                link,
                style: GoogleFonts.inter(
                  color: AppTheme.textDark,
                  fontSize: 18,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {},
              child: const Text('Book Appointment'),
            ),
          ),
        ],
      ),
    );
  }
}
