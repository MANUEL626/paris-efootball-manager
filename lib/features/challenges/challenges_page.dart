import 'package:flutter/material.dart';

/// Page Défis : trouver / créer des défis 1v1.
class ChallengesPage extends StatelessWidget {
  const ChallengesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Défis'),
        actions: [
          IconButton(icon: const Icon(Icons.filter_list), onPressed: () {}),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Trouver un défi',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            'Créez ou rejoignez un défi 1v1 et misez vos SkillCoins.',
            style: TextStyle(color: Colors.white.withOpacity(0.8)),
          ),
          const SizedBox(height: 24),
          _ChallengeCard(
            title: 'Défi rapide 1v1',
            stake: '500 SkillCoins',
            onJoin: () {},
          ),
          _ChallengeCard(
            title: 'Défi intermédiaire',
            stake: '1 000 SkillCoins',
            onJoin: () {},
          ),
          _ChallengeCard(
            title: 'Défi expert',
            stake: '5 000 SkillCoins',
            onJoin: () {},
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.add),
        label: const Text('Créer un défi'),
        backgroundColor: const Color(0xFF00BCD4),
      ),
    );
  }
}

class _ChallengeCard extends StatelessWidget {
  const _ChallengeCard({
    required this.title,
    required this.stake,
    required this.onJoin,
  });

  final String title;
  final String stake;
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
          child: const Text('Rejoindre'),
        ),
      ),
    );
  }
}
