# Prompt - Generateur d'Architecture Docker pour Next.js/Vercel + Supabase

Utilise ce prompt avec un assistant IA pour generer l'architecture Docker complete.

---

## PROMPT A COPIER

```
Cree une architecture Docker pour containeriser un projet Next.js (Vercel) avec Supabase.

### Nom du projet : [NOM_DU_PROJET]

### Structure de fichiers a generer :

1. **Dockerfile.dev** - Image Node 20 Alpine pour developpement :
   - Activer corepack + pnpm
   - Workdir : /app
   - Installer les dependances avec pnpm
   - Port expose : 3000
   - CMD : pnpm dev

2. **Dockerfile** - Image production multi-stage :
   - Stage deps : installer les dependances
   - Stage builder : build Next.js
   - Stage runner : image finale optimisee
   - Utilisateur non-root (nextjs)
   - Port expose : 3000

3. **docker-compose.yml** - Services :
   - **web** : Application Next.js
     - Build depuis Dockerfile.dev
     - Container name : [NOM_DU_PROJET]_web
     - Volumes : code source + node_modules persiste + .next exclu
     - Port : 3000 (configurable)
     - Environment : NODE_ENV=development, WATCHPACK_POLLING=true
     - depends_on : supabase-db

   - **supabase-db** : PostgreSQL pour Supabase
     - Image : supabase/postgres:15.1.0.147
     - Container name : [NOM_DU_PROJET]_db
     - Variables : POSTGRES_USER, POSTGRES_PASSWORD, POSTGRES_DB
     - Volume : supabase_data persistant
     - Port : 5432 (configurable)
     - Healthcheck : pg_isready

   - **supabase-studio** : Interface Supabase Studio (optionnel)
     - Image : supabase/studio:latest
     - Port : 3001
     - depends_on : supabase-db

   - **cli** : service pour commandes ponctuelles (pnpm install, etc.)
     - Meme image que web
     - Working_dir : /app
     - Volumes partages avec web

   - **create** : service dedie a la creation de projet (sans volume node_modules)
     - Meme image que web
     - Working_dir : /app
     - Volumes : SEULEMENT le code source (PAS de volume node_modules)

   - Volumes : node_modules, supabase_data
   - Network : app-network (bridge)

4. **Makefile** avec commandes :
   - help : affiche l'aide
   - build : docker-compose build
   - up : docker-compose up -d
   - dev : docker-compose up (foreground avec logs)
   - down : docker-compose down
   - stop : docker-compose stop
   - restart : docker-compose restart
   - logs : docker-compose logs -f
   - logs-web : logs du service web
   - logs-db : logs du service db
   - install : docker-compose run --rm cli pnpm install
   - shell : docker-compose run --rm cli sh
   - create-project : docker-compose run --rm create npx create-next-app (utilise le service "create")
   - add-package : ajouter un package pnpm
   - build-prod : build de production
   - clean : docker-compose down -v
   - db-shell : acceder a PostgreSQL
   - studio : ouvrir Supabase Studio

5. **.env.local.example** - Variables d'environnement :
   - NEXT_PUBLIC_APP_URL=http://localhost:3000
   - NEXT_PUBLIC_SUPABASE_URL=http://localhost:54321
   - NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key
   - SUPABASE_SERVICE_ROLE_KEY=your-service-role-key
   - DATABASE_URL=postgresql://postgres:postgres@supabase-db:5432/postgres

6. **.dockerignore** - Exclure :
   - .git, node_modules, .next, .env.local, .pnpm-store, IDE files

7. **.gitignore** - Exclure :
   - node_modules, .next, .env.local, .pnpm-store, coverage, IDE files, OS files

### Commandes Docker pour creer le projet :

Genere aussi les commandes a executer dans l'ordre :

1. Construire l'image Docker
2. Nettoyer les volumes existants si necessaire (make clean)
3. Creer un nouveau projet Next.js via le service "create" (sans volume node_modules)
4. Installer les dependances
5. Configurer les variables d'environnement (.env.local)
6. Lancer le serveur de developpement

Format des commandes :
- Utiliser docker-compose run --rm create pour la creation de projet
- Utiliser docker-compose run --rm cli pour les commandes pnpm
- Utiliser make pour simplifier l'usage quotidien
```

---

## EXEMPLE D'UTILISATION

Remplace `[NOM_DU_PROJET]` par le nom de ton projet, exemple : `myapp`

---

## COMMANDES DOCKER DE BASE

Une fois l'architecture generee, voici les commandes a executer :

```bash
# 1. Construire l'image Docker
make build

# 2. Nettoyer les volumes et dossiers existants (si necessaire)
make clean && rm -rf [NOM_DU_PROJET]

# 3. Creer un nouveau projet Next.js (utilise le service "create" sans volume node_modules)
make create-project

# 4. Copier les fichiers Docker dans le projet cree
cp Dockerfile Dockerfile.dev docker-compose.yml Makefile .dockerignore [NOM_DU_PROJET]/

# 5. Aller dans le projet
cd [NOM_DU_PROJET]

# 6. Configurer les variables d'environnement
cp .env.local.example .env.local
# Editer .env.local avec vos valeurs

# 7. Installer les dependances
make install

# 8. Lancer le serveur de dev
make dev
```

