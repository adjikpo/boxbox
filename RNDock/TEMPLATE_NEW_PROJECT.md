# 🎨 Template pour Nouveau Projet React Native + Docker

Guide étape par étape pour créer un nouveau projet à partir de cette structure.

---

## 📋 Fichiers à copier

Ces fichiers forment la base Docker de tout nouveau projet RN :

```
COPIER VERS NOUVEAU PROJET:
├── Dockerfile               # Image frontend
├── api.Dockerfile          # Image backend (renommer en api/Dockerfile)
├── docker-compose.yml      # Orchestration
├── Makefile                # Raccourcis commandes
├── .dockerignore           # Exclusions build
├── .gitignore              # Exclusions Git
├── api.env.example         # Template .env (renommer en api/.env.example)
├── ARCHITECTURE.md         # Docs architecture
├── QUICKSTART.md           # Guide rapide
└── README.md               # Documentation complète
```

---

## 🚀 Procédure complète

### 1️⃣ Créer le dossier projet (2 min)

```bash
# A. Copier la base Docker
cp -r chemin/Projets/boxbox/RNDock ~/MonProjet
cd ~/MonProjet

# B. Initialiser Git
git init
git remote add origin <YOUR_REPO_URL>
```

### 2️⃣ Structurer le projet (3 min)

```bash
# Supprimer l'ancien code (si copié)
rm -rf LedgerTrack

# A. Créer l'app React Native
mkdir MonApp
cd MonApp

# B. Initialiser Expo (3 options)

# Option 1: Depuis le container (recommandé)
cd ..
docker-compose build
docker-compose run --rm cli npx create-expo-app@latest MonApp

# Option 2: Localement (besoin Node.js)
npx create-expo-app@latest .
cd ..

# Option 3: Modèle avancé
npx create-expo-app@latest . --template
cd ..
```

### 3️⃣ Structurer l'API (2 min)

```bash
# Créer dossier API
mkdir api
cd api

# Initialiser Node.js
npm init -y

# Renommer les fichiers Docker
cp ../api.Dockerfile ./Dockerfile
cp ../api.env.example ./.env.example

# Créer .env pour développement (IGNORÉ par Git)
cp .env.example .env

cd ..
```

### 4️⃣ Mettre à jour les configurations (3 min)

#### A. Adapter `docker-compose.yml`

```yaml
# Mettre à jour:
services:
  expo:
    working_dir: /app/MonApp    # ← Changer le nom du dossier
    environment:
      - EXPO_PUBLIC_API_URL=http://192.168.1.X:4000  # ← Adapter IP
      
  api:
    # Pas de changement nécessaire (générique)
```

#### B. Mettre à jour `api/.env`

```bash
# Adapter les variables
PORT=4000
JWT_SECRET=your-new-secret-key-min-32-chars
CORS_ORIGIN=http://localhost:8081,http://localhost:19006
NODE_ENV=development
DB_PATH=./data/myapp.db
```

#### C. Vérifier `.gitignore`

```bash
# Ajouter si manquant
echo "
api/.env
!api/.env.example
api/data/
node_modules/
.env
" >> .gitignore
```

### 5️⃣ Installer les dépendances (5 min)

```bash
# Frontend
docker-compose run --rm cli npm install

# Backend (exemple packages utiles)
docker-compose exec api npm install express cors helmet jsonwebtoken bcryptjs
docker-compose exec api npm install --save-dev nodemon
```

### 6️⃣ Vérifier la structure

```bash
# Résultat attendu:
tree -L 2 -I 'node_modules'

project/
├── Dockerfile
├── api.Dockerfile
├── docker-compose.yml
├── Makefile
├── .dockerignore
├── .gitignore
├── api/
│   ├── Dockerfile
│   ├── package.json
│   ├── .env.example
│   ├── .env (IGNORÉ)
│   └── server.js (à créer)
├── MonApp/
│   ├── package.json
│   ├── app/
│   ├── components/
│   └── ...
├── README.md
├── ARCHITECTURE.md
└── QUICKSTART.md
```

### 7️⃣ Tester (3 min)

```bash
# Builder
docker-compose build

# Lancer
docker-compose up -d

# Vérifier
docker-compose ps
docker-compose logs -f --tail=20

# Arrêter
docker-compose stop
```

---

## ✅ Checklist avant de committer

