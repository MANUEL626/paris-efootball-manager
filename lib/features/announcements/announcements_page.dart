import 'package:flutter/material.dart';

/// Page Annonces : infos & nouveautés avec filtres.
class AnnouncementsPage extends StatelessWidget {
  const AnnouncementsPage({super.key});

  @override
  Widget build(BuildContext context) {
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
            const Text('Annonces'),
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
              'Infos & Nouveautés',
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
                _FilterChip(label: 'Tout', selected: true),
                const SizedBox(width: 8),
                _FilterChip(label: 'Nouveauté', selected: false),
                const SizedBox(width: 8),
                _FilterChip(label: 'Événement', selected: false),
                const SizedBox(width: 8),
                _FilterChip(label: 'Info', selected: false),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: const [
                _AnnouncementCard(
                  type: 'NEW Nouveauté',
                  title: 'Bienvenue sur KickFlow !',
                  body:
                      'Merci de rejoindre la communauté KickFlow ! Défie tes amis, participe à des tournois et gagne de l\'argent réel en jouant à eFootball.',
                  time: 'Il y a 2h',
                  borderColor: Colors.pink,
                ),
                _AnnouncementCard(
                  type: 'Événement',
                  title: 'Tournoi Hebdomadaire - 100 000 FCFA',
                  body:
                      'Le grand tournoi hebdomadaire commence vendredi ! Prix total : 100 000 FCFA. Inscriptions ouvertes dès maintenant.',
                  time: 'Il y a 5h',
                  borderColor: Colors.pink,
                ),
                _AnnouncementCard(
                  type: 'NEW Nouveauté',
                  title: 'Nouveau système de récompenses',
                  body:
                      'Gagne des points de fidélité à chaque match et débloque des bonus exclusifs ! Plus tu joues, plus tu gagnes.',
                  time: 'Il y a 1j',
                  borderColor: Color(0xFF00BCD4),
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
  });

  final String type;
  final String title;
  final String body;
  final String time;
  final Color borderColor;

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
                const Text(
                  'NOUVEAU',
                  style: TextStyle(
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
