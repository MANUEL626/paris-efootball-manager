import 'package:flutter/material.dart';

import '../../core/l10n/context_l10n.dart';

/// Page Historique : liste des défis passés.
class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.historyTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            l10n.historyYourChallenges,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.historySubtitle,
            style: TextStyle(color: Colors.white.withOpacity(0.8)),
          ),
          const SizedBox(height: 24),
          _HistoryTile(
            result: l10n.resultWin,
            opponent: 'Joueur_123',
            date: l10n.ago2h,
            stake: '+500 SC',
            won: true,
          ),
          _HistoryTile(
            result: l10n.resultLoss,
            opponent: 'Pro_Gamer',
            date: l10n.ago1d,
            stake: '-500 SC',
            won: false,
          ),
        ],
      ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({
    required this.result,
    required this.opponent,
    required this.date,
    required this.stake,
    required this.won,
  });

  final String result;
  final String opponent;
  final String date;
  final String stake;
  final bool won;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: const Color(0xFF1A2332),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: won ? Colors.green : Colors.red,
          child: Icon(
            won ? Icons.thumb_up : Icons.thumb_down,
            color: Colors.white,
          ),
        ),
        title: Text(
          '$result vs $opponent',
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          date,
          style: TextStyle(color: Colors.white.withOpacity(0.7)),
        ),
        trailing: Text(
          stake,
          style: TextStyle(
            color: won ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
