# Prompt Generator - Projet Mobile React Native/Expo

Ce document contient les prompts pour generer l'architecture complete d'un projet mobile avec Claude Code.

---

## Table des Matieres

1. [Architecture Docker](#1-architecture-docker)
2. [CLAUDE.md - Instructions Projet](#2-claudemd---instructions-projet)
3. [ROADMAP.md - Planification](#3-roadmapmd---planification)
4. [Workflow Complet](#4-workflow-complet)

---

## 1. Architecture Docker

### PROMPT A COPIER

```
Cree une architecture Docker pour containeriser un projet React Native avec Expo.

### Nom du projet : [NOM_DU_PROJET]

### Structure de fichiers a generer :

1. **Dockerfile** - Image Node 20 Alpine avec :
   - Dependances : git, bash, curl, python3, make, g++
   - Workdir : /app
   - Ports exposes : 8081, 19000, 19001, 19002, 19006
   - CMD par defaut : sh

2. **docker-compose.yml** - Services :
   - **expo** : service principal React Native/Expo
     - Build depuis le Dockerfile local
     - Working_dir : /app/[NOM_DU_PROJET]
     - Command : npx expo start --lan
     - Volumes : code source + node_modules persiste
     - Ports : 19000, 19001, 19002, 19006, 8081
     - Environment : EXPO_DEVTOOLS_LISTEN_ADDRESS=0.0.0.0, REACT_NATIVE_PACKAGER_HOSTNAME=0.0.0.0
     - stdin_open et tty : true

   - **cli** : service pour commandes ponctuelles (npm install, etc.)
     - Meme image que expo
     - Working_dir : /app
     - Volumes partages avec expo (incluant node_modules)

   - **create** : service dedie a la creation de projet (IMPORTANT)
     - Meme image que expo
     - Working_dir : /app
     - Volumes : SEULEMENT le code source (PAS de volume node_modules)
     - Ce service evite le conflit avec le volume node_modules lors de la creation

   - Network : app-network (bridge)
   - Volume nomme : expo_node_modules

3. **Makefile** avec commandes :
   - help : affiche l'aide
   - build : docker-compose build
   - up : docker-compose up -d
   - dev : docker-compose up (foreground)
   - down : docker-compose down
   - stop : docker-compose stop
   - install : docker-compose run --rm cli sh -c "cd [NOM_DU_PROJET] && npm install"
   - shell : docker-compose exec expo sh
   - logs : docker-compose logs -f
   - clean : docker-compose down -v
   - prune : nettoyage complet
   - create-project : docker-compose run --rm create npx create-expo-app (utilise le service "create")
   - add-package : ajouter un package npm
   - tunnel : lancer en mode tunnel
   - web : lancer en mode web
   - restart : redemarrer les services

4. **.dockerignore** - Exclure :
   - .git, node_modules, .env, logs, build, dist, .expo, IDE files

5. **.gitignore** - Exclure :
   - node_modules, .env, .expo, coverage, dist, build, IDE files, OS files

### Commandes Docker pour creer le projet :

Genere aussi les commandes a executer dans l'ordre :

1. Construire l'image Docker
2. Nettoyer les volumes existants si necessaire (make clean)
3. Creer un nouveau projet Expo via le service "create" (sans volume node_modules)
4. Installer les dependances
5. Lancer le serveur de developpement

Format des commandes :
- Utiliser docker-compose run --rm create pour la creation de projet
- Utiliser docker-compose run --rm cli pour les commandes npm
- Utiliser make pour simplifier l'usage quotidien
```

---

## 2. CLAUDE.md - Instructions Projet

### PROMPT A COPIER

```
Genere un fichier CLAUDE.md complet pour un projet mobile [TYPE_APP] nomme [NOM_PROJET].

### Informations du projet :

**Nom** : [NOM_PROJET]
**Description** : [DESCRIPTION]
**Entreprise** : [ENTREPRISE]

### Utilisateurs cibles :
[Liste les roles utilisateurs et leurs fonctionnalites principales]
- Role 1 : description des fonctionnalites
- Role 2 : description des fonctionnalites
- Role 3 : description des fonctionnalites

### Stack technique :
- Framework : Expo SDK 52+, React Native, React 18+
- Routing : Expo Router (file-based)
- Data Fetching : SWR
- Animations : React Native Reanimated
- Auth : JWT + Expo Secure Store
- Build : EAS Build
- Linter : Biome
- Package Manager : bun
- Dev Environment : Docker
- Offline Storage : SQLite (expo-sqlite)
- [Ajouter d'autres technologies specifiques]

### Identite visuelle :

**Palette de couleurs** :
| Couleur | HEX | Usage |
|---------|-----|-------|
| Couleur principale | #XXXXXX | Usage |
| Couleur secondaire | #XXXXXX | Usage |
| Accent | #XXXXXX | Usage |
| [Autres couleurs] |

**Degrade principal** (si applicable) :
background: linear-gradient(XXXdeg, #XXXXX 0%, #XXXXX 100%);

**Typographie** :
| Element | Police | Graisse |
|---------|--------|---------|
| Titres | [Police] | Bold |
| Corps | [Police] | Regular |

### Structure du projet a generer :

[NOM_PROJET]/
├── app/                           # Pages Expo Router
│   ├── _layout.tsx               # Layout root
│   ├── index.tsx                 # Ecran d'accueil
│   ├── (auth)/                   # Ecrans non authentifies
│   └── (tabs)/                   # Navigation par onglets
├── components/                    # Composants reutilisables
│   ├── ui/                       # Composants primitifs
│   └── [domaine]/               # Composants par domaine
├── contexts/                      # Etat global React
├── hooks/                         # Hooks personnalises
├── services/                      # Logique metier
├── constants/                     # Constantes
├── types/                         # Types TypeScript
└── utils/                         # Fonctions utilitaires

### Modeles de donnees principaux :

[Decris les types TypeScript principaux de ton application]

Exemple :
type User = {
  id: string;
  email: string;
  // ...
};

### Conventions de nommage :

- Fichiers : kebab-case (my-component.tsx)
- Composants : PascalCase (MyComponent)
- Variables : camelCase (myVariable)
- Constantes : SCREAMING_SNAKE_CASE (MY_CONSTANT)
- Types : PascalCase (MyType)

### Git Workflow :

**Strategie** : 1 PR par Feature

**Branches** :
| Type | Convention | Exemple |
|------|------------|---------|
| Feature | feature/{phase}.{feature}-{nom} | feature/1.1-setup |
| Bugfix | fix/{description} | fix/login-bug |
| Hotfix | hotfix/{description} | hotfix/crash |

**Convention de commits** : type(scope): description
- feat, fix, refactor, style, docs, test, chore

### Regles de developpement :

1. Offline-first : Prevoir le fonctionnement sans connexion
2. Optimistic UI : MAJ interface immediate, sync ensuite
3. Types stricts : Pas de any
4. Composants atomiques : Un composant = une responsabilite
5. Hooks metier : Encapsuler la logique dans des hooks

### Endpoints API principaux :

| Methode | Endpoint | Description |
|---------|----------|-------------|
| POST | /auth/login | Connexion |
| GET | /resource | Liste ressources |
| [Autres endpoints] |

### Variables d'environnement :

API_URL=https://api.[domain].com
API_TIMEOUT=30000
# [Autres variables]

Genere le fichier CLAUDE.md complet avec toutes ces sections, formate en Markdown, pret a etre utilise par Claude Code.
```

---

## 3. ROADMAP.md - Planification

### PROMPT A COPIER

```
Genere un fichier ROADMAP.md pour planifier le developpement du projet [NOM_PROJET].

### Structure de la roadmap :

**Nombre de phases** : [X] phases
**Approche** : [offline-first, feature flags, etc.]

### Phases et features :

**Phase 1 : [Nom Phase]** (X features)
- Feature 1.1 : [Nom] - [X issues]
- Feature 1.2 : [Nom] - [X issues]
- ...

**Phase 2 : [Nom Phase]** (X features)
- Feature 2.1 : [Nom] - [X issues]
- ...

[Continuer pour toutes les phases]

### Legende des priorites :
- P0 : Critique / Bloquant
- P1 : Important
- P2 : Normal
- P3 : Nice-to-have

### Legende des offres (si applicable) :
- starter : Offre de base
- basic : Offre Basic+
- pro : Offre Pro+
- business : Offre Business

### Format souhaite pour chaque feature :

## Feature X.Y : [Nom de la Feature]

> [Description courte]

| Issue | Titre | Priorite | Offre | Statut |
|-------|-------|----------|-------|--------|
| #X.Y.1 | [Titre] | P0 | starter | ⬜ |
| #X.Y.2 | [Titre] | P1 | basic | ⬜ |

**Criteres d'acceptation :**
- [ ] Critere 1
- [ ] Critere 2

### Informations a inclure :

1. **Vue d'ensemble** avec barre de progression ASCII par phase
2. **Tableau recapitulatif** des PRs par feature avec :
   - Phase, Feature, Branche, Nombre d'issues, Statut PR
3. **Detail de chaque feature** avec :
   - Description
   - Tableau des issues
   - Criteres d'acceptation
4. **Mapping Features - Issues GitHub** (tableau recapitulatif)

### Symboles de statut :
- ⬜ A faire
- 🔄 En cours
- ✅ Termine
- ❌ Bloque

Genere le fichier ROADMAP.md complet, formate en Markdown, avec toutes les phases et features detaillees.
```

---

## 4. Workflow Complet

### PROMPT INITIAL POUR NOUVEAU PROJET

```
Je veux creer un nouveau projet mobile [TYPE_APP] nomme [NOM_PROJET] pour [ENTREPRISE].

### Description :
[Description detaillee du projet]

### Utilisateurs :
- [Role 1] : [Fonctionnalites]
- [Role 2] : [Fonctionnalites]

### Fonctionnalites principales :
1. [Feature principale 1]
2. [Feature principale 2]
3. [Feature principale 3]

### Contraintes techniques :
- Mode offline obligatoire : [oui/non]
- Multi-tenant : [oui/non]
- Offres/Plans differents : [oui/non]

### Charte graphique :
- Couleur principale : [HEX]
- Couleur secondaire : [HEX]
- Police : [Nom]

Genere-moi :
1. L'architecture Docker complete (Dockerfile, docker-compose, Makefile)
2. Le fichier CLAUDE.md avec toutes les instructions projet
3. Le fichier ROADMAP.md avec la planification en phases

Pour chaque fichier, donne-moi le contenu complet pret a etre copie.
```

---

## Commandes Docker de Base

Une fois l'architecture generee :

```bash
# 1. Construire l'image Docker
make build

# 2. Nettoyer (si necessaire)
make clean && rm -rf [NOM_DU_PROJET]

# 3. Creer le projet Expo
make create-project

# 4. Installer les dependances
make install

# 5. Lancer le serveur de dev
make dev
```

---

## Commandes Utiles au Quotidien

```bash
# Demarrer en arriere-plan
make up

# Voir les logs
make logs

# Acceder au shell du container
make shell

# Arreter les services
make down

# Nettoyer tout (attention : supprime node_modules)
make clean

# Installer un package npm
make add-package PKG=nom-du-package

# Lancer Expo en mode tunnel
make tunnel

# Lancer en mode web
make web

# Redemarrer les services
make restart
```

---

## Pourquoi un Service "CREATE" Separe ?

Le volume `expo_node_modules` est monte sur `/app/[NOM_DU_PROJET]/node_modules` pour persister les dependances.

**Probleme** : Si ce volume existe deja lors de la creation du projet, `create-expo-app` detecte un dossier `node_modules` et refuse de creer le projet.

**Solution** : Le service `create` ne monte PAS le volume `node_modules`, permettant une creation propre du projet.

---

## Acces

- **Expo DevTools (Web)** : http://localhost:19002
- **Metro Bundler** : http://localhost:8081
- **App Web** : http://localhost:19006

Scanner le QR code dans les logs pour ouvrir sur mobile (Expo Go).

---

## Exemple de Workflow Feature

Pour demarrer une nouvelle feature :

```bash
# 1. Rechercher les issues GitHub liees
gh issue list --limit 500 --state open --json number,title | grep -i "X.Y"

# 2. Creer la branche
git checkout main && git pull
git checkout -b feature/X.Y-nom-feature

# 3. Commit d'initialisation
git commit --allow-empty -m "feat(scope): init feature X.Y - Nom

Phase X.Y - Description (N issues)
Issues: #first - #last

Co-Authored-By: Claude <noreply@anthropic.com>"

# 4. Push et creer PR
git push -u origin feature/X.Y-nom-feature
gh pr create --title "feat: Nom Feature (Feature X.Y)" --body "..."
```
