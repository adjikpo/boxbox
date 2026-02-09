# CHANGELOG - BoxBox

Historique des versions et mises a jour de BoxBox.

---

## [1.2.0] - 2026-02-09

**Status** : Production Ready

### Nouveautes

#### CLI BoxBox
- Nouveau script `boxbox.sh` a la racine : `boxbox new monprojet --template vercel|django|rn` + `boxbox list`
- Remplacement automatique des placeholders [NOM_DU_PROJET]

#### GitHub Actions
- CI basique `.github/workflows/ci.yml` : lint + typecheck + build pour chaque template

#### CONTRIBUTING.md
- Guide de contribution ajoute a la racine du repo

### Ameliorations

#### Bump des versions
- Node 22 Alpine dans tous les Dockerfiles (VercelDock, RNDock)
- Supabase Postgres 15.6+ (`supabase/postgres:15.6.1.120`)
- References Next.js 16 dans la documentation
- Fichiers `.node-version` dans VercelDock et RNDock

#### `make init` one-shot
- Commande `make init` dans chaque template : build + create + cp fichiers + install en une commande

#### Hot-reload natif
- Suppression de WATCHPACK_POLLING et CHOKIDAR_USEPOLLING dans VercelDock (VirtioFS natif macOS)

#### Docker Compose modernise
- Suppression de `version: '3.8'` dans tous les docker-compose.yml (deprecated Compose V2)
- Migration de `docker-compose` vers `docker compose` dans les Makefiles

#### Supabase Studio
- Ajout du service Supabase Studio dans le docker-compose.yml de VercelDock (port 3001)

#### Profils Docker Compose
- Services de base par defaut, Studio/extras avec `--profile full`

#### Healthchecks uniformes
- Healthchecks ajoutes aux services web dans tous les docker-compose.yml

#### Nouvelles commandes Makefile
- `make test` — Lancer les tests
- `make lint` — Linter le code
- `make typecheck` — Verifier les types
- `make status` — Etat des containers + ports + URLs
- `make db-dump` — Dump PostgreSQL (VercelDock, DjangoDock)
- `make db-restore SQL=file.sql` — Restaurer PostgreSQL (VercelDock, DjangoDock)

---

## [1.1.0] - 2025-01-10

**Status** : Production Ready

### Nouveautes

#### VercelDock - NOUVEAU
- Template Docker pour Next.js (Vercel) + Supabase
- Dockerfile.dev pour developpement
- Dockerfile multi-stage pour production
- docker-compose.yml avec services : web, supabase-db, cli, create
- Makefile avec commandes completes
- Support pnpm
- PostgreSQL via Supabase

#### PROMPT_GENERATOR.md - Ameliore
- Ajout section CLAUDE.md (instructions projet)
- Ajout section ROADMAP.md (planification)
- Prompt "Workflow Complet" pour nouveau projet
- Exemple de workflow feature avec GitHub

#### Documentation
- README principal simplifie avec tableau comparatif
- Tous les templates generalises (suppression chemins specifiques)
- Placeholders [NOM_DU_PROJET] uniformises

---

## [1.0.0] - 2024-10-29

**Status** : Production Ready

### RNDock - v1.0.0

#### Features
- Template React Native + Expo
- Docker Compose : 3 services (expo, cli, create)
- Makefile : 20+ commandes
- Volumes persistants
- Service "create" separe pour eviter conflit node_modules

#### Documentation
- README.md
- PROMPT_GENERATOR.md
- Makefile

### DjangoDock - v1.0.0

#### Features
- Script setup.sh interactif
- Django 4.2 LTS + PostgreSQL 15
- Gunicorn pour production
- Makefile : 20+ commandes

#### Documentation
- README.md
- QUICKSTART.md
- PROMPT_GENERATOR.md
- setup.sh

---

## Templates disponibles

| Template | Stack | Version |
|----------|-------|---------|
| RNDock | React Native + Expo | 1.2.0 |
| DjangoDock | Django + PostgreSQL | 1.2.0 |
| VercelDock | Next.js + Supabase | 1.2.0 |

---

## Roadmap

### v1.3 (A venir)
- [ ] Support Redis (caching)
- [ ] Template FastAPI
- [ ] Multi-cloud support

### v2.0 (A venir)
- [ ] CLI tool en Go/Rust
- [ ] Web UI configuration

---

**BoxBox** - Templates Docker cle en main
