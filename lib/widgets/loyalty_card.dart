import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Nailaura Aura loyalty tiers, in order. A card moves up a tier (same
/// number) once its visits are complete; Diamond is lifetime.
enum LoyaltyTier {
  silver('Silver Aura', [Color(0xFFF2F2F2), Color(0xFFA7A9AC)], 5),
  platinum('Platinum Aura', [Color(0xFFEDEFF3), Color(0xFF8C97A8)], 10),
  gold('Gold Aura', [Color(0xFFF1D592), Color(0xFFB8893E)], 15),
  diamond('Diamond Aura', [Color(0xFFD6F6FF), Color(0xFF6FA8C8)], 0);

  final String label;
  final List<Color> colors;

  /// Visits needed to complete this card (0 = lifetime, never completes).
  final int visits;
  const LoyaltyTier(this.label, this.colors, this.visits);

  bool get hasFreeVisit => this == silver;
  bool get isLifetime => visits == 0;

  /// Slots drawn on the card: Silver shows 5 stamps + the free 6th.
  int get slots => hasFreeVisit ? visits + 1 : visits;

  LoyaltyTier? get next => this == diamond ? null : values[index + 1];

  static LoyaltyTier forCard(int level) =>
      level >= values.length ? diamond : values[(level < 1 ? 1 : level) - 1];

  static LoyaltyTier fromName(String? name) =>
      values.firstWhere((t) => t.name == name, orElse: () => silver);
}

class Loyalty {
  /// Silver stamps before the free visit.
  static const stampsPerCard = 5;
  static const rewardSlot = stampsPerCard + 1;
}

/// Discount rules per tier (editable in Settings).
class TierRules {
  final double silverPercent;
  final double platinumPercent;
  final double goldPercent;
  final double diamondPercent;

  /// Card-discount uses allowed per calendar month (0 = no limit).
  final int platinumMonthly;
  final int goldMonthly;
  final int diamondMonthly;

  const TierRules({
    this.silverPercent = 5,
    this.platinumPercent = 10,
    this.goldPercent = 15,
    this.diamondPercent = 30,
    this.platinumMonthly = 0,
    this.goldMonthly = 2,
    this.diamondMonthly = 1,
  });

  double percentFor(LoyaltyTier t) => switch (t) {
    LoyaltyTier.silver => silverPercent,
    LoyaltyTier.platinum => platinumPercent,
    LoyaltyTier.gold => goldPercent,
    LoyaltyTier.diamond => diamondPercent,
  };

  int monthlyFor(LoyaltyTier t) => switch (t) {
    LoyaltyTier.silver => 0,
    LoyaltyTier.platinum => platinumMonthly,
    LoyaltyTier.gold => goldMonthly,
    LoyaltyTier.diamond => diamondMonthly,
  };

  /// Short benefit lines for a tier, shown under the demo cards.
  List<String> benefits(LoyaltyTier t) {
    final pct = percentFor(t).toStringAsFixed(0);
    final limit = monthlyFor(t);
    final limitText = limit == 0
        ? 'Use on every visit'
        : 'Use $limit time${limit == 1 ? '' : 's'} a month';
    return switch (t) {
      LoyaltyTier.silver => [
        '$pct% off from the 2nd visit',
        '6th visit FREE after 5 stamps',
        'Then upgrades to Platinum Aura',
      ],
      LoyaltyTier.platinum => [
        '$pct% off every visit',
        limitText,
        '${t.visits} visits, then upgrades to Gold Aura',
      ],
      LoyaltyTier.gold => [
        '$pct% off',
        limitText,
        '${t.visits} visits, then upgrades to Diamond Aura',
      ],
      LoyaltyTier.diamond => ['$pct% off', limitText, 'Lifetime top tier'],
    };
  }
}

/// Branded Aura loyalty card: five service slots and a free sixth.
/// Filled slots carry a tick in the tier's metal colour.
class LoyaltyCardView extends StatelessWidget {
  final LoyaltyTier tier;
  final int cardNumber;

  /// Printed card number, shown instead of "CARD 01" when known.
  final String? numberLabel;

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
    this.numberLabel,
    required this.filled,
    this.customerName,
    this.width = 420,
    this.locked = false,
    this.footer,
  });

  /// Slots per row: Silver's 6 fit on one line; 10 and 15 use rows of 5.
  int get _perRow => tier.slots > 6 ? 5 : tier.slots;

  static const _icons = [
    Icons.brush_outlined,
    Icons.spa_outlined,
    Icons.auto_awesome_outlined,
    Icons.palette_outlined,
    Icons.back_hand_outlined,
  ];

  /// Small line under the slots, e.g. "6TH VISIT FREE" or "15% OFF".
  final String? footer;

  static const _defaultRules = TierRules();

  String get _footer =>
      footer ??
      (tier.hasFreeVisit
          ? '6TH VISIT FREE'
          : '${_defaultRules.percentFor(tier).toStringAsFixed(0)}% OFF${tier.isLifetime ? ' · LIFETIME' : ''}');

  @override
  Widget build(BuildContext context) {
    final metal = LinearGradient(
      colors: tier.colors,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
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
        border: Border.all(
          color: tier.colors.last.withValues(alpha: 0.7),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                'assets/images/logo_icon_gold.png',
                height: 30 * scale,
              ),
              SizedBox(width: 8 * scale),
              Image.asset(
                'assets/images/logo_text_gold.png',
                height: 22 * scale,
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  metalText(
                    tier.label.toUpperCase(),
                    GoogleFonts.plusJakartaSans(
                      fontSize: 13 * scale,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2,
                    ),
                  ),
                  Text(
                    numberLabel != null
                        ? 'NO. $numberLabel'
                        : 'CARD ${cardNumber.toString().padLeft(2, '0')}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 9 * scale,
                      color: Colors.white54,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 18 * scale),
          if (tier.isLifetime)
            _LifetimeBadge(tier: tier, visits: filled, scale: scale)
          else
            for (var row = 0; row * _perRow < tier.slots; row++) ...[
              if (row > 0) SizedBox(height: 8 * scale),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (var i = row * _perRow; i < (row + 1) * _perRow; i++)
                    if (i < tier.slots)
                      _Slot(
                        icon: tier.hasFreeVisit && i == tier.slots - 1
                            ? Icons.card_giftcard_rounded
                            : _icons[i % _icons.length],
                        size: tier.slots > 6 ? slot * 0.92 : slot,
                        stamped: filled > i,
                        isReward: tier.hasFreeVisit && i == tier.slots - 1,
                        tier: tier,
                      )
                    else
                      SizedBox(width: tier.slots > 6 ? slot * 0.92 : slot),
                ],
              ),
            ],
          SizedBox(height: 14 * scale),
          Row(
            children: [
              Expanded(
                child: Text(
                  customerName?.toUpperCase() ?? 'NAILAURA AURA CARD',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10.5 * scale,
                    color: Colors.white70,
                    letterSpacing: 1.6,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              metalText(
                _footer,
                GoogleFonts.plusJakartaSans(
                  fontSize: 10 * scale,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.4,
                ),
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
          0.33,
          0.33,
          0.33,
          0,
          0,
          0.33,
          0.33,
          0.33,
          0,
          0,
          0.33,
          0.33,
          0.33,
          0,
          0,
          0,
          0,
          0,
          1,
          0,
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
    final metal = LinearGradient(
      colors: tier.colors,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
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
                color: isReward
                    ? tier.colors.first
                    : Colors.white.withValues(alpha: 0.25),
                width: isReward ? 1.6 : 1,
              ),
            ),
          ),
          Icon(
            icon,
            size: size * 0.46,
            color: stamped
                ? Colors.black.withValues(alpha: 0.25)
                : (isReward ? tier.colors.first : Colors.white60),
          ),
          if (stamped)
            Icon(
              Icons.check_rounded,
              size: size * 0.62,
              color: const Color(0xFF111111),
            ),
        ],
      ),
    );
  }
}

