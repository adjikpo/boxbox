# Prompt - Generateur d'Architecture Docker pour Django

Utilise ce prompt avec un assistant IA pour generer l'architecture Docker complete.

---

## PROMPT A COPIER

```
Cree une architecture Docker pour containeriser un projet Django avec PostgreSQL.

### Nom du projet : [NOM_DU_PROJET]

### Structure de fichiers a generer :

1. **Dockerfile** (dans .docker/) - Image Python 3.11 slim avec :
   - Variables env : PYTHONUNBUFFERED=1, PYTHONDONTWRITEBYTECODE=1
   - Dependances systeme : postgresql-client
   - Workdir : /app
   - Installation des requirements.txt
   - Port expose : 8000
   - CMD par defaut : gunicorn

2. **docker-compose.yml** - Services :
   - **db** : PostgreSQL 15 Alpine
     - Container name : [NOM_DU_PROJET]_db
     - Variables : POSTGRES_DB, POSTGRES_USER, POSTGRES_PASSWORD
     - Volume : postgres_data persistant
     - Port : 5432 (configurable)
     - Healthcheck : pg_isready
     - Network : django_network

   - **web** : Django application
     - Build depuis .docker/Dockerfile
     - Container name : [NOM_DU_PROJET]_web
     - Command : migrate + collectstatic + gunicorn
     - Variables env depuis .env
     - Volumes : code source + static_volume + media_volume
     - Port : 8000 (configurable)
     - depends_on db (condition: service_healthy)
     - Network : django_network

   - **cli** : service pour commandes ponctuelles (manage.py, pip, etc.)
     - Meme image que web
     - Working_dir : /app
     - Volumes partages avec web
     - Pour executer des commandes Django sans demarrer le serveur

   - Volumes : postgres_data, static_volume, media_volume
   - Network : django_network (bridge)

3. **Makefile** avec commandes :
   - help : affiche l'aide
   - build : docker-compose build
   - up : docker-compose up -d
   - dev : docker-compose up (foreground avec logs)
   - down : docker-compose down
   - stop : docker-compose stop
   - restart : docker-compose restart
   - ps : docker-compose ps
   - logs : docker-compose logs -f
   - logs-web : logs du service web
   - logs-db : logs du service db
   - migrate : docker-compose exec web python manage.py migrate
   - migrations : docker-compose exec web python manage.py makemigrations
   - createsuperuser : docker-compose exec web python manage.py createsuperuser
   - collectstatic : docker-compose exec web python manage.py collectstatic --noinput
   - shell : docker-compose exec web python manage.py shell
   - bash-web : docker-compose exec web bash
   - bash-db : docker-compose exec db psql -U USER -d DB
   - test : docker-compose exec web pytest
   - clean : docker-compose down -v
   - init : build + up + migrate + createsuperuser
   - startapp : creer une nouvelle app Django

4. **requirements.txt** - Dependances Python :
   - Django==4.2.*
   - gunicorn==21.2.0
   - psycopg2-binary==2.9.9
   - python-decouple==3.8
   - dj-database-url==2.1.0
   - whitenoise==6.6.0
   - djangorestframework==3.14.0 (optionnel)
   - django-cors-headers==4.3.1 (optionnel)
   - pytest==7.4.3
   - pytest-django==4.7.0

5. **.env** et **.env.example** - Variables d'environnement :
   - DEBUG=True
   - SECRET_KEY=generation-automatique
   - ALLOWED_HOSTS=localhost,127.0.0.1
   - DATABASE_URL=postgresql://user:password@db:5432/dbname
   - DB_NAME, DB_USER, DB_PASSWORD, DB_HOST, DB_PORT

6. **config/** - Configuration Django :
   - settings.py : configuration Django avec python-decouple
   - urls.py : routing de base
   - wsgi.py : application WSGI

7. **manage.py** - Django CLI

8. **.dockerignore** - Exclure :
   - .git, __pycache__, .env, venv, .pytest_cache, staticfiles, media, IDE files

9. **.gitignore** - Exclure :
   - __pycache__, .env, venv, staticfiles, media, db.sqlite3, IDE files, .coverage

### Commandes Docker pour initialiser le projet :

Genere aussi les commandes a executer dans l'ordre :

1. Construire les images Docker
2. Demarrer les services (PostgreSQL + Django)
3. Executer les migrations
4. Creer un superutilisateur
5. Acceder a l'application

Format des commandes :
- Utiliser docker-compose exec web pour les commandes Django
- Utiliser docker-compose run --rm cli pour les commandes ponctuelles
- Utiliser make pour simplifier l'usage quotidien
```