---

## COMMANDES UTILES AU QUOTIDIEN

```bash
# Demarrer en arriere-plan
make up

# Demarrer avec logs en direct
make dev

# Voir les logs
make logs

# Voir les logs Next.js uniquement
make logs-web

# Acceder au shell du container
make shell

# Arreter les services
make down

# Redemarrer les services
make restart

# Nettoyer tout (attention : supprime node_modules et BD)
make clean

# Installer un package pnpm
make add-package PKG=nom-du-package

# Build de production
make build-prod

# Acceder a PostgreSQL
make db-shell

# Ouvrir Supabase Studio
make studio
# Puis aller sur http://localhost:3001
```

---

## COMMANDES DOCKER COMPOSE DIRECTES

```bash
# Construire les images
docker-compose build

# Creer un projet (utilise le service "create" sans volume node_modules)
docker-compose run --rm create npx create-next-app@latest [NOM_DU_PROJET] --typescript --tailwind --eslint --app --src-dir --use-pnpm

# Installer les dependances
docker-compose run --rm cli pnpm install

# Demarrer Next.js
docker-compose up web

# Demarrer tous les services (Next.js + Supabase)
docker-compose up

# Arreter
docker-compose down

# Voir les logs
docker-compose logs -f web

# Shell interactif
docker-compose run --rm cli sh

# Ajouter un package
docker-compose run --rm cli pnpm add [PACKAGE]

# Build de production
docker-compose run --rm cli pnpm build

# Acceder a PostgreSQL
docker-compose exec supabase-db psql -U postgres -d postgres

# Nettoyer (supprime les volumes)
docker-compose down -v
```

---

## POURQUOI UN SERVICE "CREATE" SEPARE ?

Le volume `node_modules` est monte sur `/app/node_modules` pour persister les dependances.

**Probleme** : Si ce volume existe deja lors de la creation du projet, `create-next-app` detecte un dossier non vide et refuse de creer le projet.

**Solution** : Le service `create` ne monte PAS le volume `node_modules`, permettant une creation propre du projet.

---

## SERVICES DOCKER

| Service | Role | Port | Volume node_modules |
|---------|------|------|---------------------|
| web | Serveur Next.js dev | 3000 | Oui |
| supabase-db | PostgreSQL | 5432 | Non (supabase_data) |
| supabase-studio | Interface Supabase | 3001 | Non |
| cli | Commandes pnpm | - | Oui |
| create | Creation de projet | - | Non (evite le conflit) |

---

## ACCES

- **Next.js App** : http://localhost:3000
- **Supabase Studio** : http://localhost:3001
- **PostgreSQL** : localhost:5432

---

## STRUCTURE DU PROJET GENERE

```
[NOM_DU_PROJET]/
├── src/
│   ├── app/                 # App Router Next.js
│   ├── components/          # Composants React
│   ├── lib/                 # Utilitaires (supabase client, etc.)
│   └── styles/              # Styles CSS/Tailwind
├── public/                  # Assets statiques
├── Dockerfile               # Image production
├── Dockerfile.dev           # Image developpement
├── docker-compose.yml       # Orchestration services
├── Makefile                 # Commandes raccourcis
├── package.json
├── pnpm-lock.yaml
├── .env.local               # Variables d'environnement
├── .env.local.example
├── .dockerignore
├── .gitignore
├── next.config.mjs
├── tailwind.config.ts
└── tsconfig.json
```

---

## CONFIGURER SUPABASE

### 1. Variables d'environnement

Editer `.env.local` :

```bash
# Supabase local (Docker)
NEXT_PUBLIC_SUPABASE_URL=http://localhost:54321
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key

# Ou Supabase Cloud
# NEXT_PUBLIC_SUPABASE_URL=https://xxx.supabase.co
# NEXT_PUBLIC_SUPABASE_ANON_KEY=xxx
```

### 2. Installer le client Supabase

```bash
make add-package PKG=@supabase/supabase-js
```

### 3. Creer le client Supabase

Creer `src/lib/supabase.ts` :

```typescript
import { createClient } from '@supabase/supabase-js'

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL!
const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!

export const supabase = createClient(supabaseUrl, supabaseAnonKey)
```

---

## TROUBLESHOOTING

**"Directory not empty"**
```bash
make clean
rm -rf [NOM_DU_PROJET]
make create-project
```

**"Module not found"**
```bash
make install
# ou
make clean && make build && make install
```

**"Cannot connect to Supabase"**
```bash
# Verifier que le service db est demarre
make logs-db

# Redemarrer les services
make restart
```

**"Port 3000 already in use"**
```bash
# Modifier le port dans docker-compose.yml
# ports: "3001:3000"
make restart
```