/// Diamond has no stamps: it shows a lifetime badge and the visit count.
class _LifetimeBadge extends StatelessWidget {
  final LoyaltyTier tier;
  final int visits;
  final double scale;
  const _LifetimeBadge({
    required this.tier,
    required this.visits,
    required this.scale,
  });

  @override
  Widget build(BuildContext context) {
    final metal = LinearGradient(
      colors: tier.colors,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
    return Container(
      height: 46 * scale,
      padding: EdgeInsets.symmetric(horizontal: 16 * scale),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12 * scale),
        border: Border.all(color: tier.colors.first.withValues(alpha: 0.6)),
        color: Colors.white.withValues(alpha: 0.04),
      ),
      child: Row(
        children: [
          ShaderMask(
            shaderCallback: (r) => metal.createShader(r),
            child: Icon(
              Icons.diamond_outlined,
              size: 24 * scale,
              color: Colors.white,
            ),
          ),
          SizedBox(width: 10 * scale),
          ShaderMask(
            shaderCallback: (r) => metal.createShader(r),
            child: Text(
              'LIFETIME MEMBER',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12 * scale,
                fontWeight: FontWeight.w800,
                letterSpacing: 2,
                color: Colors.white,
              ),
            ),
          ),
          const Spacer(),
          Text(
            '$visits visit${visits == 1 ? '' : 's'}',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11 * scale,
              color: Colors.white70,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Line shown under the card on the digital invoice.
String loyaltyMessage({
  required int card,
  required int filled,
  bool completed = false,
  double percent = 0,
}) {
  final tier = LoyaltyTier.forCard(card);
  final off = percent > 0
      ? ' You saved ${percent.toStringAsFixed(0)}% today.'
      : '';
  if (tier.hasFreeVisit && filled >= Loyalty.rewardSlot) {
    return 'This visit was FREE with your ${tier.label} card. It now moves up to ${tier.next!.label}.';
  }
  if (completed && tier.next != null) {
    return 'Your ${tier.label} card is complete and moves up to ${tier.next!.label}!$off';
  }
  if (tier.isLifetime)
    return '${tier.label}: lifetime member, visit $filled.$off';
  if (tier.hasFreeVisit && filled >= Loyalty.stampsPerCard) {
    return 'Your ${tier.label} card is full: your next visit is FREE!$off';
  }
  final left = tier.visits - filled;
  return '$filled of ${tier.visits} visits. $left more to ${tier.hasFreeVisit ? 'your FREE visit' : tier.next!.label}.$off';
}
