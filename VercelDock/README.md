# VercelDock - Next.js / Vercel + Supabase Docker Template

Template Docker pour containeriser des projets Next.js (Vercel) avec Supabase.

---

## Demarrage rapide

### Option 1 : Utiliser le Makefile

```bash
# 1. Copier VercelDock dans votre dossier projet
cp -r VercelDock ~/mon-projet
cd ~/mon-projet

# 2. Modifier PROJECT_NAME dans le Makefile (ligne 5)
# PROJECT_NAME ?= MonApp

# 3. Modifier [NOM_DU_PROJET] dans docker-compose.yml
# Remplacer toutes les occurrences par le nom de votre projet

# 4. Construire et creer le projet
make build
make create-project

# 5. Copier les fichiers Docker dans le projet cree
cp Dockerfile Dockerfile.dev docker-compose.yml Makefile .dockerignore [NOM_DU_PROJET]/
cd [NOM_DU_PROJET]

# 6. Installer et lancer
make install
make dev
```

### Option 2 : Utiliser le prompt IA

Voir [PROMPT_GENERATOR.md](PROMPT_GENERATOR.md) pour generer l'architecture via une IA.

---

## Structure du projet

```
[NOM_DU_PROJET]/
├── src/
│   ├── app/                 # App Router Next.js
│   ├── components/          # Composants React
│   └── lib/                 # Utilitaires (supabase client)
├── public/                  # Assets statiques
├── Dockerfile               # Image production
├── Dockerfile.dev           # Image developpement
├── docker-compose.yml       # Services : web, supabase-db, cli, create
├── Makefile                 # Commandes raccourcis
├── package.json
├── pnpm-lock.yaml
├── .env.local
├── .dockerignore
├── .gitignore
├── next.config.mjs
├── tailwind.config.ts
└── tsconfig.json
```

---

## Commandes Makefile

```bash
# Initialisation
make build                    # Construire les images Docker
make create-project           # Creer un nouveau projet Next.js
make install                  # Installer les dependances pnpm

# Developpement
make up                       # Demarrer en arriere-plan
make dev                      # Demarrer avec logs
make down                     # Arreter les services
make stop                     # Pause les services
make restart                  # Redemarrer les services

# Utilitaires
make shell                    # Shell dans le container
make logs                     # Voir tous les logs
make logs-web                 # Logs Next.js
make logs-db                  # Logs PostgreSQL
make add-package PKG=name     # Ajouter un package pnpm
make build-prod               # Build de production
make db-shell                 # Acceder a PostgreSQL
make supabase-install         # Installer @supabase/supabase-js

# Nettoyage
make clean                    # Supprimer containers et volumes
make prune                    # Nettoyage complet Docker
```

---

## Commandes Docker Compose directes

```bash
# Construire les images
docker-compose build

# Creer un projet Next.js (utilise le service "create" sans volume node_modules)
docker-compose run --rm create npx create-next-app@latest [NOM_DU_PROJET] --typescript --tailwind --eslint --app --src-dir --use-pnpm

# Installer les dependances
docker-compose run --rm cli pnpm install

# Demarrer Next.js + Supabase
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

## Services Docker

| Service | Role | Port |
|---------|------|------|
| web | Serveur Next.js dev | 3000 |
| supabase-db | PostgreSQL | 5432 |
| cli | Commandes pnpm | - |
| create | Creation de projet | - |

---

## Configurer Supabase

### 1. Installer le client

```bash
make supabase-install
# ou
make add-package PKG=@supabase/supabase-js
```

### 2. Variables d'environnement

Creer `.env.local` :

```bash
# Next.js
NEXT_PUBLIC_APP_URL=http://localhost:3000

# Supabase (local Docker)
NEXT_PUBLIC_SUPABASE_URL=http://localhost:5432
DATABASE_URL=postgresql://postgres:postgres@supabase-db:5432/postgres

# Supabase (Cloud - optionnel)
# NEXT_PUBLIC_SUPABASE_URL=https://xxx.supabase.co
# NEXT_PUBLIC_SUPABASE_ANON_KEY=xxx
# SUPABASE_SERVICE_ROLE_KEY=xxx
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

## Acces

- **Next.js App** : http://localhost:3000
- **PostgreSQL** : localhost:5432 (user: postgres, password: postgres)

---

## Troubleshooting

**"Directory not empty"**
```bash
make clean
rm -rf [NOM_DU_PROJET]
make create-project
```

**"Module not found"**
```bash
make install
```

**"Cannot connect to database"**
```bash
make logs-db
make restart
```

**"Port 3000 already in use"**
```bash
# Modifier le port dans docker-compose.yml : "3001:3000"
make restart
```

---

## Ressources

- [Next.js Documentation](https://nextjs.org/docs)
- [Supabase Documentation](https://supabase.com/docs)
- [Vercel Documentation](https://vercel.com/docs)
- [Docker Documentation](https://docs.docker.com/)

---

**VercelDock** - Template Docker pour projets Next.js/Vercel + Supabase

Pour demarrer : voir [PROMPT_GENERATOR.md](PROMPT_GENERATOR.md) ou utiliser le Makefile