---

## EXEMPLE D'UTILISATION

Remplace `[NOM_DU_PROJET]` par le nom de ton projet, exemple : `myapp`

---

## COMMANDES DOCKER DE BASE

Une fois l'architecture generee, voici les commandes a executer :

```bash
# 1. Construire les images Docker
make build

# 2. Demarrer les services
make up

# 3. Executer les migrations
make migrate

# 4. Creer un superutilisateur
make createsuperuser

# 5. Acceder a l'application
# Django : http://localhost:8000
# Admin : http://localhost:8000/admin
```

**OU en une seule commande :**

```bash
make init
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

# Voir les logs Django uniquement
make logs-web

# Acceder au shell Django
make shell

# Acceder au bash du container
make bash-web

# Acceder a PostgreSQL
make bash-db

# Arreter les services
make down

# Redemarrer les services
make restart

# Nettoyer tout (attention : supprime la BD)
make clean

# Creer une nouvelle app Django
make startapp APP=nom_app

# Creer les migrations
make migrations

# Executer les migrations
make migrate

# Executer les tests
make test
```

---

## COMMANDES DOCKER COMPOSE DIRECTES

Si tu preferes utiliser docker-compose directement :

```bash
# Construire les images
docker-compose build

# Demarrer les services
docker-compose up -d

# Arreter les services
docker-compose down

# Voir les logs
docker-compose logs -f

# Executer une commande Django
docker-compose exec web python manage.py [COMMANDE]

# Exemples :
docker-compose exec web python manage.py migrate
docker-compose exec web python manage.py createsuperuser
docker-compose exec web python manage.py makemigrations
docker-compose exec web python manage.py collectstatic --noinput
docker-compose exec web python manage.py shell
docker-compose exec web python manage.py startapp myapp

# Acceder a PostgreSQL
docker-compose exec db psql -U postgres -d [NOM_DB]

# Executer les tests
docker-compose exec web pytest

# Nettoyer (supprime les volumes)
docker-compose down -v
```

---

## ACCES

- **Django App** : http://localhost:8000
- **Django Admin** : http://localhost:8000/admin
- **PostgreSQL** : localhost:5432 (via DBeaver, pgAdmin, etc.)

---

## STRUCTURE DU PROJET GENERE

```
[NOM_DU_PROJET]/
├── .docker/
│   └── Dockerfile
├── config/
│   ├── __init__.py
│   ├── settings.py
│   ├── urls.py
│   └── wsgi.py
├── app/                    # Tes apps Django ici
├── static/
├── media/
├── templates/
├── docker-compose.yml
├── requirements.txt
├── manage.py
├── Makefile
├── .env
├── .env.example
├── .gitignore
├── .dockerignore
└── README.md
```

---

## AJOUTER UNE DEPENDANCE PYTHON

```bash
# 1. Editer requirements.txt
echo "django-celery==5.3.0" >> requirements.txt

# 2. Reconstruire l'image
make build

# 3. Redemarrer
make restart
```

---

## SAUVEGARDER / RESTAURER LA BD

```bash
# Sauvegarder
docker-compose exec db pg_dump -U postgres [NOM_DB] > backup.sql

# Restaurer
docker-compose exec -T db psql -U postgres [NOM_DB] < backup.sql
```

---

## TROUBLESHOOTING

**"Port 8000 already in use"**
```bash
# Changer le port dans .env ou docker-compose.yml
# Ou tuer le processus sur le port 8000
```

**"Connection refused" (BD)**
```bash
make clean
make build
make up
# Attendre que PostgreSQL demarre (healthcheck)
make migrate
```

**"Module not found"**
```bash
# Ajouter dans requirements.txt
echo "module-name" >> requirements.txt
make build
make restart
```
