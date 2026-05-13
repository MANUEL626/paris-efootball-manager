import 'package:flutter/material.dart';

/// Page Tournois (depuis modale Événement / bannière).
class TournamentsPage extends StatelessWidget {
  const TournamentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Tournois'),
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
                  const Row(
                    children: [
                      Icon(Icons.emoji_events, color: Colors.amber, size: 32),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Tournoi Hebdomadaire - 100 000 FCFA',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Le grand tournoi hebdomadaire commence vendredi ! Prix total : 100 000 FCFA. Inscriptions ouvertes dès maintenant.',
                    style: TextStyle(color: Colors.white.withOpacity(0.9)),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text('S\'inscrire au tournoi'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Autres tournois',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 8),
          _TournamentTile(title: 'Tournoi du week-end', prize: '50 000 FCFA', onTap: () {}),
          _TournamentTile(title: 'Défi du vendredi', prize: '25 000 FCFA', onTap: () {}),
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
        subtitle: Text(prize, style: TextStyle(color: Colors.white.withOpacity(0.7))),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
