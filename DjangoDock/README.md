# DjangoDock - Django Docker Automation

Template complet et automatise pour creer des projets Django avec Docker/Docker Compose.

**DjangoDock** automatise entierement la creation d'un projet Django containerise via des commandes Docker. Aucune installation locale de Python/Pip requise.

---

## Caracteristiques

- Automatisation complete : Script interactif `setup.sh` OU prompt IA
- Docker-first : Tout via Docker (pas d'installation locale Python)
- Configuration interactive : Ports, versions, BD personnalisables
- Django LTS : Support Django 4.2 LTS et versions personnalisees
- PostgreSQL : Base de donnees production-ready
- Makefile : 20+ commandes raccourcis
- Pret a developper : Structure complete incluse

---

## Demarrage rapide

### Option 1 : Utiliser le script setup.sh

```bash
# Copier le dossier DjangoDock
cp -r DjangoDock ~/mon-projet
cd ~/mon-projet

# Lancer le script
chmod +x setup.sh
./setup.sh
```

### Option 2 : Utiliser le prompt IA

Voir [PROMPT_GENERATOR.md](PROMPT_GENERATOR.md) pour generer l'architecture via une IA.

### Suivre les prompts interactifs

Le script demandera :
- Nom du projet (defaut: `django_project`)
- Port web Django (defaut: `8000`)
- Port PostgreSQL (defaut: `5432`)
- Version Django (defaut: `4.2`)
- Version Python (defaut: `3.11`)
- Informations BD (nom, user, password)

### Initialiser le projet cree

```bash
cd [NOM_DU_PROJET]
make init
```

### Acceder a Django

- Django Admin : http://localhost:8000/admin
- Site web : http://localhost:8000

---

## Structure du projet genere

```
[NOM_DU_PROJET]/
├── .docker/
│   └── Dockerfile                 # Image Django + dependencies
├── config/                        # Configuration Django
│   ├── settings.py               # Django settings
│   ├── urls.py                   # URL routing
│   └── wsgi.py                   # WSGI app
├── app/                          # Applications Django
├── static/                       # Fichiers statiques
├── media/                        # Fichiers uploadés
├── docker-compose.yml            # Orchestration services
├── requirements.txt              # Dépendances Python
├── manage.py                     # Django management
├── Makefile                      # Commandes raccourcis
├── .env                          # Variables d'environnement
├── .env.example                  # Template .env
├── .gitignore                    # Exclusions Git
├── .dockerignore                 # Exclusions Docker
└── README.md                     # Documentation du projet
```

### Services Docker

**PostgreSQL** (Port configurable)
- Base de donnees production-ready
- Volume persistant
- Health checks

**Django Web** (Port configurable)
- Gunicorn WSGI server
- Django 4.2 LTS
- Migrations automatiques
- Collecte des statiques

---

## Commandes Makefile

```bash
# Initialisation
make init           # Build + migrate + createsuperuser

# Gestion des services
make build          # Builder les images Docker
make up             # Demarrer les services
make down           # Arreter les services
make restart        # Redemarrer les services
make ps             # Etat des containers
make dev            # Mode developpement (logs en direct)

# Commandes Django
make migrate        # Executer les migrations
make migrations     # Creer les migrations
make createsuperuser # Creer un admin
make collectstatic  # Collecter les fichiers statiques
make shell          # Django shell interactif
make test           # Executer les tests

# Acces
make bash-web       # Shell du container Django
make bash-db        # PostgreSQL psql

# Logs
make logs           # Tous les logs
make logs-web       # Logs Django
make logs-db        # Logs PostgreSQL

# Nettoyage
make clean          # Arreter et supprimer les volumes
```

---

## Commandes Docker Compose directes

```bash
# Demarrer
docker-compose up -d

# Arreter
docker-compose down

# Logs
docker-compose logs -f

# Executer une commande Django
docker-compose exec web python manage.py [COMMANDE]

# Executer psql
docker-compose exec db psql -U postgres -d [NOM_DB]

# Etat
docker-compose ps
```

---

## Base de donnees PostgreSQL

```bash
# Acceder a PostgreSQL via Makefile
make bash-db

# Acceder via docker-compose
docker-compose exec db psql -U postgres -d [NOM_DB]

# Sauvegarder
docker-compose exec db pg_dump -U postgres [NOM_DB] > backup.sql

# Restaurer
docker-compose exec -T db psql -U postgres [NOM_DB] < backup.sql
```

---

## Ajouter une app Django

```bash
docker-compose exec web python manage.py startapp [NOM_APP]
```

---

## Ajouter une dependance Python

```bash
# Editer requirements.txt
echo "nouvelle-lib==1.0.0" >> requirements.txt

# Reconstruire et redemarrer
make build && make restart
```

---

## Troubleshooting

**"Port 8000 already in use"**
```bash
# Changer le port dans .env puis redemarrer
make restart
```

**"Connection refused" (BD)**
```bash
make clean && make build && make up
```

**"Module not found"**
```bash
echo "module-name" >> requirements.txt
make build && make restart
```

---

## Ressources

- [Django Documentation](https://docs.djangoproject.com/)
- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Reference](https://docs.docker.com/compose/)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)

---

**DjangoDock** - Template Docker pour projets Django

Pour demarrer : `./setup.sh` ou voir [PROMPT_GENERATOR.md](PROMPT_GENERATOR.md)
