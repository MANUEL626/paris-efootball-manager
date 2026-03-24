import 'package:flutter/material.dart';

import '../../core/l10n/context_l10n.dart';

/// Page Annonces : infos & nouveautés avec filtres.
class AnnouncementsPage extends StatelessWidget {
  const AnnouncementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            const Icon(Icons.campaign),
            const SizedBox(width: 8),
            Text(l10n.announcementsTitle),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                '7',
                style: TextStyle(fontSize: 12, color: Colors.white),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.done_all), onPressed: () {}),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Text(
              l10n.announcementsNews,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 14,
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _FilterChip(label: l10n.filterAll, selected: true),
                const SizedBox(width: 8),
                _FilterChip(label: l10n.filterNews, selected: false),
                const SizedBox(width: 8),
                _FilterChip(label: l10n.filterEvent, selected: false),
                const SizedBox(width: 8),
                _FilterChip(label: l10n.filterInfo, selected: false),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _AnnouncementCard(
                  type: l10n.badgeNew,
                  title: l10n.announcementWelcomeTitle,
                  body: l10n.announcementWelcomeBody,
                  time: l10n.time2h,
                  borderColor: Colors.pink,
                  badgeUpper: l10n.badgeNewUpper,
                ),
                _AnnouncementCard(
                  type: l10n.filterEvent,
                  title: l10n.announcementTournamentTitle,
                  body: l10n.announcementTournamentBody,
                  time: l10n.time5h,
                  borderColor: Colors.pink,
                  badgeUpper: l10n.badgeNewUpper,
                ),
                _AnnouncementCard(
                  type: l10n.badgeNew,
                  title: l10n.announcementRewardsTitle,
                  body: l10n.announcementRewardsBody,
                  time: l10n.time1d,
                  borderColor: const Color(0xFF00BCD4),
                  badgeUpper: l10n.badgeNewUpper,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, required this.selected});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) {},
      selectedColor: const Color(0xFF00BCD4),
      checkmarkColor: Colors.white,
    );
  }
}

class _AnnouncementCard extends StatelessWidget {
  const _AnnouncementCard({
    required this.type,
    required this.title,
    required this.body,
    required this.time,
    required this.borderColor,
    required this.badgeUpper,
  });

  final String type;
  final String title;
  final String body;
  final String time;
  final Color borderColor;
  final String badgeUpper;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: const Color(0xFF1A2332),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: borderColor, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: borderColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    type,
                    style: const TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                ),
                const Spacer(),
                Text(
                  badgeUpper,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF00BCD4),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              body,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Text(time, style: TextStyle(color: Colors.white54, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
