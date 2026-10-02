import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Nailaura Aura loyalty card, shown on the customer's digital invoice.
/// Mirrors the billing app's card.
enum LoyaltyTier {
  silver('Silver Aura', [Color(0xFFF2F2F2), Color(0xFFA7A9AC)]),
  gold('Gold Aura', [Color(0xFFF1D592), Color(0xFFB8893E)]),
  platinum('Platinum Aura', [Color(0xFFEDEFF3), Color(0xFF8C97A8)]),
  diamond('Diamond Aura', [Color(0xFFD6F6FF), Color(0xFF6FA8C8)]);

  final String label;
  final List<Color> colors;
  const LoyaltyTier(this.label, this.colors);

  static LoyaltyTier forCard(int card) =>
      card >= values.length ? diamond : values[(card < 1 ? 1 : card) - 1];
}

class Loyalty {
  static const stampsPerCard = 5;
  static const rewardSlot = stampsPerCard + 1;

  /// Line shown under the card for a visit that left [filled] slots ticked.
  static String message(int card, int filled) {
    final tier = LoyaltyTier.forCard(card);
    if (filled >= rewardSlot) {
      return 'This visit was FREE with your ${tier.label} card. '
          'Your ${LoyaltyTier.forCard(card + 1).label} card starts on your next visit.';
    }
    if (filled >= stampsPerCard) return 'Your ${tier.label} card is full: your next visit is FREE!';
    final left = stampsPerCard - filled;
    return '$filled of $stampsPerCard stamps. $left more visit${left == 1 ? '' : 's'} to your FREE service.';
  }
}

/// Branded Aura loyalty card: five service slots and a free sixth.
/// Filled slots carry a tick in the tier's metal colour.
class LoyaltyCardView extends StatelessWidget {
  final LoyaltyTier tier;
  final int cardNumber;

  /// Slots ticked: 0..5 stamps, 6 = the free visit has been used.
  final int filled;
  final String? customerName;
  final double width;

  /// Greyed-out look for cards not reached yet.
  final bool locked;

  const LoyaltyCardView({
    super.key,
    required this.tier,
    required this.cardNumber,
    required this.filled,
    this.customerName,
    this.width = 420,
    this.locked = false,
  });

  static const _icons = [
    Icons.brush_outlined,
    Icons.spa_outlined,
    Icons.auto_awesome_outlined,
    Icons.palette_outlined,
    Icons.back_hand_outlined,
    Icons.card_giftcard_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    final metal = LinearGradient(colors: tier.colors, begin: Alignment.topLeft, end: Alignment.bottomRight);
    final scale = width / 420;
    final slot = 46.0 * scale;

    Widget metalText(String text, TextStyle style) => ShaderMask(
          shaderCallback: (r) => metal.createShader(r),
          child: Text(text, style: style.copyWith(color: Colors.white)),
        );

    final card = Container(
      width: width,
      padding: EdgeInsets.all(20 * scale),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18 * scale),
        gradient: const LinearGradient(
          colors: [Color(0xFF1B1A18), Color(0xFF0C0B0A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: tier.colors.last.withValues(alpha: 0.7), width: 1.2),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.25), blurRadius: 18, offset: const Offset(0, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset('assets/images/logo_icon_gold.png', height: 30 * scale),
              SizedBox(width: 8 * scale),
              Image.asset('assets/images/logo_text_gold.png', height: 22 * scale),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  metalText(
                    tier.label.toUpperCase(),
                    GoogleFonts.plusJakartaSans(fontSize: 13 * scale, fontWeight: FontWeight.w800, letterSpacing: 2),
                  ),
                  Text('CARD ${cardNumber.toString().padLeft(2, '0')}',
                      style: GoogleFonts.plusJakartaSans(
                          fontSize: 9 * scale, color: Colors.white54, letterSpacing: 1.5, fontWeight: FontWeight.w600)),
                ],
              ),
            ],
          ),
          SizedBox(height: 18 * scale),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (var i = 0; i < Loyalty.rewardSlot; i++)
                _Slot(
                  icon: _icons[i],
                  size: slot,
                  stamped: filled > i,
                  isReward: i == Loyalty.rewardSlot - 1,
                  tier: tier,
                ),
            ],
          ),
          SizedBox(height: 14 * scale),
          Row(
            children: [
              Expanded(
                child: Text(
                  customerName?.toUpperCase() ?? 'NAILAURA AURA CARD',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 10.5 * scale, color: Colors.white70, letterSpacing: 1.6, fontWeight: FontWeight.w600),
                ),
              ),
              metalText(
                '6TH VISIT FREE',
                GoogleFonts.plusJakartaSans(fontSize: 10 * scale, fontWeight: FontWeight.w800, letterSpacing: 1.4),
              ),
            ],
          ),
        ],
      ),
    );

    if (!locked) return card;
    return Opacity(
      opacity: 0.45,
      child: ColorFiltered(
        colorFilter: const ColorFilter.matrix(<double>[
          0.33, 0.33, 0.33, 0, 0,
          0.33, 0.33, 0.33, 0, 0,
          0.33, 0.33, 0.33, 0, 0,
          0, 0, 0, 1, 0,
        ]),
        child: card,
      ),
    );
  }
}

class _Slot extends StatelessWidget {
  final IconData icon;
  final double size;
  final bool stamped;
  final bool isReward;
  final LoyaltyTier tier;

  const _Slot({
    required this.icon,
    required this.size,
    required this.stamped,
    required this.isReward,
    required this.tier,
  });

  @override
  Widget build(BuildContext context) {
    final metal = LinearGradient(colors: tier.colors, begin: Alignment.topLeft, end: Alignment.bottomRight);
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: stamped ? metal : null,
              color: stamped ? null : Colors.white.withValues(alpha: 0.05),
              border: Border.all(
                color: isReward ? tier.colors.first : Colors.white.withValues(alpha: 0.25),
                width: isReward ? 1.6 : 1,
              ),
            ),
          ),
          Icon(
            icon,
            size: size * 0.46,
            color: stamped ? Colors.black.withValues(alpha: 0.25) : (isReward ? tier.colors.first : Colors.white60),
          ),
          if (stamped) Icon(Icons.check_rounded, size: size * 0.62, color: const Color(0xFF111111)),
        ],
      ),
    );
  }
}
