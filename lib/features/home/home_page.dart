import 'package:flutter/material.dart';

import '../../core/routes/app_routes.dart';

/// Tableau de bord (Accueil) : Arène SkillBet, 4 cartes, bannière.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _bannerVisible = true;
  bool _eventModalVisible = true;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_bannerVisible)
                _TournamentBanner(
                  onClose: () => setState(() => _bannerVisible = false),
                ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _BalanceChip(value: '12351288'),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.notifications_none),
                    onPressed: () => Navigator.of(
                      context,
                    ).pushNamed(AppRoutes.announcements),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Arène SkillBet',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Choisissez votre action',
                style: TextStyle(color: Colors.white.withOpacity(0.8)),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _ActionCard(
                      title: 'TROUVER DÉFI',
                      subtitle:
                          'Créez ou rejoignez un défi 1v1 et misez vos SkillCoins',
                      icon: Icons.sports_soccer,
                      color: Colors.red.shade700,
                      onTap: () =>
                          Navigator.of(context).pushNamed(AppRoutes.challenges),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ActionCard(
                      title: 'HISTORIQUE',
                      subtitle: 'Consultez l\'historique de tous vos défis',
                      icon: Icons.history,
                      color: Colors.green.shade700,
                      onTap: () =>
                          Navigator.of(context).pushNamed(AppRoutes.history),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _ActionCard(
                      title: '',
                      subtitle: '',
                      icon: Icons.bolt,
                      color: Colors.deepPurple.shade700,
                      onTap: () {},
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ActionCard(
                      title: '',
                      subtitle: '',
                      icon: Icons.videocam,
                      color: Colors.pink.shade700,
                      onTap: () =>
                          Navigator.of(context).pushNamed(AppRoutes.streaming),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
        if (_eventModalVisible)
          _EventModal(
            onClose: () => setState(() => _eventModalVisible = false),
            onTournaments: () {
              setState(() => _eventModalVisible = false);
              Navigator.of(context).pushNamed(AppRoutes.tournaments);
            },
          ),
      ],
    );
  }
}

class _TournamentBanner extends StatelessWidget {
  const _TournamentBanner({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade800.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.emoji_events, color: Colors.amber, size: 32),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tournoi Hebdomadaire - 100 000 FCFA',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Le grand tournoi commence vendredi ! Prix total : 100 000 FCFA. In...',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          IconButton(icon: const Icon(Icons.close), onPressed: onClose),
        ],
      ),
    );
  }
}

class _BalanceChip extends StatelessWidget {
  const _BalanceChip({required this.value});

  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.orange.shade800,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.monetization_on, color: Colors.white, size: 20),
          const SizedBox(width: 6),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          height: 140,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: Colors.white54, size: 28),
              if (title.isNotEmpty) ...[
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                if (subtitle.isNotEmpty)
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 11,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _EventModal extends StatelessWidget {
  const _EventModal({required this.onClose, required this.onTournaments});

  final VoidCallback onClose;
  final VoidCallback onTournaments;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black54,
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF1A2332),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.emoji_events, color: Colors.amber),
                      SizedBox(width: 8),
                      Text(
                        'ÉVÉNEMENT',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  IconButton(icon: const Icon(Icons.close), onPressed: onClose),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Tournoi Hebdomadaire - 100 000 FCFA',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Le grand tournoi hebdomadaire commence vendredi ! Prix total : 100 000 FCFA. Inscriptions ouvertes dès maintenant. Ne rate pas cette opportunité !',
                style: TextStyle(color: Colors.white.withOpacity(0.9)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onTournaments,
                  child: const Text('Voir les tournois'),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: onClose,
                  child: const Text('Plus tard'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
