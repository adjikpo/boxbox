# 🏗️ Architecture du Projet React Native + Docker

Document technique détaillant l'organisation, les composants et les flux du projet.

---

## 📐 Vue d'ensemble

```
┌─────────────────────────────────────────────────────────┐
│                      APPAREIL MOBILE                      │
│  (iOS / Android)                                          │
│  ┌─────────────────────────────────────────────────────┐ │
│  │          Expo Go Application                         │ │
│  │  - React Native Components                           │ │
│  │  - Navigation (Expo Router)                          │ │
│  │  - Local Storage / Context API                       │ │
│  └─────────────────────────────────────────────────────┘ │
└────────────────┬────────────────────────────────────────┘
                 │ HTTP/WebSocket
                 │ (via réseau local)
┌────────────────▼────────────────────────────────────────┐
│              DOCKER HOST (votre ordinateur)               │
│                                                           │
│  ┌──────────────────────────┐  ┌─────────────────────┐  │
│  │  CONTAINER: Expo Dev     │  │  CONTAINER: API     │  │
│  │  ────────────────────    │  │  ────────────────   │  │
│  │  - Node 20 Alpine        │  │  - Node 20 Alpine   │  │
│  │  - Expo CLI              │  │  - Express.js       │  │
│  │  - Metro Bundler         │  │  - SQLite           │  │
│  │  - Port: 19006 (web)     │  │  - Port: 4000       │  │
│  │  - Port: 8081 (alt)      │  │                     │  │
│  │  - Volumes: src mounted  │  │  - Volume: data/    │  │
│  └──────────────────────────┘  └─────────────────────┘  │
│                                                           │
│  ┌──────────────────────────────────────────────────┐   │
│  │  NETWORK: app-network (bridge)                    │   │
│  │  Permet la communication inter-containers         │   │
│  └──────────────────────────────────────────────────┘   │
└───────────────────────────────────────────────────────────┘
```

---

## 📁 Structure des fichiers

### Racine du projet

```
project-root/
├── Dockerfile                   # Build pour frontend Expo
├── api.Dockerfile              # Build pour backend API
├── docker-compose.yml          # Orchestration des services
├── Makefile                    # Commandes raccourcis
├── .dockerignore               # Fichiers exclus du build Docker
├── .gitignore                  # Fichiers exclus de Git
├── api.env.example             # Template variables API
├── ARCHITECTURE.md             # Ce fichier
└── README.md                   # Documentation principale
```

### Frontend React Native

```
LedgerTrack/                    # Dossier app React Native
├── app/                        # Expo Router (navigation file-based)
│   ├── (tabs)/                # Stack de tabs (layout groupé)
│   │   ├── home.tsx           # Écran principal
│   │   ├── settings.tsx        # Paramètres
│   │   └── _layout.tsx         # Configuration des tabs
│   ├── _layout.tsx             # Root layout
│   └── index.tsx               # Écran initial
│
├── components/                 # Composants réutilisables
│   ├── Navigation.tsx
│   ├── Button.tsx
│   ├── Card.tsx
│   └── ...
│
├── hooks/                      # Custom React hooks
│   ├── useAuth.ts
│   ├── useApi.ts
│   └── useLocalStorage.ts
│
├── context/                    # Context API (state management)
│   ├── AuthContext.tsx
│   ├── ThemeContext.tsx
│   └── NotificationContext.tsx
│
├── lib/                        # Utilitaires & helpers
│   ├── api.ts                 # Configuration Axios/Fetch
│   ├── storage.ts             # AsyncStorage wrapper
│   ├── validators.ts          # Validation des données
│   └── helpers.ts             # Fonctions utilitaires
│
├── types/                      # TypeScript types/interfaces
│   ├── api.ts                 # Types API
│   ├── models.ts              # Modèles de données
│   └── index.ts               # Export central
│
├── constants/                  # Constantes globales
│   ├── colors.ts
│   ├── spacing.ts
│   └── api.ts
│
├── assets/                     # Ressources statiques
│   ├── images/
│   ├── fonts/
│   └── icons/
│
├── package.json               # Dépendances frontend
├── tsconfig.json              # Configuration TypeScript
├── .expo/                      # Config Expo (généré)
└── babel.config.js            # Configuration Babel
```

### Backend API

