# RNDock - React Native / Expo Docker Template

Template Docker pour containeriser des projets React Native avec Expo.

---

## Demarrage rapide

### Option 1 : Utiliser le Makefile

```bash
# 1. Copier RNDock dans votre dossier projet
cp -r RNDock ~/mon-projet
cd ~/mon-projet

# 2. Modifier PROJECT_NAME dans le Makefile (ligne 5)
# PROJECT_NAME ?= MonApp

# 3. Modifier [NOM_DU_PROJET] dans docker-compose.yml
# Remplacer toutes les occurrences par le nom de votre projet

# 4. Initialiser le projet
make build
make create-project
make install
make dev
```

### Option 2 : Utiliser le prompt IA

Voir [PROMPT_GENERATOR.md](PROMPT_GENERATOR.md) pour generer l'architecture via une IA.

---

## Structure du projet

```
[NOM_DU_PROJET]/
├── Dockerfile              # Image Node 20 Alpine + Expo
├── docker-compose.yml      # Services : expo, cli, create
├── Makefile                # Commandes raccourcis
├── .dockerignore
├── .gitignore
├── PROMPT_GENERATOR.md     # Prompt pour IA
└── [NOM_DU_PROJET]/        # Projet Expo cree
    ├── app/
    ├── package.json
    └── ...
```

---

## Commandes Makefile

```bash
# Initialisation
make build                    # Construire l'image Docker
make create-project           # Creer un nouveau projet Expo
make install                  # Installer les dependances npm
make init                     # Tout en un (build + create + install)

# Developpement
make up                       # Demarrer Expo en arriere-plan
make dev                      # Demarrer Expo avec logs
make down                     # Arreter les services
make stop                     # Pause les services
make restart                  # Redemarrer les services

# Utilitaires
make shell                    # Shell dans le container
make logs                     # Voir les logs
make add-package PKG=name     # Ajouter un package npm
make tunnel                   # Lancer en mode tunnel
make web                      # Lancer en mode web

# Nettoyage
make clean                    # Supprimer containers et volumes
make prune                    # Nettoyage complet Docker
```

---

## Commandes Docker Compose directes

```bash
# Construire l'image
docker-compose build

# Creer un projet (utilise le service "create" sans volume node_modules)
docker-compose run --rm create npx create-expo-app [NOM_DU_PROJET] --template blank

# Installer les dependances
docker-compose run --rm cli npm install

# Demarrer Expo
docker-compose up expo

# Arreter
docker-compose down

# Voir les logs
docker-compose logs -f expo

# Shell interactif
docker-compose run --rm cli sh

# Ajouter un package
docker-compose run --rm cli npm install [PACKAGE]

# Mode tunnel
docker-compose run --rm cli npx expo start --tunnel

# Mode web
docker-compose run --rm cli npx expo start --web

# Nettoyer (supprime les volumes)
docker-compose down -v
```

---

## Services Docker

| Service | Role | Volume node_modules |
|---------|------|---------------------|
| expo | Serveur de dev Expo | Oui |
| cli | Commandes npm | Oui |
| create | Creation de projet | Non (evite le conflit) |

### Pourquoi un service "create" separe ?

Le volume `expo_node_modules` est monte sur `/app/[NOM_DU_PROJET]/node_modules`.
Si ce volume existe lors de la creation, `create-expo-app` detecte un dossier non vide et refuse de creer le projet.
Le service `create` ne monte PAS ce volume, permettant une creation propre.

---

## Acces

- **Expo DevTools** : http://localhost:19002
- **Metro Bundler** : http://localhost:8081
- **App Web** : http://localhost:19006

Scanner le QR code dans les logs pour ouvrir sur mobile (Expo Go).

---

## Troubleshooting

**"Directory not empty"**
```bash
make clean
rm -rf [NOM_DU_PROJET]
make create-project
```

**"Metro bundler not starting"**
```bash
make restart
# ou
make clean && make build && make dev
```

**"Cannot connect from mobile"**
```bash
# Utiliser le mode tunnel
make tunnel
```

---

## Ressources

- [Expo Documentation](https://docs.expo.dev/)
- [React Native Documentation](https://reactnative.dev/)
- [Docker Documentation](https://docs.docker.com/)

---

**RNDock** - Template Docker pour projets React Native/Expo

Pour demarrer : voir [PROMPT_GENERATOR.md](PROMPT_GENERATOR.md) ou utiliser le Makefile
