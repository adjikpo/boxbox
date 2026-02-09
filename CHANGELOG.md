# CHANGELOG - BoxBox

Historique des versions et mises a jour de BoxBox.

---

## [1.2.0] - 2025-02-09

**Status** : Production Ready

### Nouveautés

#### CLI boxbox.sh
- Nouveau script CLI à la racine pour créer des projets rapidement
- `./boxbox.sh list` — liste les templates disponibles
- `./boxbox.sh new <nom> --template <vercel|django|rn>` — crée un nouveau projet

#### Docker Compose — tous les templates
- Retrait de `version: '3.8'` (deprecated Compose V2)
- Ajout de healthchecks sur les services principaux (web, expo)

#### VercelDock
- Retrait de WATCHPACK_POLLING et CHOKIDAR_USEPOLLING (inutiles)
- Ajout du service supabase-studio avec profil "full" (port 3001)
- Healthcheck sur le service web
- Bump Node.js 20 → 22 Alpine (Dockerfile + Dockerfile.dev)
- Fichier `.node-version` (22)

#### RNDock
- Healthcheck sur le service expo
- Fichier `.node-version` (22)

#### Makefiles — tous les templates
- Nouvelles commandes : `status`, `test`, `lint`, `typecheck`
- VercelDock : commandes `db-dump` et `db-restore`

#### CI/CD
- GitHub Actions workflow (`.github/workflows/ci.yml`)
- Vérification des fichiers, Makefiles, et conventions

#### Documentation
- `CONTRIBUTING.md` — guidelines pour ajouter un nouveau Dock
- README mis à jour avec le CLI et les nouvelles commandes

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
| RNDock | React Native + Expo | 1.1.0 |
| DjangoDock | Django + PostgreSQL | 1.0.0 |
| VercelDock | Next.js + Supabase | 1.0.0 |

---

## Roadmap

### v1.2 (A venir)
- [ ] Support Redis (caching)
- [ ] CI/CD (GitHub Actions)
- [ ] Template FastAPI
- [ ] Scripts de backup

### v2.0 (A venir)
- [ ] CLI tool pour scaffolding
- [ ] Web UI configuration
- [ ] Multi-cloud support

---

## Version numbering

Format : `MAJOR.MINOR.PATCH`

- **MAJOR** : Breaking changes
- **MINOR** : New features / templates
- **PATCH** : Bug fixes

---

**BoxBox** - Templates Docker cle en main
