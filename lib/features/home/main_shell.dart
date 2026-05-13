import 'package:flutter/material.dart';

import '../challenges/challenges_page.dart';
import '../history/history_page.dart';
import '../profile/profile_page.dart';
import '../streaming/streaming_page.dart';
import 'home_page.dart';

/// Shell principal : bottom nav (Accueil, Défis, Historique, Streaming, Profil).
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  static const _navItems = [
    (icon: Icons.home, label: 'Accueil'),
    (icon: Icons.search, label: 'Défis'),
    (icon: Icons.history, label: 'Historique'),
    (icon: Icons.videocam, label: 'Streaming'),
    (icon: Icons.person, label: 'Profil'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          HomePage(),
          ChallengesPage(),
          HistoryPage(),
          StreamingPage(),
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF0D1B2A),
        selectedItemColor: const Color(0xFF00BCD4),
        unselectedItemColor: Colors.white54,
        items: _navItems
            .map((e) => BottomNavigationBarItem(
                  icon: Icon(e.icon),
                  label: e.label,
                ))
            .toList(),
      ),
    );
  }
}
