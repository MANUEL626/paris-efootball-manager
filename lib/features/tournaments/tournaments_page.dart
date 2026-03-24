import 'package:flutter/material.dart';

import '../../core/l10n/context_l10n.dart';

/// Page Tournois (depuis modale Événement / bannière).
class TournamentsPage extends StatelessWidget {
  const TournamentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(l10n.tournamentsTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: Colors.deepPurple.shade800,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.emoji_events, color: Colors.amber, size: 32),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          l10n.eventModalTitle,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.tournamentWeeklyBlurb,
                    style: TextStyle(color: Colors.white.withOpacity(0.9)),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text(l10n.registerTournament),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.otherTournaments,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 8),
          _TournamentTile(
            title: l10n.tournamentWeekend,
            prize: l10n.prize50k,
            onTap: () {},
          ),
          _TournamentTile(
            title: l10n.tournamentFriday,
            prize: l10n.prize25k,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _TournamentTile extends StatelessWidget {
  const _TournamentTile({
    required this.title,
    required this.prize,
    required this.onTap,
  });

  final String title;
  final String prize;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: const Color(0xFF1A2332),
      child: ListTile(
        leading: const Icon(Icons.emoji_events, color: Colors.amber),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        subtitle: Text(
          prize,
          style: TextStyle(color: Colors.white.withOpacity(0.7)),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
