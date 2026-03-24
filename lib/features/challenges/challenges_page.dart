import 'package:flutter/material.dart';

import '../../core/l10n/context_l10n.dart';

/// Page Défis : trouver / créer des défis 1v1.
class ChallengesPage extends StatelessWidget {
  const ChallengesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.challengesTitle),
        actions: [
          IconButton(icon: const Icon(Icons.filter_list), onPressed: () {}),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            l10n.findChallenge,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.findChallengeSubtitle,
            style: TextStyle(color: Colors.white.withOpacity(0.8)),
          ),
          const SizedBox(height: 24),
          _ChallengeCard(
            title: l10n.challengeQuick,
            stake: l10n.skillCoins500,
            joinLabel: l10n.join,
            onJoin: () {},
          ),
          _ChallengeCard(
            title: l10n.challengeMedium,
            stake: l10n.skillCoins1000,
            joinLabel: l10n.join,
            onJoin: () {},
          ),
          _ChallengeCard(
            title: l10n.challengeExpert,
            stake: l10n.skillCoins5000,
            joinLabel: l10n.join,
            onJoin: () {},
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.add),
        label: Text(l10n.createChallenge),
        backgroundColor: const Color(0xFF00BCD4),
      ),
    );
  }
}

class _ChallengeCard extends StatelessWidget {
  const _ChallengeCard({
    required this.title,
    required this.stake,
    required this.joinLabel,
    required this.onJoin,
  });

  final String title;
  final String stake;
  final String joinLabel;
  final VoidCallback onJoin;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: const Color(0xFF1A2332),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Color(0xFF00BCD4),
          child: Icon(Icons.sports_soccer, color: Colors.white),
        ),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        subtitle: Text(
          stake,
          style: TextStyle(color: Colors.white.withOpacity(0.7)),
        ),
        trailing: ElevatedButton(
          onPressed: onJoin,
          child: Text(joinLabel),
        ),
      ),
    );
  }
}
