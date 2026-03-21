// Copie `.env.local.json` → `assets/env.json` pour lancer depuis Android Studio sans --dart-define.
// Usage (à la racine du projet) : dart run tool/sync_env.dart

import 'dart:io';

void main() {
  final root = Directory.current;
  final src = File.fromUri(root.uri.resolve('.env.local.json'));
  final dest = File.fromUri(root.uri.resolve('assets/env.json'));

  if (!src.existsSync()) {
    stderr.writeln(
      'Fichier introuvable : .env.local.json\n'
      'Créez-le ou utilisez flutter run --dart-define-from-file=.env.local.json',
    );
    exitCode = 1;
    return;
  }

  dest.parent.createSync(recursive: true);
  src.copySync(dest.path);
  stdout.writeln('OK : assets/env.json mis à jour depuis .env.local.json');
}
