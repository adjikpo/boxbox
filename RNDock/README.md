# 📱 React Native + Docker - Guide Complet

Documentation technique pour configurer, lancer et déployer un projet React Native containerisé avec Docker/Docker Compose.

---

## 📋 Table des matières

1. [Prérequis](#prérequis)
2. [Architecture du projet](#architecture-du-projet)
3. [Installation & Démarrage](#installation--démarrage)
4. [Configuration](#configuration)
5. [Commandes essentielles](#commandes-essentielles)
6. [Troubleshooting](#troubleshooting)
7. [Migration vers un nouveau projet](#migration-vers-un-nouveau-projet)
8. [Template pour nouveaux projets](#template-pour-nouveaux-projets)

---

## 🔧 Prérequis

Avant de commencer, assurez-vous d'avoir installé :

### Système d'exploitation
- **macOS** : Testé sur Monterey+
- **Linux** : Toute distribution récente (Ubuntu 20.04+, Debian 11+)
- **Windows** : WSL2 recommandé (Windows 10/11)

### Logiciels obligatoires
- **Docker** (v20.10+) : [Installation](https://docs.docker.com/get-docker/)
- **Docker Compose** (v2.0+) : Inclus avec Docker Desktop
- **Git** : Pour cloner le dépôt
- **Node.js** (v20+) : Optionnel sur macOS/Linux (Docker le fournit)

### Vérifier l'installation
```bash
docker --version
docker-compose --version
git --version
```

---

## 🏗️ Architecture du projet

### Structure des dossiers
```
project-root/
├── Dockerfile                 # Image principale Expo dev
├── docker-compose.yml         # Orchestration des services
├── docker-compose.init.yml    # Configuration initiale (optionnelle)
├── Makefile                   # Scripts de raccourci
├── .dockerignore               # Fichiers à ignorer en build Docker
├── .gitignore                  # Fichiers à ignorer en Git
├── README.md                   # Documentation du projet
│
├── LedgerTrack/               # 📱 Frontend React Native
│   ├── app/                   # Expo Router (navigation)
│   ├── components/            # Composants réutilisables
│   ├── hooks/                 # Custom React hooks
│   ├── context/               # Context API
│   ├── lib/                   # Utilitaires & helpers
│   ├── types/                 # TypeScript types
│   ├── assets/                # Images, fonts, etc.
│   ├── constants/             # Constantes globales
│   ├── package.json           # Dépendances frontend
│   └── .expo/                 # Configuration Expo
│
├── api/                       # 🖥️  Backend Node.js/Express
│   ├── server.js              # Entrée principale
│   ├── migrate.js             # Script migration BD
│   ├── package.json           # Dépendances backend
│   ├── .env                   # Variables d'environnement (IGNORÉ en Git)
│   ├── .env.example           # Template .env
│   └── data/                  # Base de données SQLite
│
└── node_modules/              # Dépendances (Docker volumes)
```

### Composants Docker

#### **Service `expo` (Frontend)**
- **Image** : `expo-dev:latest` (Node 20 Alpine)
- **Port** : 19000-19002, 19006, 8081
- **Commande** : `npx expo start --lan`
- **Volume** : Monte tout le projet + `expo_node_modules`
- **Variables d'env** : URL API, adresse dev tools

#### **Service `api` (Backend)**
- **Image** : Dockerfile personnalisé (Node 20 Alpine + tools build)
- **Port** : 4000
- **Commande** : `npm run start`
- **Volumes** : Code + `api_node_modules` + `api_data` (BD)
- **.env** : Configuration (JWT, CORS, DB path)

#### **Service `cli` (Utilitaire)**
- **Image** : Même que Expo
- **Usage** : Commandes ponctuelles (npm install, shell interactif, etc.)

#### **Volumes nommés**
- `expo_node_modules` : Cache npm frontend
- `api_node_modules` : Cache npm backend
- `api_data` : Persistance BD SQLite

---

## 🚀 Installation & Démarrage

### 1️⃣ Cloner le dépôt
```bash
git clone <URL_DU_REPO>
cd <PROJECT_NAME>
```

### 2️⃣ Configuration initiale
```bash
# Copier le template .env pour l'API
cp api/.env.example api/.env

# (Optionnel) Éditer les variables sensibles
# nano api/.env
```

### 3️⃣ Builder les images Docker
```bash
docker-compose build
```

*Cela construit les images `expo-dev:latest` et le service `api`.*

### 4️⃣ Lancer les services
```bash
docker-compose up
```

✅ Le projet est maintenant actif :
- **Frontend Expo** : http://localhost:19006 (Web)
- **Backend API** : http://localhost:4000
- **Tunnel Expo** : QR code affiché dans le terminal (Android/iOS)

### 5️⃣ Accéder à l'app (sur appareil mobile)
1. Installer **Expo Go** (App Store / Play Store)
2. Scannez le QR code du terminal
3. L'app charge sur votre téléphone

---

## ⚙️ Configuration

### Variables d'environnement (`api/.env`)

```bash
# Port serveur API
PORT=4000

# Secret JWT (génère un token sécurisé)
JWT_SECRET=your-secret-key-min-32-chars-change-me-in-prod

# CORS (origines autorisées)
CORS_ORIGIN=http://localhost:8081,http://localhost:19006,http://localhost:5173

# Environnement
NODE_ENV=development

# Chemin BD SQLite
DB_PATH=./data/ledgertrack.db
```

### Frontend (Expo)

Dans `docker-compose.yml`, modifier les variables d'env du service `expo` :

```yaml
environment:
  - EXPO_PUBLIC_API_URL=http://192.168.1.27:4000  # Adapter l'IP locale
  - REACT_NATIVE_PACKAGER_HOSTNAME=0.0.0.0
```

### Ports

| Service | Port(s) | Usage |
|---------|---------|-------|
| Expo Dev Server | 19000-19002 | Metro bundler |
| Expo Web | 19006 | Web preview |
| Expo Package | 8081 | Bundler alternatif |
| Backend API | 4000 | REST/JSON API |

---

## 🎯 Commandes essentielles

### Avec Makefile (Recommandé)
```bash
make help              # Afficher toutes les commandes

# Installation
make install           # npm install des dépendances

# Démarrage
make start-expo        # Lance Expo en tunnel

# Développement
make shell             # Shell interactif dans le container

# Nettoyage
make clean             # Arrête, supprime volumes et dépendances
```

### Sans Makefile (Docker Compose direct)

#### Démarrer tous les services
```bash
docker-compose up                    # Mode foreground
docker-compose up -d                 # Détaché (background)
docker-compose up --build            # Rebuild + start
```

#### Arrêter les services
```bash
docker-compose stop                  # Pause les services
docker-compose down                  # Arrête et supprime containers
docker-compose down -v               # Supprime aussi les volumes
```

#### Installer des dépendances
```bash
# Frontend
docker-compose run --rm cli npm install <PACKAGE>

# Backend
docker-compose exec api npm install <PACKAGE>
```

#### Logs en temps réel
```bash
docker-compose logs -f               # Tous les services
docker-compose logs -f expo          # Frontend seulement
docker-compose logs -f api           # Backend seulement
```

#### Exécuter des commandes ponctuelles
```bash
# Shell interactif
docker-compose run --rm cli sh

# Commandes npm
docker-compose run --rm cli npm run lint

# Migration BD (backend)
docker-compose exec api npm run migrate
```

#### Accéder au container en direct
```bash
docker-compose exec expo sh          # Frontend shell
docker-compose exec api sh           # Backend shell
```

#### Redémarrer un service
```bash
docker-compose restart expo
docker-compose restart api
```

---

## 🐛 Troubleshooting

### ❌ "Port 4000 already in use"
```bash
# Trouver le processus
lsof -i :4000

# Tuer le processus
kill -9 <PID>

# Ou changer le port dans docker-compose.yml
# ports:
#   - "4001:4000"  # Externe:Interne
```

### ❌ "npm install fails with 'better-sqlite3'"
```bash
# Le Dockerfile API inclut python3, make, g++
# Vérifier que apk add s'exécute correctement
docker-compose build --no-cache api

# Sinon, installer sur le système hôte (macOS)
brew install python3
```

### ❌ "Expo QR code doesn't appear"
```bash
# Vérifier que le container est actif
docker-compose ps

# Regarder les logs
docker-compose logs expo

# Solution : redémarrer
docker-compose restart expo
```

### ❌ "Cannot connect to API from Expo"
- Vérifier l'IP locale dans `EXPO_PUBLIC_API_URL`
  ```bash
  ifconfig | grep "inet " | grep -v 127.0.0.1
  ```
- Mettre à jour `docker-compose.yml` avec la bonne IP
- Redémarrer le service Expo

### ❌ "Volumes not mounted correctly"
```bash
# Vérifier les volumes
docker volume ls
docker volume inspect <VOLUME_NAME>

# Recréer les volumes
docker-compose down -v
docker-compose up --build
```

### ❌ "Permission denied" sur ./data/
```bash
# Fixer les permissions
sudo chown -R $(id -u):$(id -g) ./api/data

# Ou créer le dossier en avance
mkdir -p api/data
```

---

## 📦 Ajouter une nouvelle dépendance

### Frontend (React Native)
```bash
docker-compose run --rm cli npm install <PACKAGE_NAME>
# Exemple:
docker-compose run --rm cli npm install axios
```

### Backend (API Node.js)
```bash
docker-compose exec api npm install <PACKAGE_NAME>
# Exemple:
docker-compose exec api npm install lodash
```

*Après l'installation, les changements sont sauvegardés dans `package-lock.json` et les volumes.*

---

## 🔄 Migration vers un nouveau projet

### Copier la structure Docker

1. **Copier les fichiers Docker du projet source**
   ```bash
   cp Dockerfile docker-compose.yml .dockerignore Makefile /NOUVEAU_PROJET/
   ```

2. **Adapter la structure**
   ```bash
   # Structure recommandée pour nouveau projet
   NOUVEAU_PROJET/
   ├── Dockerfile (Node 20 Alpine)
   ├── docker-compose.yml
   ├── Makefile
   ├── .dockerignore
   ├── MyApp/                  # Dossier app React Native
   │   └── package.json
   └── api/                    # (Si besoin)
       ├── Dockerfile
       ├── package.json
       └── .env.example
   ```

3. **Mettre à jour les variables**
   - Ports dans `docker-compose.yml`
   - Variables d'env
   - Chemins des dossiers

4. **Builder et lancer**
   ```bash
   docker-compose build
   docker-compose up
   ```

---

## 🎨 Template pour nouveaux projets

### Utiliser comme base

```bash
# Copier le dossier RNDock en nouvelle base
cp -r chemin/Projets/boxbox/RNDock ~/MonNouvauProjet

cd ~/MonNouvauProjet
rm -rf LedgerTrack api                  # Supprimer ancien code
mkdir MonApp && cd MonApp
npx create-expo-app@latest .            # Créer app Expo
```

### Fichiers à toujours inclure

| Fichier | Rôle |
|---------|------|
| `Dockerfile` | Build principal |
| `docker-compose.yml` | Orchestration services |
| `Makefile` | Raccourcis commandes |
| `.dockerignore` | Exclure fichiers du build |
| `api/.env.example` | Template variables |

### Checklist de configuration

- [ ] Tous les Dockerfiles présents ?
- [ ] Ports adaptés au projet ?
- [ ] `.env.example` en place ?
- [ ] `.gitignore` inclut `.env` et `node_modules/` ?
- [ ] Volumes nommés créés dans docker-compose ?
- [ ] Variables d'env frontend pointent vers la bonne API ?

---

## 📚 Ressources supplémentaires

- [Docker Documentation](https://docs.docker.com)
- [Docker Compose Reference](https://docs.docker.com/compose/compose-file/)
- [Expo Documentation](https://docs.expo.dev)
- [React Native Guide](https://reactnative.dev/docs/getting-started)
- [Express.js Docs](https://expressjs.com/)

---

## 💡 Bonnes pratiques

✅ **À faire**
- Committer `.env.example` (pas `.env`)
- Utiliser volumes nommés pour persistance
- Buildfiles séparés pour frontend/backend
- Déclarer `depends_on` pour l'ordre de démarrage
- Vérifier les logs régulièrement

❌ **À éviter**
- Hardcoder les secrets en production
- Lancer les services sans volumes
- Utiliser `node:latest` (toujours spécifier version)
- Ignorer les erreurs de build
- Développer directement sans containers

---

**Dernière mise à jour** : Oct 2024  
**Version Node** : 20 Alpine  
**Version Expo** : 54.0.20+  

Pour toute question, consultez la section Troubleshooting ou les logs Docker.
