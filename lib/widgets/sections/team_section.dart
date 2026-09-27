import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../core/theme.dart';
import '../common.dart';
import '../scroll_reveal.dart';

class _Member {
  final String name;
  final String photo;
  final Alignment focus;
  const _Member(this.name, this.photo, this.focus);
}

/// The founders: owners and artists behind Nailaura.
class TeamSection extends StatelessWidget {
  const TeamSection({super.key});

  static const _members = [
    _Member('Amal', AppConstants.teamAmal, Alignment(-0.7, -0.6)),
    _Member('Aswathy', AppConstants.teamAswathy, Alignment(0, -0.6)),
  ];

  @override
  Widget build(BuildContext context) {
    final mobile = Responsive.isMobile(context);
    return Container(
      color: AppTheme.ivory,
      padding: EdgeInsets.symmetric(vertical: Responsive.sectionPadding(context)),
      child: ContentWidth(
        maxWidth: 980,
        child: Column(
          children: [
            const ScrollReveal(
              child: SectionTitle(
                script: 'Team',
                eyebrow: 'THE PEOPLE BEHIND NAILAURA',
                title: 'MEET THE FOUNDERS',
              ),
            ),
            const SizedBox(height: 80),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 70,
              runSpacing: 70,
              children: [
                for (var i = 0; i < _members.length; i++)
                  SizedBox(
                    width: mobile ? double.infinity : 400,
                    child: ScrollReveal(
                      delay: Duration(milliseconds: 150 * i),
                      child: _MemberCard(member: _members[i]),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MemberCard extends StatelessWidget {
  final _Member member;
  const _MemberCard({required this.member});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 18, bottom: 18),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: 18,
                top: 18,
                right: -18,
                bottom: -18,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppTheme.primaryGold, width: 1),
                  ),
                ),
              ),
              AspectRatio(
                aspectRatio: 0.8,
                child: HoverZoomImage(
                  asset: member.photo,
                  alignment: member.focus,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 34),
        Text(
          member.name.toUpperCase(),
          style: AppText.heading(size: 22).copyWith(letterSpacing: 7),
        ),
      ],
    );
  }
}