```
api/                           # Dossier API Node.js/Express
├── server.js                  # Point d'entrée principal
├── migrate.js                 # Script de migration BD
├── package.json               # Dépendances backend
├── .env.example               # Template variables (.env en .gitignore)
│
├── middleware/                # Express middlewares
│   ├── auth.js               # Authentification JWT
│   ├── errorHandler.js       # Gestion des erreurs
│   └── cors.js               # CORS
│
├── routes/                    # Routes API
│   ├── auth.js               # POST /auth/login, /auth/register
│   ├── users.js              # GET /users, POST /users
│   ├── transactions.js       # GET /transactions, POST /transactions
│   └── index.js              # Agrégation des routes
│
├── controllers/               # Logic métier
│   ├── authController.js     # Logique authentification
│   ├── userController.js     # Logique utilisateurs
│   └── transactionController.js
│
├── models/                    # Models BD / Schemas
│   ├── User.js
│   ├── Transaction.js
│   └── db.js                 # Initialisation BD
│
├── utils/                     # Utilitaires
│   ├── validation.js         # Validation données
│   ├── jwt.js               # Fonctions JWT
│   └── logger.js            # Logging
│
├── data/                      # Données (volume Docker)
│   └── ledgertrack.db        # Base SQLite
│
└── node_modules/              # Dépendances (volume Docker)
```

---

## 🔄 Flux de données

### 1. Démarrage de l'application

```
1. docker-compose up
   ├── Build image Dockerfile (Node 20 Alpine)
   ├── Créer volumes nommés
   ├── Lancer service Expo
   │   ├── npm install (si node_modules absent)
   │   ├── npx expo start --lan
   │   └── Attendre le QR code
   │
   └── Lancer service API
       ├── npm install (si node_modules absent)
       ├── npm run start
       ├── Charger .env
       ├── Initialiser BD SQLite
       └── Écouter sur http://localhost:4000
```

### 2. Interaction utilisateur (sur mobile)

```
Utilisateur ouvre l'app
   ↓
App charge depuis Expo Metro Bundler
   ├── Télécharge le bundle React Native
   ├── Exécute le code JavaScript
   └── Rend l'UI native
   ↓
Utilisateur interagit (tap, input, etc)
   ↓
EventListener déclenche action
   ├── Mise à jour Context/State
   ├── Si besoin: appel API
   │   └── axios.get/post vers http://192.168.1.27:4000/api/...
   │   └── Réponse JSON
   └── Mise à jour UI
```

### 3. Appel API

```
Frontend
  │
  ├─→ useApi().get('/transactions')
      │
      ├─→ axios.get('http://192.168.1.27:4000/api/transactions')
          │
          └─→ [Network: HTTP GET]
              │
              └─→ Backend API Container
                  │
                  ├─→ Express Router
                  ├─→ Middleware (auth, CORS)
                  ├─→ Controller transactionController
                  ├─→ Model/Database query
                  ├─→ SQLite response
                  └─→ JSON response (200)
                  │
              └─→ [Network: HTTP Response + JSON]
              │
      ├─→ axios interceptor handling
      ├─→ Context update
      └─→ UI re-render
```

---

## 🐳 Services Docker

### Service 1: `expo` (Frontend Development)

**Image**: `expo-dev:latest`  
**Base**: Node 20 Alpine  
**Ports**:
- 19000-19002: Expo dev server
- 19006: Expo web preview
- 8081: Alternative bundler

**Volumes**:
- `./` → `/app` (projet monté)
- `expo_node_modules` → `/app/LedgerTrack/node_modules` (cache)

**Variables d'env**:
```bash
EXPO_PUBLIC_API_URL=http://192.168.1.27:4000
REACT_NATIVE_PACKAGER_HOSTNAME=0.0.0.0
EXPO_DEVTOOLS_LISTEN_ADDRESS=0.0.0.0
```

**Commande**: `npx expo start --lan`

### Service 2: `api` (Backend)

**Image**: API personnalisée (api.Dockerfile)  
**Base**: Node 20 Alpine + tools build (python3, g++, make)  
**Port**: 4000

**Volumes**:
- `./api` → `/app` (code)
- `api_node_modules` → `/app/node_modules` (cache)
- `api_data` → `/app/data` (BD persistante)

**Env file**: `api/.env`

**Commande**: `npm run start`

### Service 3: `cli` (Utilitaire)

**Image**: Même que `expo`  
**Usage**: Commandes ponctuelles (npm install, shell)  
**Mode**: `--rm` (auto-suppression après exécution)

---

## 🗄️ Gestion des données

### Volumes nommés

| Volume | Mountpoint | Rôle |
|--------|-----------|------|
| `expo_node_modules` | `/app/LedgerTrack/node_modules` | Cache npm frontend |
| `api_node_modules` | `/app/node_modules` (API) | Cache npm backend |
| `api_data` | `/app/data` | BD SQLite persistante |

