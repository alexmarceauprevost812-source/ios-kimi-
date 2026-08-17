# ios-kimi

<img src="assets/mascot.gif" alt="Mascotte officielle" width="180">

Un client **Kimi** (Moonshot AI) **open source** et multiplateforme, écrit en **Flutter** — iOS, Android, et plus.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

## Fonctionnalités

- 💬 Chat conversationnel avec Kimi
- 🎭 Mascotte officielle animée (écran d'accueil + barre de titre)
- 🌙 Mode sombre / clair
- ☁️ Supabase prêt pour l'authentification et la synchro (à configurer)
- 📱 Une seule base de code pour iOS et Android

## Structure du projet

```
assets/
└── mascot.gif                   # Mascotte officielle de l'app
lib/
├── main.dart                    # Point d'entrée
├── models/
│   └── chat_message.dart        # Modèle de message
├── services/
│   └── kimi_api_service.dart    # Client API Kimi (Moonshot AI)
├── viewmodels/
│   └── chat_view_model.dart     # État du chat (Provider)
├── screens/
│   └── chat_screen.dart         # Écran de chat + accueil
└── widgets/
    ├── message_bubble.dart      # Bulle de message
    └── mascot_avatar.dart       # Avatar de la mascotte
```

## Démarrage

1. Installe [Flutter](https://docs.flutter.dev/get-started/install) (fonctionne sur Windows).
2. Clone le dépôt :
   ```bash
   git clone https://github.com/alexmarceauprevost812-source/ios-kimi-.git
   cd ios-kimi-
   git checkout supabase
   ```
3. Génère les dossiers de plateformes (android/, ios/, etc.) :
   ```bash
   flutter create .
   ```
4. Installe les dépendances :
   ```bash
   flutter pub get
   ```
5. Lance l'app avec ta clé API Kimi :
   ```bash
   flutter run --dart-define=KIMI_API_KEY=sk-ta-cle-api
   ```

## Configuration Supabase (optionnel)

```bash
flutter run \
  --dart-define=KIMI_API_KEY=sk-ta-cle-api \
  --dart-define=SUPABASE_URL=https://ton-projet.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=ta-cle-anon
```

## Note pour iOS

La compilation iOS nécessite un Mac avec Xcode (ou un Mac dans le cloud).
Sur Windows, tu peux développer et tester sur Android, puis compiler pour iOS plus tard.

## Contribuer

Ce projet est **open source** (licence MIT) — les contributions sont les bienvenues !

## Licence

[MIT](LICENSE)
