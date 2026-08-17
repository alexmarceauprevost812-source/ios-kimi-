import 'package:flutter/material.dart';

/// Avatar officiel de l'app — la mascotte animée (GIF).
///
/// Le fichier `assets/mascot.gif` doit exister dans le projet.
class MascotAvatar extends StatelessWidget {
  const MascotAvatar({super.key, this.size = 36});

  final double size;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Image.asset(
        'assets/mascot.gif',
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => CircleAvatar(
          radius: size / 2,
          child: Icon(Icons.smart_toy, size: size * 0.6),
        ),
      ),
    );
  }
}
