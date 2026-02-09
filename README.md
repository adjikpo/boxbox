# BoxBox - Docker Templates Collection

Templates Docker cle en main pour lancer rapidement des projets containerises.

---

## Templates disponibles

| Template | Stack | Description |
|----------|-------|-------------|
| [RNDock](RNDock/) | React Native + Expo | Apps mobiles containerisees |
| [DjangoDock](DjangoDock/) | Django + PostgreSQL | APIs et apps web Python |
| [VercelDock](VercelDock/) | Next.js + Supabase | Apps Vercel avec base de donnees |

---

## RNDock - React Native / Expo

Template Docker pour projets React Native avec Expo.

```bash
cd RNDock
make build
make create-project
make install
make dev
```

**Acces** : http://localhost:19006

**Fichiers** :
- [PROMPT_GENERATOR.md](RNDock/PROMPT_GENERATOR.md) - Prompt pour IA
- [README.md](RNDock/README.md) - Documentation
- [Makefile](RNDock/Makefile) - Commandes

---

## DjangoDock - Django + PostgreSQL

Template Docker pour projets Django avec PostgreSQL.

```bash
cd DjangoDock
chmod +x setup.sh
./setup.sh
cd [NOM_DU_PROJET]
make init
```

**Acces** : http://localhost:8000

**Fichiers** :
- [PROMPT_GENERATOR.md](DjangoDock/PROMPT_GENERATOR.md) - Prompt pour IA
- [README.md](DjangoDock/README.md) - Documentation
- [setup.sh](DjangoDock/setup.sh) - Script interactif

---

## VercelDock - Next.js + Supabase

Template Docker pour projets Next.js (Vercel) avec Supabase.

```bash
cd VercelDock
make build
make create-project
# Copier les fichiers Docker dans le projet cree
cp Dockerfile Dockerfile.dev docker-compose.yml Makefile .dockerignore [NOM_DU_PROJET]/
cd [NOM_DU_PROJET]
make install
make dev
```

**Acces** : http://localhost:3000

**Fichiers** :
- [PROMPT_GENERATOR.md](VercelDock/PROMPT_GENERATOR.md) - Prompt pour IA
- [README.md](VercelDock/README.md) - Documentation
- [Makefile](VercelDock/Makefile) - Commandes

---

## CLI rapide — boxbox.sh

Créer un projet en une commande :

```bash
# Lister les templates
./boxbox.sh list

# Créer un nouveau projet
./boxbox.sh new myapp --template vercel
./boxbox.sh new myapi --template django
./boxbox.sh new myapp --template rn
```

---

## Nouvelles commandes Make

Tous les templates supportent maintenant :

```bash
make status      # État des services
make test        # Lancer les tests
make lint        # Lancer le linter
make typecheck   # Vérification des types TypeScript
```

VercelDock uniquement :

```bash
make db-dump     # Export de la base PostgreSQL
make db-restore FILE=backup.sql  # Restaurer un backup
```

---

## Structure du depot

```
boxbox/
├── RNDock/                    # React Native + Expo
│   ├── PROMPT_GENERATOR.md
│   ├── README.md
│   ├── Makefile
│   ├── Dockerfile
│   ├── docker-compose.yml
│   └── ...
│
├── DjangoDock/                # Django + PostgreSQL
│   ├── PROMPT_GENERATOR.md
│   ├── README.md
│   ├── QUICKSTART.md
│   ├── setup.sh
│   └── ...
│
├── VercelDock/                # Next.js + Supabase
│   ├── PROMPT_GENERATOR.md
│   ├── README.md
│   ├── Makefile
│   ├── Dockerfile
│   ├── Dockerfile.dev
│   ├── docker-compose.yml
│   └── ...
│
└── README.md                  # Ce fichier
```

---

## Utilisation avec une IA

Chaque template contient un fichier `PROMPT_GENERATOR.md` avec un prompt a copier pour generer l'architecture via une IA (Claude, ChatGPT, etc.).

1. Ouvrir le `PROMPT_GENERATOR.md` du template souhaite
2. Copier le prompt
3. Remplacer `[NOM_DU_PROJET]` par le nom de ton projet
4. Coller dans une IA
5. L'IA genere les fichiers et les commandes

---

## Prerequis

- Docker Desktop (v20.10+)
- Docker Compose (v2.0+)
- Git

---

## Comparaison

| Feature | RNDock | DjangoDock | VercelDock |
|---------|--------|------------|------------|
| Stack | React Native + Expo | Django + PostgreSQL | Next.js + Supabase |
| Frontend | Expo (mobile + web) | Django templates | React (SSR) |
| Backend | - | Django REST | API Routes |
| Database | - | PostgreSQL | Supabase (PostgreSQL) |
| Setup | Makefile | Script interactif | Makefile |
| Port | 19006 | 8000 | 3000 |

---

## Commandes communes

Tous les templates utilisent un Makefile avec des commandes similaires :

```bash
make build          # Construire les images
make up             # Demarrer en arriere-plan
make dev            # Demarrer avec logs
make down           # Arreter
make logs           # Voir les logs
make shell          # Shell interactif
make clean          # Nettoyer (volumes inclus)
make install        # Installer les dependances
```

---

## Guide de selection

**App mobile** → [RNDock](RNDock/)
- React Native cross-platform
- Expo Go pour tests sur mobile

**API REST / Web app Python** → [DjangoDock](DjangoDock/)
- Django mature et stable
- Admin interface incluse

**App Next.js / Vercel** → [VercelDock](VercelDock/)
- Next.js 15 avec App Router
- Supabase pour la base de donnees

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