- [ ] Structure créée (`MonApp/`, `api/`)
- [ ] `docker-compose.yml` adapté (noms dossiers, IP)
- [ ] `api/.env.example` en place
- [ ] `api/.env` en `.gitignore`
- [ ] Tous les Dockerfiles présents
- [ ] `docker-compose build` réussit
- [ ] `docker-compose up` fonctionne
- [ ] API sur http://localhost:4000
- [ ] Frontend sur http://localhost:19006
- [ ] Dépendances installées (package-lock.json)

---

## 📝 Customisations courantes

### Changer les noms de dossiers

Si votre app s'appelle `MyApp` au lieu de `MonApp` :

```yaml
# docker-compose.yml
services:
  expo:
    working_dir: /app/MyApp
    volumes:
      - ./:/app
      - expo_node_modules:/app/MyApp/node_modules
```

### Changer les ports

```yaml
# docker-compose.yml
services:
  api:
    ports:
      - "5000:4000"  # ← External:Internal
  
  expo:
    ports:
      - "20000:19000"
      - "20001:19001"
      - "20006:19006"
```

### Ajouter des services (BD, Redis, etc)

```yaml
# docker-compose.yml
services:
  # ... expo, api, cli ...
  
  postgres:
    image: postgres:15-alpine
    environment:
      POSTGRES_PASSWORD: mypassword
      POSTGRES_DB: myapp
    volumes:
      - postgres_data:/var/lib/postgresql/data
    ports:
      - "5432:5432"

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"

volumes:
  postgres_data:
  expo_node_modules:
  api_node_modules:
  api_data:
```

### Mode production

Créer `docker-compose.prod.yml` :

```yaml
version: '3.8'

services:
  api:
    build:
      context: ./api
      dockerfile: Dockerfile.prod  # ← Dockerfile optimisé
    environment:
      NODE_ENV: production
    restart: always
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:4000/health"]
      interval: 30s
      timeout: 10s
      retries: 3

  # Frontend: build statique (Next.js, etc)
  web:
    build:
      context: ./
      dockerfile: Dockerfile.web  # ← Webpack/Next.js build
    ports:
      - "80:3000"
    restart: always

volumes:
  api_data:
```

Lancer : `docker-compose -f docker-compose.prod.yml up`

---

## 🔄 Migration d'un projet existant

Si vous avez déjà un projet RN qu'il faut dockeriser :

```bash
# 1. Copier les fichiers Docker
cp chemin/Projets/boxbox/RNDock/Dockerfile .
cp chemin/Projets/boxbox/RNDock/docker-compose.yml .
cp chemin/Projets/boxbox/RNDock/Makefile .
cp chemin/Projets/boxbox/RNDock/.dockerignore .

# 2. Adapter les noms dans docker-compose.yml
nano docker-compose.yml
# Changer: working_dir: /app/<NOM_DOSSIER_APP>
# Changer: CORS_ORIGIN avec bonne IP

# 3. Builder et tester
docker-compose build
docker-compose up
```

---

## 🎯 Prochaines étapes

Après cette mise en place :

1. **Développer l'API** : `api/server.js` + routes
2. **Développer le frontend** : `MonApp/app/` + components
3. **Configurer l'auth** : JWT + Context API
4. **Committer** : `git add . && git commit -m "Init docker setup"`
5. **Déployer** : Suivre docs de production

---

## 📚 Ressources

- [Expo Documentation](https://docs.expo.dev)
- [Express.js Guide](https://expressjs.com)
- [Docker Compose Reference](https://docs.docker.com/compose/compose-file/)
- [React Native Best Practices](https://reactnative.dev/docs/performance)

---

## 💡 Astuces

```bash
# Créer app multi-stack (plusieurs apps dans 1 repo)
mkdir app-ios
mkdir app-android
mkdir app-web

# Chaque avec sa config:
docker-compose.yml (services multiples)

# Créer des scripts d'aide
mkdir scripts/
touch scripts/setup.sh
chmod +x scripts/setup.sh

# Script setup.sh
#!/bin/bash
docker-compose build
docker-compose run --rm cli npm install
docker-compose up -d
echo "✅ Ready! Visit http://localhost:19006"
```

---

**Vous êtes prêt à commencer ! 🚀**

Pour des questions, consultez README.md ou ARCHITECTURE.md.