**Pourquoi ?** Les volumes nommés survivent aux redémarrages et permettent la persistance des données.

### Base de données (SQLite)

```
api/data/ledgertrack.db
↓
Volume Docker: api_data
↓
Accessible: docker-compose exec api sqlite3 /app/data/ledgertrack.db
↓
Backup: cp -r api/data ~/backup/
```

---

## 🔐 Configuration & Secrets

### Variables d'environnement

**Backend** (`api/.env`):
```bash
PORT=4000
JWT_SECRET=<generated-key>
NODE_ENV=development
CORS_ORIGIN=http://localhost:19006,...
DB_PATH=./data/ledgertrack.db
```

**Frontend** (hardcoded ou env Expo):
```javascript
const API_URL = process.env.EXPO_PUBLIC_API_URL;
// = http://192.168.1.27:4000
```

### Sécurité

✅ **À faire**:
- `.env` en `.gitignore`
- Committer `.env.example`
- Secrets dans variables d'env
- Générer JWT_SECRET fort

❌ **À éviter**:
- Hardcoder secrets dans le code
- Committer `.env` en Git
- Utiliser les mêmes secrets partout

---

## 🚀 Cycle de déploiement local

```
1. git clone <repo>
2. cd <repo>
3. cp api/.env.example api/.env
4. docker-compose build
5. docker-compose up
6. Vérifier les logs: docker-compose logs -f
7. Scanner QR code Expo avec téléphone
```

---

## 🔧 Dépendances principales

### Frontend
- **react-native**: Framework mobile cross-platform
- **expo**: Plateforme pour React Native
- **expo-router**: Navigation file-based (Next.js-like)
- **axios**: HTTP client
- **zustand/context-api**: State management

### Backend
- **express**: Framework web
- **better-sqlite3**: BD SQLite
- **jsonwebtoken**: JWT pour auth
- **bcryptjs**: Hash passwords
- **cors**: CORS middleware
- **helmet**: Security headers
- **dotenv**: Load .env

---

## 📊 Schéma d'authentification

```
Frontend                        Backend
  │                               │
  ├─→ POST /auth/register        │
  │   └─→ { email, password }    │
  │                               ├─→ Validate input
  │                               ├─→ Hash password (bcrypt)
  │                               ├─→ Save to BD
  │                               └─→ 201 + { user, token }
  │                               │
  ├─→ POST /auth/login           │
  │   └─→ { email, password }    │
  │                               ├─→ Find user
  │                               ├─→ Compare password
  │                               ├─→ Sign JWT token
  │                               └─→ 200 + { token }
  │                               │
  ├─→ GET /api/transactions      │
  │   ├─→ Header: Authorization: Bearer <token>
  │                               ├─→ Verify JWT
  │                               ├─→ Extract userId
  │                               ├─→ Query DB
  │                               └─→ 200 + transactions[]
  │
  Store token in device storage
  Include in all API requests
```

---

## 🐛 Debugging

### Logs

```bash
# Tous les logs
docker-compose logs -f

# Frontend
docker-compose logs -f expo
docker-compose exec expo npx react-native log-android

# Backend
docker-compose logs -f api
docker-compose exec api npm run dev (si script disponible)
```

### DevTools Expo

```
Appuyez sur 'm' dans le terminal Expo
Ouvre React Native Debugger
```

### Network Inspector

```
Appuyez sur 'r' dans le terminal Expo
Relance l'app
```

---

## 📈 Scalabilité future

### Pour production

1. **Séparation des environments**: dev, staging, prod
2. **Multi-container**: Load balancer, reverse proxy (Nginx)
3. **Database**: PostgreSQL au lieu de SQLite
4. **Caching**: Redis
5. **Monitoring**: Prometheus, Grafana
6. **CI/CD**: GitHub Actions, GitLab CI
7. **Registry**: Docker Hub, ECR

### Structure future

```
docker-compose.yml (dev)
docker-compose.prod.yml (production)
docker-compose.staging.yml (staging)
nginx/
  └── nginx.conf
postgres/
  └── init.sql
monitoring/
  ├── prometheus.yml
  └── grafana/
```

---

## 📚 Ressources

- [Expo Architecture](https://docs.expo.dev/overview/)
- [Express.js Guide](https://expressjs.com/en/guide/routing.html)
- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)
- [React Native Navigation](https://reactnavigation.org/)

---

**Document généré**: Oct 2024  
**Versions ciblées**: Node 20, Expo 54, React Native 0.81
