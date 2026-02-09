# BoxBox - Docker Templates Collection

Templates Docker cle en main pour lancer rapidement des projets containerises.

---

## CLI BoxBox

Scaffolding rapide de projets :

```bash
# Lister les templates disponibles
./boxbox.sh list

# Creer un nouveau projet
./boxbox.sh new monprojet --template vercel
./boxbox.sh new monapi --template django
./boxbox.sh new monapp --template rn
```

---

## Templates disponibles

| Template | Stack | Description |
|----------|-------|-------------|
| [RNDock](RNDock/) | React Native + Expo | Apps mobiles containerisees |
| [DjangoDock](DjangoDock/) | Django + PostgreSQL | APIs et apps web Python |
| [VercelDock](VercelDock/) | Next.js 16 + Supabase | Apps Vercel avec base de donnees |

---

## RNDock - React Native / Expo

```bash
cd RNDock
make init    # Setup complet one-shot
make dev
```

**Acces** : http://localhost:19006

---

## DjangoDock - Django + PostgreSQL

```bash
cd DjangoDock
chmod +x setup.sh
./setup.sh
cd [NOM_DU_PROJET]
make init
```

**Acces** : http://localhost:8000

---

## VercelDock - Next.js 16 + Supabase

```bash
cd VercelDock
make init    # Setup complet one-shot
cd myapp
make install
make dev
```

**Acces** : http://localhost:3000 | Studio (profile full) : http://localhost:3001

---

## Commandes communes

Tous les templates utilisent un Makefile avec des commandes standardisees :

```bash
# Initialisation
make init               # Setup complet one-shot

# Developpement
make build              # Construire les images
make up                 # Demarrer en arriere-plan
make dev                # Demarrer avec logs
make down               # Arreter
make restart            # Redemarrer

# Qualite
make test               # Lancer les tests
make lint               # Linter le code
make typecheck          # Verifier les types

# Utilitaires
make logs               # Voir les logs
make shell              # Shell interactif
make status             # Etat des containers + URLs
make install            # Installer les dependances
make clean              # Nettoyer (volumes inclus)

# Base de donnees (VercelDock, DjangoDock)
make db-shell           # Acceder a PostgreSQL
make db-dump            # Dump de la base
make db-restore SQL=f   # Restaurer un dump
```

---

## Profils Docker Compose

Services de base par defaut. Pour activer Supabase Studio et les extras :

```bash
docker compose --profile full up -d
```

---

## Structure du depot

```
boxbox/
├── boxbox.sh              # CLI BoxBox
├── CONTRIBUTING.md        # Guide de contribution
├── CHANGELOG.md           # Historique des versions
├── .github/workflows/     # CI GitHub Actions
│
├── RNDock/                # React Native + Expo
├── DjangoDock/            # Django + PostgreSQL
├── VercelDock/            # Next.js 16 + Supabase
│
└── README.md              # Ce fichier
```

---

## Comparaison

| Feature | RNDock | DjangoDock | VercelDock |
|---------|--------|------------|------------|
| Stack | React Native + Expo | Django + PostgreSQL | Next.js 16 + Supabase |
| Frontend | Expo (mobile + web) | Django templates | React (SSR) |
| Backend | - | Django REST | API Routes |
| Database | - | PostgreSQL | Supabase (PostgreSQL) |
| Setup | `make init` | `./setup.sh` | `make init` |
| Port | 19006 | 8000 | 3000 |

---

## Prerequis

- Docker Desktop (v20.10+)
- Docker Compose V2
- Git

---

## Ressources

- [Docker Documentation](https://docs.docker.com)
- [React Native Docs](https://reactnative.dev)
- [Expo Documentation](https://docs.expo.dev)
- [Django Documentation](https://docs.djangoproject.com)
- [Next.js Documentation](https://nextjs.org/docs)
- [Supabase Documentation](https://supabase.com/docs)

---

**BoxBox** - Templates Docker cle en main

Creez des projets professionnels en minutes !
